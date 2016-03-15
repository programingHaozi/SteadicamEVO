//
//  BlueToothConnector.m
//  OBD-DEMO
//
//  Created by zhangjipeng on 1/26/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlueToothConnector.h"
#import "OBDDeviceSelfDefineType.h"
#import "RKBlueKit.h"
#import "RKCentralManager.h"
#import "RKPeripheralManager.h"
#import "RKPeripheral.h"
#import "CBUUID+RKBlueKit.h"
#import "RKBlueBlocks.h"
#import "DataProcessor.h"


@interface BlueToothConnector ()

@property (nonatomic, assign) BOOL isCentralManager;
//@property (nonatomic, assign) BOOL centralManagerIsReady;
@property (nonatomic, copy) NSString *peripheralName;
@property (nonatomic, copy) NSString *serviceUUID;

/**
 *  完成回调
 */
@property (nonatomic, copy) void (^completionBlock)(NSInteger);
/**
 *  断开连接回调
 */
@property (nonatomic, copy) void (^disconnectionBlock)(NSError*);

/**
 *  连接回调
 */
@property (nonatomic, copy) void (^connectionBlock)(NSInteger result);

@property (nonatomic,strong) NSArray *services;
@property (nonatomic,strong) CBService *service;

@property (nonatomic,strong) RKPeripheral *peripheral;
@property (nonatomic,strong) RKPeripheralManager *peripheralManager;
@property (nonatomic,strong) RKCentralManager *centralManager;
@property (nonatomic,strong) CBCharacteristic *readCharacteristic;
@property (nonatomic,strong) CBCharacteristic *writeCharacteristic;

@property (nonatomic,strong) NSString *pendingValue;

@end

@implementation BlueToothConnector

@dynamic connectMode;

+ (instancetype)sharedInstance {
    static BlueToothConnector *btConnector = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        btConnector = [BlueToothConnector new];
    });
    return btConnector;
}

- (instancetype)init {
    if (self = [super init]) {
        //self.centralManagerIsReady = NO;
    }
    return self;
}

- (void)initCentralManager:(void (^)(BOOL isOk, NSError *error))completion {
    NSDictionary * opts = nil;
    //if (!self.centralManager/* || !self.centralManagerIsReady*/)
    {
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
            opts = @{CBCentralManagerOptionShowPowerAlertKey:@YES};
        }
        self.centralManager = [[RKCentralManager alloc] initWithQueue:nil options:opts];
        __weak BlueToothConnector * weakSelf = self;
        if (self.centralManager.state != CBCentralManagerStatePoweredOn) {
            self.centralManager.onStateChanged = ^(NSError * error){
                if (weakSelf.centralManager.state == CBCentralManagerStatePoweredOn) {
                    //weakSelf.centralManagerIsReady = YES;
                    DDLogInfo(@"centralManager is ready!");
                    if (completion) {
                        completion(YES, nil);
                    }
                } else {
                    //weakSelf.centralManagerIsReady = NO;
                    DDLogInfo(@"centralManager is not ready!");
                    if (completion) {
                        completion(NO, nil);
                    }
                }
            };
        } else {
            //weakSelf.centralManagerIsReady = NO;
            DDLogInfo(@"centralManager is ready!");
            if (completion) {
                completion(YES, nil);
            }
        }
    }
    /*else {
        BOOL isReady = (self.centralManager.state == CBCentralManagerStatePoweredOn);
       
        DDLogInfo(@"centralManager is ready!");
        if (completion) {
            completion(isReady, nil);
        }
    }
    */
}


