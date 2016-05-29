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

@property (nonatomic,strong) NSArray<CBService *> *services;

@property (nonatomic,strong) CBService *service;

@property (nonatomic,strong) RKPeripheral *peripheral;

@property (nonatomic,strong) RKPeripheralManager *peripheralManager;

@property (nonatomic,strong) RKCentralManager *centralManager;

@property (nonatomic,strong) NSMutableArray<CBCharacteristic *> *readCharacteristics;

@property (nonatomic,strong) NSMutableArray<CBCharacteristic *> *writeCharacteristics;

@property (nonatomic,strong) CBCharacteristic *readCharacteristic;

@property (nonatomic,strong) CBCharacteristic *writeCharacteristic;

@property (nonatomic,strong) NSString *pendingValue;

@end

@implementation BTConnectManager

+(BTConnectManager *)shareInstance
{
    static BTConnectManager *manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [[BTConnectManager alloc]init];
    });
    
    return manager;
}

-(instancetype)init
{
    if (self = [super init])
    {
        _readCharacteristics  = [[NSMutableArray alloc]init];
        _writeCharacteristics = [[NSMutableArray alloc]init];
    }
    
    return self;
}

#pragma mark - - - - - - - - - - - - - - - 连接相关 - - - - - - - - - - - - - - -

/**
 *  初始化蓝牙监控中心
 *
 *  @param completion 初始化回调
 */
