//
//  BTConnectManager.m
//  SteadicamEVO
//
//  Created by Chen Hao 陈浩 on 16/3/15.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTConnectManager.h"
#import "RKBlueKit.h"
#import "RKCentralManager.h"
#import "RKPeripheralManager.h"
#import "RKPeripheral.h"
#import "CBUUID+RKBlueKit.h"
#import "RKBlueBlocks.h"

@interface BTConnectManager()

@property (nonatomic, assign) BOOL isCentralManager;
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

@implementation BTConnectManager

+(BTConnectManager *)shareInstance
{
    static BTConnectManager *manager;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [[BTConnectManager alloc]init];
    });
    
    return manager;
}

#pragma mark - - - - - - - - - - - - - - - 连接相关 - - - - - - - - - - - - - - -

- (void)initCentralManager:(void (^)(BOOL isOk, NSError *error))completion {
    NSDictionary * opts = nil;

    {
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
        {
            opts = @{CBCentralManagerOptionShowPowerAlertKey:@YES};
        }
        self.centralManager = [[RKCentralManager alloc] initWithQueue:nil
                                                              options:opts];
        __weak BTConnectManager * weakSelf = self;
        
        if (self.centralManager.state != CBCentralManagerStatePoweredOn)
        {
            self.centralManager.onStateChanged = ^(NSError * error)
            {
                if (weakSelf.centralManager.state == CBCentralManagerStatePoweredOn)
                {
                    
                    NSLog(@"centralManager is ready!");
                    
                    if (completion)
                    {
                        completion(YES, nil);
                    }
                }
                else
                {
                    
                    NSLog(@"centralManager is not ready!");
                    
                    if (completion)
                    {
                        completion(NO, nil);
                    }
                }
            };
        }
        else
        {
            
            NSLog(@"centralManager is ready!");
            
            if (completion)
            {
                completion(YES, nil);
            }
        }
    }
}


- (void)discoverServiceAndCharacteristic:(RKPeripheral *)peripheral
                              completion:(void (^)(NSInteger result))completion
{
    __weak BTConnectManager * weakSelf = self;
    
    [peripheral discoverServices:@[[CBUUID UUIDWithString: kBLEService1UUID]]
                        onFinish:^(NSError *error)
    {
                            weakSelf.service = [peripheral.services firstObject];
        
                            NSLog(@"Discovered Service : %@",weakSelf.service);
        
                            [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString: kBLECharacteristicNofiy1],[CBUUID UUIDWithString: kBLECharacteristicWrite]]
                                                     forService:weakSelf.service
                                                       onFinish:^(CBService *service, NSError *error){
                                                           
                                                           for (CBCharacteristic *characteristic in service.characteristics)
                                                           {
                                                               if ((characteristic.properties &CBCharacteristicPropertyWrite) !=0 ||
                                                                   (characteristic.properties &CBCharacteristicPropertyWriteWithoutResponse) !=0)
                                                               {
                                                                   self.writeCharacteristic = characteristic;
                                                                   
                                                                   NSLog(@"Discovered Characteristic : %@",self.writeCharacteristic);
                                                                   
                                                                   continue;
                                                               }
                                                               
                                                               if ((characteristic.properties & CBCharacteristicPropertyNotify))
                                                               {
                                                                   self.readCharacteristic = characteristic;
                                                                   
                                                                   NSLog(@"Discovered Characteristic : %@",self.readCharacteristic);
                                                                   
                                                                   continue;
                                                               }
                                                           }
                                                           
                                                           NSLog(@"Set Notify Callback For Characteristic : %@",self.readCharacteristic);
            
                                                           [self.peripheral setNotifyValue:YES
                                                                         forCharacteristic:self.readCharacteristic
                                                                                 onUpdated:^(CBCharacteristic *characteristic, NSError *error) {
                                                                                     
                                                               NSData *data = characteristic.value;
                                                               Byte *p = (Byte *)[data bytes];
                                                               NSString *rawValue = nil;
                                                               
                                                               if (*p > 0x7f)
                                                               {
                                                                   NSLog(@"received raw binary data:%lX",(long)*p);
                                                                   rawValue = [NSString stringWithFormat:@"%lX\r\n",(long)*p];
                                                               }
                                                               else
                                                               {
                                                                   rawValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                   NSLog(@"received raw data:%@",rawValue);
                                                               }
                                                               
                                                               if (weakSelf.pendingValue)
                                                               {
                                                                   if (![rawValue isEqual:@"?"])
                                                                   {
                                                                       rawValue = [NSString stringWithFormat:@"%@%@",weakSelf.pendingValue,rawValue];
                                                                   }
                                                                   weakSelf.pendingValue = nil;
                                                               }
                                                               
//                                                               NSMutableArray *rawValues = [NSMutableArray arrayWithArray:[rawValue componentsSeparatedByString:kBluetoothValueSplit]];
//                                                               if (![rawValue hasSuffix:kBluetoothValueSplit]) {
//                                                                   weakSelf.pendingValue = [rawValues lastObject];
//                                                                   [rawValues removeObject:weakSelf.pendingValue];
//                                                               }
                                                               
//                                                               for (NSString *value in rawValues) {
//                                                                   if (dataProcessor.dataReceived && [value length]) {
//                                                                       dataProcessor.dataReceived(value);
//                                                                   }
//                                                               }
                                                           }];
                                                           
                                                           NSLog(@"Did connect to device %@",peripheral.name);
                                                           if (completion)
                                                           {
                                                               completion(0);
                                                           }
                                                       }];
                        }];
}