- (void)discoverServiceAndCharacteristic:(RKPeripheral *)peripheral withDataProcessor:(DataProcessor *)dataProcessor completion:(void (^)(NSInteger result))completion {
    __weak BlueToothConnector * weakSelf = self;
    [peripheral discoverServices:@[[CBUUID UUIDWithString: kBLEServiceUUID]]
                        onFinish:^(NSError *error) {
                            weakSelf.service = [peripheral.services firstObject];
                            DDLogInfo(@"Discovered Service : %@",weakSelf.service);
                            [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString: kBLECharacteristicNofiy],[CBUUID UUIDWithString: kBLECharacteristicWrite]]
                                                     forService:weakSelf.service
                                                       onFinish:^(CBService *service, NSError *error) {
                                                           for (CBCharacteristic *characteristic in service.characteristics) {
                                                               if ((characteristic.properties &CBCharacteristicPropertyWrite) !=0 ||
                                                                   (characteristic.properties &CBCharacteristicPropertyWriteWithoutResponse) !=0) {
                                                                   self.writeCharacteristic = characteristic;
                                                                   DDLogDebug(@"Discovered Characteristic : %@",self.writeCharacteristic);
                                                                   continue;
                                                               }

                                                               if ((characteristic.properties & CBCharacteristicPropertyNotify)) {
                                                                   self.readCharacteristic = characteristic;
                                                                   DDLogDebug(@"Discovered Characteristic : %@",self.readCharacteristic);
                                                                   continue;
                                                               }
                                                           }
                                                           
                                                           DDLogInfo(@"Set Notify Callback For Characteristic : %@",self.readCharacteristic);
                                                           [self.peripheral setNotifyValue:YES forCharacteristic:self.readCharacteristic onUpdated:^(CBCharacteristic *characteristic, NSError *error) {
                                                               NSData *data = characteristic.value;
                                                               Byte *p = (Byte *)[data bytes];
                                                               NSString *rawValue = nil;
                                                               
                                                               if (*p > 0x7f) {
                                                                   DDLogVerbose(@"received raw binary data:%lX",(long)*p);
                                                                   rawValue = [NSString stringWithFormat:@"%lX\r\n",(long)*p];
                                                               } else {
                                                                   rawValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                   DDLogVerbose(@"received raw data:%@",rawValue);
                                                               }

                                                               if (weakSelf.pendingValue) {
                                                                   if (![rawValue isEqual:@"?"]) {
                                                                       rawValue = [NSString stringWithFormat:@"%@%@",weakSelf.pendingValue,rawValue];
                                                                   }
                                                                   weakSelf.pendingValue = nil;
                                                               }
                                                               
                                                               NSMutableArray *rawValues = [NSMutableArray arrayWithArray:[rawValue componentsSeparatedByString:kBluetoothValueSplit]];
                                                               if (![rawValue hasSuffix:kBluetoothValueSplit]) {
                                                                   weakSelf.pendingValue = [rawValues lastObject];
                                                                   [rawValues removeObject:weakSelf.pendingValue];
                                                               }
                                                               
                                                               for (NSString *value in rawValues) {
                                                                   if (dataProcessor.dataReceived && [value length]) {
                                                                       dataProcessor.dataReceived(value);
                                                                   }
                                                               }
                                                           }];
                                                           
                                                           DDLogInfo(@"Did connect to device %@",peripheral.name);
                                                           if (completion) {
                                                               completion(0);
                                                           }
                                                       }];
                        }];
}

- (void)connectPeripheral:(RKPeripheral *)peripheral withConfidential:(DeviceConfidential *)confidential AndDataProcessor:(DataProcessor *)dataProcessor completion:(void (^)(NSInteger result))completion {
    __weak BlueToothConnector * weakSelf = self;
    // 连接设备时的超时处理
    __block BOOL timeout = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (timeout) {
            [self.centralManager cancelPeripheralConnection:peripheral onFinished:^(RKPeripheral *peripheral, NSError *error) {
                
            }];
            DDLogInfo(@"Connect to %@ failed!",peripheral.name);
            if (completion) {
                completion(2);
            }
        }
    });
    [self.centralManager connectPeripheral:peripheral
                                       options:nil
                                    onFinished:^(RKPeripheral *peripheral, NSError *error) {
                                        timeout = NO;
                                        [weakSelf discoverServiceAndCharacteristic:peripheral
                                                                 withDataProcessor:dataProcessor
                                                                        completion:^(NSInteger result) {
                                                                            if (result == 0) {
                                                                                if (completion) {
                                                                                    completion(0);
                                                                                }
                                                                                /*
                                                                                NSString *password = [NSString stringWithFormat:@"ATDVI"];
                                                                                DDLogVerbose(@"Write ATDVI to OBD.");
                                                                                NSData *data = [[password stringByAppendingString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding];
                                                                                [weakSelf sendData:data];
                                                                                 */
                                                                            } else {
                                                                                if (completion) {
                                                                                    completion(2);
                                                                                }
                                                                            }
                                                                        }];
                                    } onDisconnected:^(RKPeripheral *peripheral, NSError *error) {
                                        DDLogInfo(@"Did disconnect to device %@",peripheral.name);
                                        if (_disconnectionBlock) {
                                            _disconnectionBlock(error);
                                            // 将断开连接的回调置为空，防止断开连接时多次回调
                                            _disconnectionBlock = nil;
                                        }
                                    }];
}