- (void)initCentralManager:(void (^)(BOOL isOk, NSError *error))completion
{
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

/**
 *  连接成功后查找设备相关servicce ④
 *
 *  @param peripheral 外部设备
 *  @param completion 回调
 */
- (void)discoverServiceAndCharacteristic:(RKPeripheral *)peripheral
                              completion:(void (^)(NSInteger result))completion
{
    __weak BTConnectManager * weakSelf = self;
    
    
    /*
    NSArray *services = @[
                          [CBUUID UUIDWithString: kBLEService1UUID],
                          [CBUUID UUIDWithString: kBLEService2UUID]
                          ];
    
    NSArray *characteristics = @[
                                 @[
                                     [CBUUID UUIDWithString: kBLECharacteristicWrite]
                                     ],
                                 @[
                                     [CBUUID UUIDWithString: kBLECharacteristicNofiy1],
                                     [CBUUID UUIDWithString: kBLECharacteristicNofiy2],
                                     [CBUUID UUIDWithString: kBLECharacteristicNofiy3],
                                     [CBUUID UUIDWithString: kBLECharacteristicNofiy4]
                                     ]
                                 ];
     */
    
    [peripheral discoverServices:nil
                        onFinish:^(NSError *error)
     {
         weakSelf.services = [NSArray arrayWithArray:peripheral.services];
         
         NSLog(@"Discovered Service : %@,,,,%@",weakSelf.services,peripheral.services);
         
         [weakSelf.services enumerateObjectsUsingBlock:^(CBService * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             
             [peripheral discoverCharacteristics:nil
                                      forService:obj
                                        onFinish:^(CBService *service, NSError *error){
                                            
                                            for (CBCharacteristic *characteristic in service.characteristics)
                                            {
                                                if ((characteristic.properties &CBCharacteristicPropertyWrite) !=0 ||
                                                    (characteristic.properties &CBCharacteristicPropertyWriteWithoutResponse) !=0)
                                                {
                                                    [self.writeCharacteristics addObject:characteristic];
                                                    
                                                    NSLog(@"Discovered writeCharacteristic : %@",self.writeCharacteristics);
                                                    
                                                    continue;
                                                }
                                                
                                                if ((characteristic.properties & CBCharacteristicPropertyNotify))
                                                {
                                                    [self.readCharacteristics addObject:characteristic];
                                                    
                                                    NSLog(@"Discovered readCharacteristic : %@",self.readCharacteristics);
                                                    
                                                    continue;
                                                }
                                            }
                                            
                                            NSLog(@"Set Notify Callback For readCharacteristic : %@",self.readCharacteristics);
                                            
                                            [self.readCharacteristics enumerateObjectsUsingBlock:^(CBCharacteristic * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                                
                                                [self.peripheral setNotifyValue:YES
                                                              forCharacteristic:obj
                                                                      onUpdated:^(CBCharacteristic *characteristic, NSError *error) {
                                                                          
                                                                          NSString *result = [[NSString alloc] initWithData:characteristic.value  encoding:NSUTF8StringEncoding];
                                                                          
                                                                          NSLog(@" notify back : %@",characteristic);
                                                                          
                                                                          NSLog(@"value : %@",result);
                                                                          
                                                                          /*
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
                                                                              if (![rawValue isEqualToString:@"?"])
                                                                              {
                                                                                  rawValue = [NSString stringWithFormat:@"%@%@",weakSelf.pendingValue,rawValue];
                                                                              }
                                                                              
                                                                              weakSelf.pendingValue = nil;
                                                                          }
                                                                           */
                                                                      }];
                                            }];
                                            
                                            NSLog(@"Did connect to device %@",peripheral.name);
                                            if (completion && idx == weakSelf.services.count - 1)
                                            {
                                                completion(0);
                                            }
                                        }];
         }];
         
     }];
}

/**
 *  连接外部设备 ③
 *
 *  @param peripheral 外部设备
 *  @param completion 回调
 */
- (void)connectPeripheral:(RKPeripheral *)peripheral
               completion:(void (^)(NSInteger result))completion
{
    __weak BTConnectManager * weakSelf = self;
    
    // 连接设备时的超时处理
    __block BOOL timeout = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (timeout)
        {
            [self.centralManager cancelPeripheralConnection:peripheral
                                                 onFinished:^(RKPeripheral *peripheral, NSError *error) {
                                                     
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
                                    
                                }
                            onDisconnected:^(RKPeripheral *peripheral, NSError *error) {
                                
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

/**
 *  发现周边设备
 *
 *  @param completion 回调
 */
- (void)discoverDevice:(void (^)(NSArray *devices))completion
{
    
    NSMutableArray *devices = [NSMutableArray array];
    
    [self initCentralManager:^(BOOL isOk, NSError *error)
     {
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
             if (self.peripheral.state == CBPeripheralStateConnected && [self hasMatchWithName:self.peripheral.name])
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
             [self.centralManager scanForPeripheralsWithServices:nil
                                                         options:nil
                                                       onUpdated:^(RKPeripheral *peripheral) {
                                                           //                                                          if ([peripheral.name hasPrefix:kBLENamePrefix]) {
                                                           NSLog(@"Discovered device: %@",peripheral.name);
                                                           
                                                           [devices addObject:peripheral.name];
                                                           //                                                          }
                                                       }];
         }
         else
         {
             if (completion)
             {
                 completion(devices);
             }
         }
     }];
}

/**
 *  发现设备 ①
 *
 *  @param next       设备名
 *  @param completion 发现回调
 *  @param errorBlock 错误回调
 */
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
            if (self.peripheral.state == CBPeripheralStateConnected && [self hasMatchWithName:self.peripheral.name])
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
            [self.centralManager scanForPeripheralsWithServices:nil
                                                        options:nil
                                                      onUpdated:^(RKPeripheral *peripheral) {
                                                          
                                                          if ([peripheral.name isEqualToString:kDeviceName1])
                                                          {
                                                              NSLog(@"Discovered device: %@",peripheral.name);
                                                              
                                                              if (next)
                                                              {
                                                                  BOOL find = NO;
                                                                  find = next(peripheral.name);
                                                                  
                                                                  if (find)
                                                                  {
                                                                      timeout = NO;
                                                                      
                                                                      NSLog(@"find device timeout %d.",timeout);
                                                                      
                                                                      [self.centralManager stopScan];
                                                                      
                                                                      NSLog(@"Discover Device End!");
                                                                      
                                                                      if (completion)
                                                                      {
                                                                          completion(timeout);
                                                                      }
                                                                  }
                                                              }
                                                          }
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

/**
 *  连接设备 ②
 *
 *  @param completion    连接回调
 *  @param disconnection 连接断开回调
 */
- (void)connectDeviceWithCompletion:(void (^)(NSInteger result))completion
                      disconnection:(void (^)(NSError *))disconnection
{
    // 设置断开连接回调
    _disconnectionBlock = disconnection;
    
    _connectionBlock = completion;
    
    [self initCentralManager:^(BOOL isOk, NSError *error) {
        
        if (isOk)
        {
            // 搜索设备时的超时处理
            __block BOOL timeout = YES;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kScanPeripheralTimeoutSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if (timeout)
                {
                    NSLog(@"Discover Device Time Out!");
                    
                    [self.centralManager stopScan];
                    
                    if (_connectionBlock)
                    {
                        _connectionBlock(1);
                    }
                }
            });
            
            // 如果设备已经连接，直接返回
            if (self.peripheral.state == CBPeripheralStateConnected && [self hasMatchWithName:self.peripheral.name])
            {
                timeout = NO;
                if (_connectionBlock)
                {
                    _connectionBlock(0);
                }
                
                return;
            }
            
            // 指定ServiceUUID搜索设备，并连接
            __weak BTConnectManager * weakSelf = self;
            
            [self.centralManager scanForPeripheralsWithServices:nil
                                                        options:nil
                                                      onUpdated:^(RKPeripheral *peripheral) {
                                                          
                                                          NSLog(@"Discovered device: %@",peripheral.name);
                                                          
                                                          if ([self hasMatchWithName:peripheral.name])
                                                          {
                                                              timeout = NO;
                                                              
                                                              [weakSelf.centralManager stopScan];
                                                              
                                                              weakSelf.peripheral = peripheral;
                                                              
                                                              weakSelf.peripheralName = peripheral.name;
                                                              
                                                              if (peripheral.state == CBPeripheralStateDisconnected && _connectionBlock)
                                                              {
                                                                  NSLog(@"Start Connect device: %@",peripheral.name);
                                                                  
                                                                  [weakSelf connectPeripheral:peripheral
                                                                                   completion:_connectionBlock];
                                                              }
                                                              else if (peripheral.state == CBPeripheralStateConnected && _connectionBlock)
                                                              {
                                                                  NSLog(@"Did connect to device %@",peripheral.name);
                                                                  
                                                                  [weakSelf discoverServiceAndCharacteristic:peripheral
                                                                                                  completion:_connectionBlock];
                                                              }
                                                          }
                                                          
                                                          // 蓝牙状态更新的时候链接是断开时，回调断开连接
                                                          else if(peripheral == nil && weakSelf.centralManager.state == CBCentralManagerStatePoweredOff)
                                                          {
                                                              if (_disconnectionBlock)
                                                              {
                                                                  _disconnectionBlock(nil);
                                                                  _disconnectionBlock = nil;
                                                                  _connectionBlock = nil;
                                                              }
                                                          }
                                                      }];
        }
        else
        {
            if (_connectionBlock)
            {
                _connectionBlock(4);
                _connectionBlock = nil;
            }
        }
    }];
}


/**
 *  断开连接
 */
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
              forCharacteristic:self.writeCharacteristics[0]
                           type:CBCharacteristicWriteWithoutResponse
                       onFinish:nil];
}

/**
 *  匹配搜索到的外部设备名称
 *
 *  @param name 外部设备名称
 *
 *  @return 是否匹配
 */
- (BOOL)hasMatchWithName:(NSString *)name
{
    return ([name isEqualToString:kDeviceName1] || [name isEqualToString:kDeviceName2]);
}

@end