- (void)connectPeripheral:(RKPeripheral *)peripheral
               completion:(void (^)(NSInteger result))completion
{
    __weak BTConnectManager * weakSelf = self;
    // 连接设备时的超时处理
    __block BOOL timeout = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (timeout)
        {
            [self.centralManager cancelPeripheralConnection:peripheral onFinished:^(RKPeripheral *peripheral, NSError *error) {
                
            }];
            NSLog(@"Connect to %@ failed!",peripheral.name);
            if (completion)
            {
                completion(2);
            }
        }
    });
    
    [self.centralManager connectPeripheral:peripheral
                                   options:nil
                                onFinished:^(RKPeripheral *peripheral, NSError *error) {
                                    timeout = NO;
                                    [weakSelf discoverServiceAndCharacteristic:peripheral
                                                                    completion:^(NSInteger result) {
                                                                        
                                                                        if (result == 0)
                                                                        {
                                                                            if (completion)
                                                                            {
                                                                                completion(0);
                                                                            }
                                                                        }
                                                                        else
                                                                        {
                                                                            if (completion)
                                                                            {
                                                                                completion(2);
                                                                            }
                                                                        }
                                                                    }];
                                } onDisconnected:^(RKPeripheral *peripheral, NSError *error) {
                                    NSLog(@"Did disconnect to device %@",peripheral.name);
                                    if (_disconnectionBlock)
                                    {
                                        _disconnectionBlock(error);
                                        // 将断开连接的回调置为空，防止断开连接时多次回调
                                        _disconnectionBlock = nil;
                                    }
                                }];
}

#pragma mark - Connector protocol


- (void)discoverDevice:(void (^)(NSArray *devices))completion {
    
    NSMutableArray *devices = [NSMutableArray array];
    [self initCentralManager:^(BOOL isOk, NSError *error) {
        if (isOk)
        {
            // 搜索设备时的超时处理
            __block BOOL end = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kScanPeripheralTimeoutSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if (!end)
                {
                    [self.centralManager stopScan];
                    NSLog(@"Discover Device End!");
                    if (completion)
                    {
                        completion(devices);
                    }
                }
            });
            
            // 如果设备已经连接，直接返回
            if (self.peripheral.state == CBPeripheralStateConnected && [self.peripheral.name isEqualToString:self.peripheralName])
            {
                end = YES;
                NSLog(@"Discover Device End!");
                if (completion)
                {
                    completion(@[self.peripheral.name]);
                }
                return;
            }
            
            // 指定ServiceUUID搜索设备
            [self.centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString: kBLEService1UUID]]
                                                        options:nil
                                                      onUpdated:^(RKPeripheral *peripheral) {
//                                                          if ([peripheral.name hasPrefix:kBLENamePrefix]) {
                                                              NSLog(@"Discovered device: %@",peripheral.name);
                                                              [devices addObject:peripheral.name];
//                                                          }
                                                      }];
        } else {
            if (completion) {
                completion(devices);
            }
        }
    }];
}