#pragma mark - Connector protocol

- (TorqueDeviceConnetMode)connectMode {
    return TorqueDeviceConnetModeBT;
}


- (void)discoverDevice:(void (^)(NSArray *devices))completion {
    NSMutableArray *devices = [NSMutableArray array];
    [self initCentralManager:^(BOOL isOk, NSError *error) {
        if (isOk) {
            // 搜索设备时的超时处理
            __block BOOL end = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kScanPeripheralTimeoutSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (!end) {
                    [self.centralManager stopScan];
                    DDLogInfo(@"Discover Device End!");
                    if (completion) {
                        completion(devices);
                    }
                }
            });
            
            // 如果设备已经连接，直接返回
            if (self.peripheral.state == CBPeripheralStateConnected && [self.peripheral.name isEqualToString:self.peripheralName]) {
                end = YES;
                DDLogInfo(@"Discover Device End!");
                if (completion) {
                    completion(@[self.peripheral.name]);
                }
                return;
            }
            
#if 0 //def DEBUG
            // 搜索设备
            [self.centralManager scanForPeripheralsWithServices:nil
                                                        options:nil
                                                      onUpdated:^(RKPeripheral *peripheral) {
                                                          if ([peripheral.name hasPrefix:kBLENamePrefix] || [peripheral.name hasPrefix:@"EST530"]) {
                                                              DDLogInfo(@"Discovered device: %@",peripheral.name);
                                                              [devices addObject:peripheral.name];
                                                          }
                                                      }];
#else
            // 指定ServiceUUID搜索设备
            [self.centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString: kBLEServiceUUID]]
                                                        options:nil
                                                      onUpdated:^(RKPeripheral *peripheral) {
                                                          if ([peripheral.name hasPrefix:kBLENamePrefix]) {
                                                              DDLogDebug(@"Discovered device: %@",peripheral.name);
                                                              [devices addObject:peripheral.name];
                                                          }
                                                      }];
#endif
        } else {
            if (completion) {
                completion(devices);
            }
        }
    }];
}


- (void)discoverDeviceNext:(BOOL (^)(NSString *deviceName))next completion:(void (^)(BOOL timeout))completion error:(void (^)(NSError *error))errorBlock; {
    [self initCentralManager:^(BOOL isOk, NSError *error) {
        if (isOk) {
            // 搜索设备时的超时处理
            __block BOOL timeout = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kScanPeripheralTimeoutSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (timeout) {
                    [self.centralManager stopScan];
                    DDLogInfo(@"Discover Device Time Out!");
                    if (completion) {
                        completion(timeout);
                    }
                }
            });
            
            // 如果设备已经连接，直接返回
            if (self.peripheral.state == CBPeripheralStateConnected && [self.peripheral.name isEqualToString:self.peripheralName]) {
                timeout = NO;
                DDLogInfo(@"Discovered device: %@",self.peripheral.name);
                if (next) {
                    next(self.peripheral.name);
                    DDLogInfo(@"Discover Device End!");
                    if (completion) {
                        completion(timeout);
                    }
                }
                return;
            }
            
#if 0 //def DEBUG
            // 搜索设备
            [self.centralManager scanForPeripheralsWithServices:nil
                                                        options:nil
                                                      onUpdated:^(RKPeripheral *peripheral) {
                                                          if ([peripheral.name hasPrefix:kBLENamePrefix] || [peripheral.name hasPrefix:@"EST530"]) {
                                                              DDLogInfo(@"Discovered device: %@",peripheral.name);
                                                              if (next) {
                                                                  BOOL find = NO;
                                                                  find = next(peripheral.name);
                                                                  if (find) {
                                                                      timeout = NO;
                                                                      DDLogVerbose(@"find device timeout %d.",timeout);
                                                                      [self.centralManager stopScan];
                                                                      DDLogWarn(@"Discover Device End!");
                                                                      if (completion) {
                                                                          completion(timeout);
                                                                      }
                                                                  }
                                                              }
                                                          }
                                                      }];
#else
            // 指定ServiceUUID搜索设备
            [self.centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString: kBLEServiceUUID]]
                                                        options:nil
                                                      onUpdated:^(RKPeripheral *peripheral) {
                                                          if ([peripheral.name hasPrefix:kBLENamePrefix]) {
                                                              DDLogInfo(@"Discovered device: %@",peripheral.name);
                                                              if (next) {
                                                                  BOOL find = NO;
                                                                  find = next(peripheral.name);
                                                                  if (find) {
                                                                      timeout = NO;
                                                                      DDLogDebug(@"find device timeout %d.",timeout);
                                                                      [self.centralManager stopScan];
                                                                      DDLogDebug(@"Discover Device End!");
                                                                      if (completion) {
                                                                          completion(timeout);
                                                                      }
                                                                  }
                                                              }
                                                          }
                                                      }];
#endif
        } else {
            if (errorBlock) {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"蓝牙初始化失败！"
                                                                     forKey:NSLocalizedDescriptionKey];
                NSError *aError = [NSError errorWithDomain:OBDErrorDomain code:OBDErrorDiscoverDeviceFailed userInfo:userInfo];
                errorBlock(aError);
            }
        }
    }];
}