- (void)discoverDeviceNext:(BOOL (^)(NSString *deviceName))next
                completion:(void (^)(BOOL timeout))completion
                     error:(void (^)(NSError *error))errorBlock
{
    [self initCentralManager:^(BOOL isOk, NSError *error) {
        if (isOk)
        {
            // 搜索设备时的超时处理
            __block BOOL timeout = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kScanPeripheralTimeoutSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (timeout) {
                    [self.centralManager stopScan];
                    NSLog(@"Discover Device Time Out!");
                    if (completion) {
                        completion(timeout);
                    }
                }
            });
            
            // 如果设备已经连接，直接返回
            if (self.peripheral.state == CBPeripheralStateConnected && [self.peripheral.name isEqualToString:self.peripheralName])
            {
                timeout = NO;
                NSLog(@"Discovered device: %@",self.peripheral.name);
                if (next)
                {
                    next(self.peripheral.name);
                    NSLog(@"Discover Device End!");
                    if (completion) {
                        completion(timeout);
                    }
                }
                return;
            }
            
            // 指定ServiceUUID搜索设备
            [self.centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString: kBLEService1UUID]]
                                                        options:nil
                                                      onUpdated:^(RKPeripheral *peripheral) {
//                                                          if ([peripheral.name hasPrefix:kBLENamePrefix]) {
                                                              NSLog(@"Discovered device: %@",peripheral.name);
                                                              if (next) {
                                                                  BOOL find = NO;
                                                                  find = next(peripheral.name);
                                                                  if (find) {
                                                                      timeout = NO;
                                                                      NSLog(@"find device timeout %d.",timeout);
                                                                      [self.centralManager stopScan];
                                                                      NSLog(@"Discover Device End!");
                                                                      if (completion) {
                                                                          completion(timeout);
                                                                      }
                                                                  }
                                                              }
//                                                          }
                                                      }];
        }
        else
        {
            if (errorBlock)
            {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"蓝牙初始化失败！"
                                                                     forKey:NSLocalizedDescriptionKey];
                NSError *aError = [NSError errorWithDomain:ErrorDomain code:1000 userInfo:userInfo];
                errorBlock(aError);
            }
        }
    }];
}


- (void)disconnect
{
    if (self.peripheral.state != CBPeripheralStateDisconnected)
    {
        [self.centralManager cancelPeripheralConnection:self.peripheral
                                             onFinished:^(RKPeripheral *peripheral, NSError *error) {
                                                 
                                             }];
    }
    
    if (_disconnectionBlock)
    {
        _disconnectionBlock(nil);
        _disconnectionBlock = nil;
    }
}

- (void)writeCommand:(NSString *)command
{
    if (command == nil || [command length] == 0)
    {
        return;
    }
    
    NSData * data = [[command stringByAppendingString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding];
    
    [self.peripheral writeValue:data
              forCharacteristic:self.writeCharacteristic
                           type:CBCharacteristicWriteWithoutResponse
                       onFinish:nil];
}

/**
 *  向设备写二进制数据
 *
 *  @param data 需要写入设备的数据
 */
- (void)sendData:(NSData *)data
        onFinish:(void(^)(NSError *error))onFinish
{
    if (data == nil)
    {
        return;
    }
    
    [self.peripheral writeValue:data
              forCharacteristic:self.writeCharacteristic
                           type:CBCharacteristicWriteWithResponse
                       onFinish:^(CBCharacteristic *characteristic, NSError *error) {
                           
                  if (onFinish)
                  {
                      onFinish(error);
                  }
              }];
}

/**
 *  向设备写二进制数据
 *
 *  @param data 需要写入设备的数据
 */
- (void)sendData:(NSData *)data
{
    if (data == nil)
    {
        return;
    }
    [self.peripheral writeValue:data
              forCharacteristic:self.writeCharacteristic
                           type:CBCharacteristicWriteWithoutResponse
                       onFinish:nil];
}

@end