- (void)connectDevice:(DeviceInfo *)device withConfidential:(DeviceConfidential *)confidential AndDataProcessor:(DataProcessor *)dataProcessor completion:(void (^)(NSInteger result))completion disconnection:(void (^)(NSError *))disconnection {
    // 设置断开连接回调
    _disconnectionBlock = disconnection;
    _connectionBlock = completion;
    self.peripheralName = device.name;
    [self initCentralManager:^(BOOL isOk, NSError *error) {
        if (isOk) {
            // 搜索设备时的超时处理
            __block BOOL timeout = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kScanPeripheralTimeoutSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (timeout) { //(!self.peripheral || self.peripheral.state != CBPeripheralStateConnected) {
                    DDLogWarn(@"Discover Device Time Out!");
                    [self.centralManager stopScan];
                    if (_connectionBlock) {
                        _connectionBlock(1);
                    }
                }
            });
            
            // 如果设备已经连接，直接返回
            if (self.peripheral.state == CBPeripheralStateConnected && [self.peripheral.name isEqualToString:self.peripheralName]) {
                timeout = NO;
                if (_connectionBlock) {
                    _connectionBlock(0);
                }
                return;
            }
    
#if 0 //def DEBUG
            // 搜索设备，并连接
            __weak BlueToothConnector * weakSelf = self;
            [self.centralManager scanForPeripheralsWithServices:nil
                                                        options:nil
                                                      onUpdated:^(RKPeripheral *peripheral) {
                                                          DDLogInfo(@"Discovered device: %@",peripheral.name);
                                                          if ([peripheral.name isEqual:weakSelf.peripheralName]) {
                                                              timeout = NO;
                                                              [weakSelf.centralManager stopScan];
                                                              weakSelf.peripheral = peripheral;
                                                              if (peripheral.state == CBPeripheralStateDisconnected) {
                                                                  [weakSelf connectPeripheral:peripheral
                                                                             withConfidential:confidential
                                                                             AndDataProcessor:dataProcessor
                                                                                   completion:_connectionBlock];
                                                              } else if (peripheral.state == CBPeripheralStateConnected) {
                                                                  DDLogWarn(@"Did connect to device %@",peripheral.name);
                                                                  [weakSelf discoverServiceAndCharacteristic:peripheral
                                                                                           withDataProcessor:dataProcessor
                                                                                                  completion:_connectionBlock];
                                                              }
                                                          }
                                                      }];
#else
            // 指定ServiceUUID搜索设备，并连接
            __weak BlueToothConnector * weakSelf = self;
            [self.centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString: kBLEServiceUUID]]
                                                        options:nil
                                                      onUpdated:^(RKPeripheral *peripheral) {
                                                          DDLogInfo(@"Discovered device: %@",peripheral.name);
                                                          if ([peripheral.name isEqual:weakSelf.peripheralName]) {
                                                              timeout = NO;
                                                              [weakSelf.centralManager stopScan];
                                                              weakSelf.peripheral = peripheral;
                                                              if (peripheral.state == CBPeripheralStateDisconnected && _connectionBlock) {
                                                                  DDLogInfo(@"Start Connect device: %@",peripheral.name);
                                                                  [weakSelf connectPeripheral:peripheral
                                                                             withConfidential:confidential
                                                                             AndDataProcessor:dataProcessor
                                                                                   completion:_connectionBlock];
                                                              } else if (peripheral.state == CBPeripheralStateConnected && _connectionBlock) {
                                                                  DDLogWarn(@"Did connect to device %@",peripheral.name);
                                                                  [weakSelf discoverServiceAndCharacteristic:peripheral
                                                                                           withDataProcessor:dataProcessor
                                                                                                  completion:_connectionBlock];
                                                              }
                                                          }
                                                          //蓝牙状态更新的时候链接是断开时，回调断开连接
                                                          else if(peripheral == nil && weakSelf.centralManager.state == CBCentralManagerStatePoweredOff){
                                                              if (_disconnectionBlock) {
                                                                  _disconnectionBlock(nil);
                                                                  _disconnectionBlock = nil;
                                                                  _connectionBlock = nil;
                                                              }
                                                          }
                                                      }];
#endif
        } else {
            if (_connectionBlock) {
                _connectionBlock(4);
                _connectionBlock = nil;
            }
        }
    }];
}

- (void)disconnect {
    if (self.peripheral.state != CBPeripheralStateDisconnected) {
        [self.centralManager cancelPeripheralConnection:self.peripheral
                                             onFinished:^(RKPeripheral *peripheral, NSError *error) {
                                                 
                                             }];
    }
    if (_disconnectionBlock) {
        _disconnectionBlock(nil);
        _disconnectionBlock = nil;
    }
}

- (void)reConnectDevicewithConfidential:(DeviceConfidential *)confidential completion:(void (^)(NSInteger result))completion disconnection:(void (^)(NSError *error))disconnection {
    if (self.peripheral.state == CBPeripheralStateDisconnected) {
        [self.centralManager connectPeripheral:self.peripheral
                                       options:nil
                                    onFinished:nil
                                onDisconnected:nil];
    }
}

- (void)writeCommand:(NSString *)command {
    if (command == nil || [command length] == 0) {
        return;
    }
    
    NSData * data = [[command stringByAppendingString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding];
    [self.peripheral writeValue:data
              forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithoutResponse onFinish:nil];
}

/**
 *  向设备写二进制数据
 *
 *  @param data 需要写入设备的数据
 */
- (void)sendData:(NSData *)data onFinish:(void(^)(NSError *error))onFinish{
    if (data == nil) {
        return;
    }
    [self.peripheral writeValue:data
              forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse onFinish:^(CBCharacteristic *characteristic, NSError *error) {
                  if (onFinish) {
                      onFinish(error);
                  }
              }];
}

/**
 *  向设备写二进制数据
 *
 *  @param data 需要写入设备的数据
 */
- (void)sendData:(NSData *)data {
    if (data == nil) {
        return;
    }
    [self.peripheral writeValue:data
              forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithoutResponse onFinish:nil];
}

@end
