//
//  TorqueDevice.m
//  OBD-DEMO
//
//  Created by zhangjipeng on 1/23/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import "TorqueDevice.h"
#import "OBDDevice+DeviceStatus.h"
#import "OBDDevice+Upgrade.h"
#import "NSString+Date.h"
#import "AFNetworking10.h"
#import "AESCrypt.h"
#import "TorqueDataOperation.h"
#import "TorqueGlobal.h"
#import "OBDDevice+DeviceStatus.h"

@interface TorqueDevice ()

@property (nonatomic, strong) NSArray *registeredDevices;
@property (nonatomic, strong) NSArray *registeredCars;
@property (nonatomic, strong) DeviceCheckUpgradeModel *deviceUpgradeInfo;

@end

@implementation TorqueDevice

+ (instancetype)sharedInstance {
    static TorqueDevice *device = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        device = [TorqueDevice new];
    });
    
    return device;
}

- (id)init {
    if (self = [super init]) {
        //_isIdling = NO;
        _needResetTotalDistance = NO;
        [self obdDevice];
    }
    return self;
}

- (BOOL)deviceIsConnected {
    return self.obdDevice.deviceIsConnected;
}

- (void)setConnectMode:(TorqueDeviceConnetMode)connectMode {
    [self.obdDevice setConnectMode:connectMode];
}

/**
 *  发现设备，app每次启动时需要调用该函数
 *
 *  @param user       用户信息
 *  @param mode       连接模式
 *  @param completion 检查结果，succeed:YES[成功]/NO[失败] result：-1 失败, 0 注册过的设备已连接，1 未注册设备，2 未发现已注册设备，请检查硬件是否正确插入，3 盒子插拔过， 4 蓝牙初始化失败(蓝牙未开启)
 */
- (void)discoverDeviceForUser:(UserInfo *)user WithMode:(TorqueDeviceConnetMode)mode completion:(void (^)(TorqueResult *result))completion disconnection:(void (^)(NSError *error))disconnection {
    TorqueResult *_result = [TorqueResult new];
    if (self.deviceIsConnected ||
        !user.userId) {
        if (self.deviceIsConnected) {
            _result.result = 0;
            _result.succeed = YES;
            _result.message = kMessage_connectSucceed;
        }
        
        if (!user.userId) {
            _result.message = kMessage_userIdNotNull;
        }
        if (completion) {
            completion(_result);
        }
        DDLogInfo(@"方法名:%s result:%ld message:%@", __FUNCTION__, _result.result, _result.message);
        return;
    }
    
    // 获取用户名下所有的设备
    __weak TorqueDevice *weakSelf = self;
    [self getObjectsAtPath:kTorqueDeviceGetListPath
                parameters:kTorqueDeviceGetListParams(user.userId)
                   success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                       TorqueError *error = [[mappingResult dictionary] objectForKey:@"status"];
                       _result.message = error.errorMessage;
                       if (error.errorCode == 0) {
                           // 已注册设备列表
                           weakSelf.registeredDevices = [[mappingResult dictionary] objectForKey:@"result"];
#ifdef DEBUG
                           DDLogInfo(@"user(id:%@)'s devices:",user.userId);
                           NSInteger index = 0;
                           for (DeviceInfo *device in weakSelf.registeredDevices) {
                               DDLogInfo(@"%ld, %@, %@, %@",(long)index, device.name, device.passwd, device.sn);
                               index++;
                           }
                           if (!index) {
                               DDLogInfo(@"no registered device.\n");
                           }
#endif
                           if (![weakSelf.registeredDevices count]) {
                               // 未注册设备
                               _result.result = 1;
                               _result.message = kMessage_unRegist;
                               if (completion) {
                                   completion(_result);
                               }
                           } else {
                               // 搜索周边设备
                               __block DeviceInfo *needConnectDevice = nil;
                               [self.obdDevice discoverDeviceForMode:mode
                                                                next:^BOOL(NSString *deviceName) {
                                                                    for (DeviceInfo *registeredDevice in weakSelf.registeredDevices) {
                                                                        if ([deviceName isEqualToString:registeredDevice.name]) {
                                                                            // 周边设备中有已注册设备，则退出循环，连接该设备
                                                                            needConnectDevice = registeredDevice;
                                                                            break;
                                                                        }
                                                                    }
                                                                    
                                                                    if (needConnectDevice) {
                                                                        DDLogInfo(@"find device %@.",needConnectDevice.name);
                                                                        return YES;
                                                                    } else {
                                                                        DDLogInfo(@"did not find device.");
                                                                        return NO;
                                                                    }
                                                                }
                                                          completion:^(BOOL timeout) {
                                                              if (timeout) {
                                                                  // 周边没发现设备
                                                                  _result.result = 2;
                                                                  _result.message = kMessage_deviceNotFound;
                                                                  if (completion) {
                                                                      completion(_result);
                                                                  }
                                                              } else {
                                                                  self.obdDevice.deviceInfo = needConnectDevice;
                                                                  DDLogDebug(@"开始连接设备：%@", needConnectDevice.name);
                                                                  [self.obdDevice connectWithMode:mode completion:^(NSInteger result) {
                                                                      DDLogDebug(@"connectWithMode_result:%ld", result);
                                                                      if (result == 0) {
                                                                          _result.succeed = YES;
                                                                          //设备连接上后 设置当前 连接设备
                                                                          [[TorqueGlobal sharedInstance] setDeviceInfo:self.obdDevice.deviceInfo];
#if USE_EST530
                                                                          DDLogDebug(@"连接成功，判断是否插拔过");
                                                                          // 连接成功，判断是否插拔过
                                                                          [self.obdDevice deviceWasPullOut:^(BOOL result) {
                                                                              if (result) {
                                                                                  _result.result = 3;
                                                                                  _result.message = kMessage_BoxUnPluged;
                                                                                  if (completion) {
                                                                                      completion(_result);
                                                                                  }
                                                                              } else {
                                                                                  _result.result = 0;
                                                                                  _result.message = kMessage_connectSucceed;
                                                                                  [self readVinCode:^(NSString *vinCode, TorqueResult *result) {
                                                                                      DDLogDebug(@"readVinCode_vin:%@", vinCode);
                                                                                      if (vinCode) {
                                                                                          // 读取到VIN码后更新本地车辆信息
                                                                                          for (CarInfo *car in [TorqueGlobal sharedInstance].allCarArray) {
                                                                                              if ([car.vinCode isEqualToString:vinCode]) {
                                                                                                  [[TorqueGlobal sharedInstance] setCarInfo:car];
                                                                                                  break;
                                                                                              }
                                                                                          }
                                                                                      }
                                                                                  }];
                                                                                  if (completion) {
                                                                                      completion(_result);
                                                                                  }
                                                                                  DDLogInfo(@"方法名:%s result:%ld message:%@", __FUNCTION__, _result.result, _result.message);
                                                                              }
                                                                          }];
#endif
                                                                      } else {
                                                                          // 连接失败
                                                                          _result.result = -1;
                                                                          _result.message = kMessage_connectFailed;
                                                                          if (completion) {
                                                                              completion(_result);
                                                                          }
                                                                          DDLogInfo(@"方法名:%s result:%ld message:%@", __FUNCTION__, _result.result, _result.message);
                                                                      }
                                                                  } disconnection:^(NSError *error) {
                                                                      /*
                                                                       [self discoverDeviceForUser:user WithMode:mode completion:completion disconnection:disconnection];
                                                                       */
                                                                      
                                                                      if (disconnection) {
                                                                          disconnection(error);
                                                                      }
                                                                  }];
                                                              }
                                                          }
                                                               error:^(NSError *error) {
                                                                   if (error) {
                                                                       // 周边没发现设备
                                                                       _result.result = 4;
                                                                       _result.message = kMessage_BLEError;
                                                                       if (completion) {
                                                                           completion(_result);
                                                                       }
                                                                       DDLogInfo(@"方法名:%s result:%ld message:%@", __FUNCTION__, _result.result, _result.message);
                                                                   }
                                                               }];
                           }
                       } else {
                           // 显示errorMessage
                           DDLogError(@"errorCode: %ld, errorMessage: %@",(long)error.errorCode, error.errorMessage);
                           _result.message = error.errorMessage;
                           //_result.error = error;
                           if (completion) {
                               completion(_result);
                           }
                           DDLogInfo(@"方法名:%s result:%ld message:%@", __FUNCTION__, _result.result, _result.message);
                       }
                   } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                       _result.message = error.localizedDescription;
                       _result.error = error;
                       if (completion) {
                           completion(_result);
                       }
                       DDLogInfo(@"方法名:%s result:%ld message:%@", __FUNCTION__, _result.result, _result.message);
                   }];
}

/**
 *  车辆是否进入怠速状态
 *
 *  @param completion 回调
 */
- (void)engineIsIdling:(void (^)(BOOL result))completion {
    [self.obdDevice engineIsIdling:completion];
}

/**
 *  车辆是否进入启动
 *
 *  @param completion 回调
 */
- (void)engineIsIdlingWithMode:(void (^)(NSInteger))completion {
    [self.obdDevice engineIsIdlingWithMode:completion];
}

/**
 *  获取用户名下的所有设备
 *
 *  @param user       用户
 *  @param completion 回调 succeed:YES[成功]/NO[失败] result：-1, 失败, 0 成功
 */
- (void)getDevicesForUser:(UserInfo *)user compeltion:(void (^)(NSArray *devices, TorqueResult *result))completion {
    TorqueResult *result = [[TorqueResult alloc] init];
    if (!user.userId) {
        result.message = kMessage_userIdNotNull;
        if (completion) {
            completion(nil, result);
        }
        DDLogInfo(@"方法名:%s result:%ld message:%@", __FUNCTION__, result.result, result.message);
        return;
    }
    // 获取用户名下所有的设备
    __weak TorqueDevice *weakSelf = self;
    [self getObjectsAtPath:kTorqueDeviceGetListPath
                parameters:kTorqueDeviceGetListParams(user.userId)
                   success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                       TorqueError *error = [[mappingResult dictionary] objectForKey:@"status"];
                       result.message = error.errorMessage;
                       if (error.errorCode == 0) {
                           // 已注册设备列表
                           weakSelf.registeredDevices = [[mappingResult dictionary] objectForKey:@"result"];
                           result.succeed = YES;
                           result.result = 0;
                       } else {
                           // 显示errorMessage
                           DDLogInfo(@"errorCode: %ld, errorMessage: %@",(long)error.errorCode, error.errorMessage);
                           result.message = error.errorMessage;
                           result.result = TorqueSDK_NerWorkOther;
                       }
                       if (completion) {
                           completion(weakSelf.registeredDevices, result);
                       }
                       DDLogInfo(@"方法名:%s result:%ld message:%@", __FUNCTION__, result.result, result.message);
                   } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                       result.message = error.localizedDescription;
                       result.error = error;
                       result.result = TorqueSDK_NetWorkFailed;
                       if (completion) {
                           completion(nil, result);
                       }
                       DDLogInfo(@"方法名:%s result:%ld message:%@", __FUNCTION__, result.result, result.message);
                   }];
}

/**
 *  注册设备
 *
 *  @param device 设备信息
 *  @param completion 注册完成时的回调block，succeed:YES[成功]/NO[失败] result：-1, 失败, 0 成功，1 未绑定手机号，2 该设备已被其他账号绑定，3 该设备已被该账号绑定，4 用户id不能为空，5 设备不存在，请联系客服确认
 */
- (void)registerDevice:(DeviceInfo *)device forUser:(UserInfo *)user completion:(void (^)(TorqueResult *result))completion {
    TorqueResult *result = [[TorqueResult alloc] init];
    if (!user.userId ||
        !device.name ||
        !device.sn ||
        !device.passwd) {
        if (!user.userId) {
            result.message = kMessage_userIdNotNull;
        }
        if (!device.name) {
            result.message = kMessage_deviceNameNotNull;
        }
        if (!device.sn) {
            result.message = kMessage_deviceSnNotNull;
        }
        if (!device.passwd) {
            result.message = kMessage_devicePWDNotNull;
        }
        
        if (completion) {
            completion(result);
        }
        DDLogInfo(@"方法名:%s result:%ld message:%@", __FUNCTION__, result.result, result.message);
        return;
    }
    
    //[[TorqueGlobal sharedInstance] setDeviceInfo:device];
    device.userId = user.userId;
    self.obdDevice.deviceInfo = device;
    [self postObject:device
                path:kTorqueDeviceRegister
          parameters:nil
 needResponseMapping:YES
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 TorqueError *error = [[mappingResult dictionary] objectForKey:@"status"];
                 result.message = error.errorMessage;
                 if (error.errorCode == 0) {
                     result.succeed = YES;
                     result.result = 0;
                     
                     // 返回的注册成功的设备信息
                     NSArray *registeredDevices = [[mappingResult dictionary] objectForKey:@"result"];
                     if (registeredDevices &&
                         registeredDevices.count > 0) {
                         DeviceInfo *device = registeredDevices[0];
                         if (device) {
                             self.obdDevice.deviceInfo.deviceId = device.deviceId;
                             // 设置当前 连接设备
                             //[[TorqueGlobal sharedInstance] setDeviceInfo:self.obdDevice.deviceInfo];
                         }
                     }
                 } else if (error.errorCode == 200) {
                     result.result = 3;
                 } else if (error.errorCode == 400) {
                     result.result = 4;
                 } else if (error.errorCode == 401) {
                     result.result = 2;
                 } else if (error.errorCode == 402) {
                     result.result = 1;
                 } else if (error.errorCode == 403) {
                     result.result = 5;
                 } else {
                     result.result = TorqueSDK_NerWorkOther;//-1;
                 }
                 if (completion) {
                     completion(result);
                 }
                 DDLogInfo(@"方法名:%s result:%ld message:%@", __FUNCTION__, result.result, result.message);
             } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 result.result = TorqueSDK_NetWorkFailed;//-1;
                 result.message = error.localizedDescription;
                 result.error = error;
                 if (completion) {
                     completion(result);
                 }
                 DDLogInfo(@"方法名:%s result:%ld message:%@", __FUNCTION__, result.result, result.message);
             }];
}

#if 0
/**
 *  重新连接
 *
 *  @param mode          连接模式
 *  @param completion    连接完成时的回调block， result： 0 成功，1 未发现设备，2 失败，3 密码鉴权失败
 *  @param disconnection 连接断开回调
 */
- (void)reConnectWithMode:(TorqueDeviceConnetMode)mode completion:(void (^)(NSInteger result))completion disconnection:(void (^)(NSError *error))disconnection {
    [self.obdDevice reConnectWithMode:mode completion:completion disconnection:disconnection];
}
#endif

/**
 *  解绑设备
 *
 *  @param device 设备信息
 *  @param completion 解绑完成时的回调block，succeed:YES[成功]/NO[失败] result： -1, 失败,  0 成功，1 用户id不能为空/sn不能为空，2 没找到设备, 3 验证码错误
 */
- (void)unregisterDevice:(DeviceUserQueryModel *)device completion:(void (^)(TorqueResult *result))completion {
    TorqueResult *result = [[TorqueResult alloc] init];
    if (!device.sn ||
        !device.smsCode ||
        !device.userId) {
        if (!device.userId) {
            result.message = kMessage_userIdNotNull;
        }
        if (!device.smsCode) {
            result.message = kMessage_smsNotNull;
        }
        if (!device.sn) {
            result.message = kMessage_deviceSnNotNull;
        }
        
        if (completion) {
            completion(result);
        }
        DDLogInfo(@"方法名:%s result:%ld message:%@", __FUNCTION__, result.result, result.message);
        return;
    }
    [self postObject:device
                path:kTorqueDeviceUnregisterDevice
          parameters:nil
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 TorqueError *error = [[mappingResult dictionary] objectForKey:@"status"];
                 result.message = error.errorMessage;
                 if (error.errorCode == 0) {
                     result.succeed = YES;
                     result.result = 0;
                 } else if (error.errorCode == 400) {
                     result.result = 1;
                 } else if (error.errorCode == 401) {
                     result.result = 2;
                 } else if (error.errorCode == 402) {
                     result.result = 3;
                 }
                 if (completion) {
                     completion(result);
                 }
                 DDLogInfo(@"方法名:%s result:%ld message:%@", __FUNCTION__, result.result, result.message);
             } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 result.result = TorqueSDK_NetWorkFailed;//-1;
                 result.message = error.localizedDescription;
                 result.error = error;
                 if (completion) {
                     completion(result);
                 }
                 DDLogInfo(@"方法名:%s result:%ld message:%@", __FUNCTION__, result.result, result.message);
             }];
}

/**
 *  连接设备，调用注册设备接口之后调用
 *
 *  @param device    需要连接的设备
 *  @param completion 连接完成时的回调block， result： 0 成功，1 未发现设备，2 失败, 3 密码鉴权失败
 */
- (void)connectWithMode:(TorqueDeviceConnetMode)mode completion:(void (^)(NSInteger result))completion disconnection:(void (^)(NSError *error))disconnection {
    if (self.deviceIsConnected) {
        if (completion) {
            completion(0);
        }
        return;
    }
    [self.obdDevice connectWithMode:mode
                         completion:^(NSInteger result) {
                             if (result == 0) {
                                 //设备连接上后 设置当前 连接设备
                                 [[TorqueGlobal sharedInstance] setDeviceInfo:self.obdDevice.deviceInfo];
                                 
                             }
                             if (completion) {
                                 completion(result);
                             }
                             DDLogInfo(@"方法名:%s result:%ld", __FUNCTION__, result);
                         } disconnection:^(NSError *error) {
                             if (disconnection) {
                                 disconnection(error);
                             }
                             DDLogInfo(@"方法名:%s error:%@", __FUNCTION__, error.localizedDescription);
                         }];
}

#if USE_ANONYMOUS_MODE
/**
 *  发现设备，app每次启动时需要调用该函数
 *
 *  @param mode       连接模式
 *  @param completion 检查结果，result：0 已连接，1 未发现设备，请检查硬件是否正确插入，2 失败
 */
- (void)discoverDeviceWithMode:(TorqueDeviceConnetMode)mode completion:(void (^)(NSInteger result))completion disconnection:(void (^)(NSError *error))disconnection {
    if (self.deviceIsConnected) {
        if (completion) {
            completion(0);
        }
        return;
    }
    NSString *deviceName = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceName"];
    if (!deviceName) {
        completion(1);
        return;
    }
    
    [self.obdDevice discoverDeviceForMode:mode completion:^(NSArray *devices) {
        if (![devices count]) {
            completion(2);
        } else {
            DeviceInfo *needConnectDevice = [DeviceInfo new];
            for (NSString *discoveredDeviceName in devices) {
                if ([discoveredDeviceName isEqualToString:deviceName]) {
                    needConnectDevice.name = deviceName;
                    needConnectDevice.mode = [[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceMode"] integerValue];
                    break;
                }
            }
            
            if (needConnectDevice) {
                self.obdDevice.deviceInfo = needConnectDevice;
                [self.obdDevice connectWithMode:mode completion:^(NSInteger result) {
                    if (result == 0) {
                        //设备连接上后 设置当前 连接设备
                        [[TorqueGlobal sharedInstance] setDeviceInfo:needConnectDevice];
                        
#if USE_EST530
                        // 连接成功，判断是否插拔过
#if 0 //def DEBUG
                        int x = arc4random() % 2;
                        for (int i = 0; i < 10; i++) {
                            x = arc4random() % 2;
                            NSLog(@"x = %ld",(long)x);
                        }
                        
                        completion(3 * x);
#else
                        [self.obdDevice deviceWasPullOut:^(BOOL result) {
                            if (result) {
                                completion(3);
                            } else {
                                completion(0);
                            }
                        }];
#endif
#endif
                    } else {
                        completion(1);
                    }
                } disconnection:^(NSError *error) {
                    if (disconnection) {
                        disconnection(error);
                    }
                }];
            } else {
                // 周边设备中没有已注册设备
                completion(2);
            }
        }
    }];
}

#endif

/**
 *  连接设备，调用注册设备接口之后调用
 *
 *  @param device    需要连接的设备
 *  @param completion succeed:YES[成功]/NO[失败] result：-1 失败, 0 注册过的设备已连接，1 未注册设备，2 未发现已注册设备，请检查硬件是否正确插入，3 盒子插拔过， 4 蓝牙初始化失败(蓝牙未开启)
 */
- (void)connectWithDevice:(DeviceInfo *)device completion:(void (^)(TorqueResult *))completion disconnection:(void (^)(NSError *))disconnection
{
    TorqueResult *_result = [TorqueResult new];
    
    // 搜索周边设备
    __block DeviceInfo *needConnectDevice = nil;
    
    [self.obdDevice discoverDeviceForMode:device.mode
                                     next:^BOOL(NSString *deviceName) {
                                         
                                         if ([deviceName isEqualToString:device.name])
                                         {
                                             needConnectDevice = device;
                                         }
                                         
                                         if (needConnectDevice)
                                         {
                                             DDLogInfo(@"find device %@.",needConnectDevice.name);
                                             return YES;
                                         }
                                         else
                                         {
                                             DDLogInfo(@"did not find device.");
                                             return NO;
                                         }
                                     }
                               completion:^(BOOL timeout) {
                                   
                                   if (timeout)
                                   {
                                       // 周边没发现设备
                                       _result.result = 2;
                                       _result.message = kMessage_deviceNotFound;
                                       
                                       if (completion)
                                       {
                                           completion(_result);
                                       }
                                   }
                                   else
                                   {
                                       self.obdDevice.deviceInfo = needConnectDevice;
                                       DDLogDebug(@"开始连接设备：%@", needConnectDevice.name);
                                       
                                       [self.obdDevice connectWithMode:device.mode completion:^(NSInteger result) {
                                           
                                           DDLogDebug(@"connectWithMode_result:%ld", result);
                                           if (result == 0)
                                           {
                                               _result.succeed = YES;
                                               //设备连接上后 设置当前 连接设备
                                               [[TorqueGlobal sharedInstance] setDeviceInfo:self.obdDevice.deviceInfo];
#if USE_EST530
                                               DDLogDebug(@"连接成功，判断是否插拔过");
                                               // 连接成功，判断是否插拔过
                                               [self.obdDevice deviceWasPullOut:^(BOOL result) {
                                                   
                                                   if (result)
                                                   {
                                                       _result.result = 3;
                                                       _result.message = kMessage_BoxUnPluged;
                                                       if (completion)
                                                       {
                                                           completion(_result);
                                                       }
                                                   }
                                                   else
                                                   {
                                                       _result.result = 0;
                                                       _result.message = kMessage_connectSucceed;
                                                       
                                                       [self readVinCode:^(NSString *vinCode, TorqueResult *result) {
                                                           
                                                           DDLogDebug(@"readVinCode_vin:%@", vinCode);
                                                           if (vinCode)
                                                           {
                                                               // 读取到VIN码后更新本地车辆信息
                                                               for (CarInfo *car in [TorqueGlobal sharedInstance].allCarArray)
                                                               {
                                                                   if ([car.vinCode isEqualToString:vinCode])
                                                                   {
                                                                       [[TorqueGlobal sharedInstance] setCarInfo:car];
                                                                       
                                                                       break;
                                                                   }
                                                               }
                                                           }
                                                       }];
                                                       
                                                       if (completion)
                                                       {
                                                           completion(_result);
                                                       }
                                                       DDLogInfo(@"方法名:%s result:%ld message:%@", __FUNCTION__, _result.result, _result.message);
                                                   }
                                               }];
#endif
                                           }
                                           else
                                           {
                                               // 连接失败
                                               _result.result = -1;
                                               _result.message = kMessage_connectFailed;
                                               
                                               if (completion)
                                               {
                                                   completion(_result);
                                               }
                                               DDLogInfo(@"方法名:%s result:%ld message:%@", __FUNCTION__, _result.result, _result.message);
                                           }
                                       } disconnection:^(NSError *error) {
                                           /*
                                            [self discoverDeviceForUser:user WithMode:mode completion:completion disconnection:disconnection];
                                            */
                                           
                                           if (disconnection)
                                           {
                                               disconnection(error);
                                           }
                                       }];
                                   }
                               }
                                    error:^(NSError *error) {
                                        
                                        if (error)
                                        {
                                            // 周边没发现设备
                                            _result.result = 4;
                                            _result.message = kMessage_BLEError;
                                            
                                            if (completion)
                                            {
                                                completion(_result);
                                            }
                                            DDLogInfo(@"方法名:%s result:%ld message:%@", __FUNCTION__, _result.result, _result.message);
                                        }
                                    }];
}

/**
 *  断开连接
 */
- (void)disconnect {
    if (!self.deviceIsConnected) {
        return;
    }
    [self.obdDevice disconnect];
}

/**
 *  识别车辆
 *
 *  @param completion 完成时的回调block succeed:YES[成功]/NO[失败] result： -1, 失败,读取车辆VIN码失败，需要手动输入VIN码,  1 盒子插拔过，但没有换车，仅需要校准总里程，2 换车了，该车是已有车辆，需要恢复出厂设置并校准总里程, 3 盒子插拔过，该车尚未注册，需要注册车辆、恢复出厂设置并校准总里程
 */
- (void)recognizeCar:(void (^)(NSString *vinCode, TorqueResult *result))completion {
    TorqueResult *_result = [TorqueResult new];
    __weak TorqueDevice *weakSelf = self;
    // 读取Vin码，如果读取失败，把状态置为3，
    [self readVinCode:^(NSString *vinCode, TorqueResult *result) {
        if (!vinCode) {
            // 读取VIN码失败
            _result.succeed = NO;
            _result.result = -1;
            _result.message  = kMessage_ReadVinFailed;
            
            if (completion) {
                completion(nil, _result);
            }
            DDLogInfo(@"方法名:%s result:%ld message:%@", __FUNCTION__, _result.result, _result.message);
            return;
        }
        
        [weakSelf.obdDevice readLastVin:^(NSString *lastVIN, NSError *error) {
            
            //核心逻辑：1.vin和lastVin相同时校准里程（同一辆车插拔），2.vin和lastVin不同时初始化盒子（主要是为了清除行程数据）
            //如果lastvin有数据，
            // 判断车辆vin码是否和lastvin一致
            //如果不一致，走换车逻辑
            //如果一致，校准里程
            //如果lastvin没有数据，
            // 比对当前连接设备的vin码（setCarInfo时保存服务器中的）是否和当前车辆的vin码一致
            // 一致:校准里程
            // 不一致:走换车流程
            void(^changeCarOrProofBlock)(NSString *message,NSInteger resultCode) = ^(NSString *message,NSInteger resultCode) {
                DDLogInfo(@"方法名:%s result:%ld message:%@", __FUNCTION__, _result.result, _result.message);
                _result.succeed = YES;
                _result.result = resultCode;
                _result.message  = message;
                if (completion) {
                    completion(vinCode, _result);
                }
            };
            // 如果lastvin有数据
            if (lastVIN && lastVIN.length > 0) {
                // 判断车辆vin码是否和lastvin一致
                // 如果一致，校准里程
                if ([vinCode isEqualToString:lastVIN]) {
                    changeCarOrProofBlock(kMessage_NeedProof,1);
                }
                // 如果不一致，判断;
                else {
                    changeCarOrProofBlock(kMessage_NeedRegAndResetFactoryAndProof,3);
                }
            } else {
                // 比对当前连接设备的vin码（setCarInfo时保存服务器中的）是否和当前车辆的vin码一致
                // 一致:校准里程, 不一致:走换车流程
                if (weakSelf.obdDevice &&
                    weakSelf.obdDevice.deviceInfo &&
                    [vinCode isEqualToString:weakSelf.obdDevice.deviceInfo.vinCode]) {
                    changeCarOrProofBlock(kMessage_NeedProof,1);
                } else {
                    changeCarOrProofBlock(kMessage_NeedRegAndResetFactoryAndProof,3);
                }
            }
        }];
        
    }];
}

/**
 *  获取用户名下的所有车辆
 *
 *  @param user       用户
 *  @param completion 回调 succeed:YES[成功]/NO[失败]
 */
- (void)getCarsForUser:(UserInfo *)user compeltion:(void (^)(NSArray *cars, TorqueResult *result))completion {
    TorqueResult *result = [[TorqueResult alloc] init];
    if (!user.userId) {
        if (!user.userId) {
            result.message = kMessage_userIdNotNull;
        }
        
        if (completion) {
            completion(nil, result);
        }
        DDLogInfo(@"方法名:%s result:%ld message:%@", __FUNCTION__, result.result, result.message);
        return;
    }
    // 获取用户名下所有的车辆
    __weak TorqueDevice *weakSelf = self;
    [self getObjectsAtPath:kTorqueDeviceGetCarListPath
                parameters:kTorqueDeviceGetCarListParams(user.userId)
                   success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                       TorqueError *error = [[mappingResult dictionary] objectForKey:@"status"];
                       if (error.errorCode == 0) {
                           // 已注册设备列表--carInfo
                           weakSelf.registeredCars = [[mappingResult dictionary] objectForKey:@"result"];
                           result.succeed = YES;
                           
                       } else {
                           
                           // 显示errorMessage
                           DDLogInfo(@"errorCode: %ld, errorMessage: %@",(long)error.errorCode, error.errorMessage);
                       }
                       if (completion) {
                           completion(weakSelf.registeredCars, result);
                       }
                       DDLogInfo(@"方法名:%s result:%ld message:%@", __FUNCTION__, result.result, result.message);
                   } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                       NSLog(@"error:%@", error.userInfo);
                       result.message = error.localizedDescription;
                       result.error = error;
                       if (completion) {
                           completion(nil, result);
                       }
                       DDLogInfo(@"方法名:%s result:%ld message:%@", __FUNCTION__, result.result, result.message);
                   }];
}

/**
 *  设置车辆信息
 *
 *  @param car 车辆信息
 *  @param completion 设置完成时的回调block，succeed:YES[成功]/NO[失败] result：-1 失败, 0 成功，1 该车已在其他账号使用，2 vin获取失败，3 车辆已被注册(vin)
 */
- (void)setCarInfo:(CarInfo *)car completion:(void (^)(TorqueResult *result))completion {
    TorqueResult *result = [[TorqueResult alloc] init];
    car.userId = [TorqueGlobal sharedInstance].user.userId;
    
    if (!car.userId ||
        !car.vinCode ||
        !car.sn) {
        if (!car.userId) {
            result.message = kMessage_userIdNotNull;
        }
        if (!car.vinCode) {
            result.message = kMessage_vinCodeNotNull;
        }
        if (!car.sn) {
            result.message = kMessage_deviceSnNotNull;
        }
        //        if (!car.model) {
        //            result.message = kMessage_modelIdNotNull;
        //        }
        
        if (completion) {
            completion(result);
        }
        DDLogInfo(@"方法名:%s result:%ld message:%@", __FUNCTION__, result.result, result.message);
        return;
    }
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.obdDevice.deviceInfo.sn,@"sn", nil];
    
    [self postObject:car
                path:kTorqueDeviceRegisterCar
          parameters:params
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 TorqueError *error = [[mappingResult dictionary] objectForKey:@"status"];
                 result.message = error.errorMessage;
                 if (error.errorCode == 0) {
                     result.succeed = YES;
                     result.result = 0;
                     
                     [[TorqueGlobal sharedInstance] setCarInfo:car];
                     // 将该车辆的vin码记录到盒子中
                     // 注意：如果当前连接车辆和所设置VIN码车辆是同一辆时才设置vin码
                     // 防止新增未连接车辆vin码信息把之前设置的覆盖
                     [self readVinCode:^(NSString *vinCode, TorqueResult *result) {
                         if ([vinCode isEqualToString:car.vinCode]) {
                             [self setVinCode:car.vinCode completion:nil];
                         }
                     }];
                     // 清除插拔状态
                     [self clearPullOutFlag:nil];
                 } else if (error.errorCode == 401) {
                     result.result = 2;
                 } else if (error.errorCode == 402) {
                     result.result = 1;
                 } else if (error.errorCode == 200) {
                     result.result = 3;
                 } else {
                     result.result = TorqueSDK_NerWorkOther;//-1;
                 }
                 if (completion) {
                     completion(result);
                 }
                 DDLogInfo(@"方法名:%s result:%ld message:%@", __FUNCTION__, result.result, result.message);
             } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 result.result = TorqueSDK_NetWorkFailed;//-1;
                 result.message = error.localizedDescription;
                 result.error = error;
                 if (completion) {
                     completion(result);
                 }
                 DDLogInfo(@"方法名:%s result:%ld message:%@", __FUNCTION__, result.result, result.message);
             }];
}

/**
 *  是否需要校准总里程
 *
 *  @param completion 回调
 */
- (void)isNeedAdjustTotalDistance:(void (^)(BOOL result))completion {
    [self.obdDevice deviceWasPullOut:^(BOOL result) {
        if (completion) {
            completion(result);
        }
        DDLogInfo(@"方法名:%s result:%d", __FUNCTION__, result);
    }];
}

/**
 *  校准总里程
 *
 *  @param distance 汽车仪表盘上显示的总里程
 *  @param completion 设置完成时的回调block，succeed:YES[成功]/NO[失败] result：-1 失败, 0 成功
 */
- (void)resetTotalDistance:(NSUInteger)distance completion:(void (^)(TorqueResult *result))completion {
    //    TorqueResult *result = [[TorqueResult alloc] init];
    //    if (distance < 1) {
    //        result.message = kMessage_distanceIsZero;
    //        if (completion) {
    //            completion(result);
    //        }
    //        DDLogInfo(@"方法名:%s result:%ld message:%@", __FUNCTION__, result.result, result.message);
    //        return;
    //    }
    [self.obdDevice resetTotalDistance:distance completion:^(TorqueResult *result) {
        // 如果校准成功，设置Action log
        if (result.succeed) {
            // 服务端
            ActionLogItem *actionLog = [ActionLogItem new];
            actionLog.deviceId = [TorqueGlobal sharedInstance].deviceInfo.deviceId;
            actionLog.actionType = ActionLogTypeActionResetTotalDistance;
            actionLog.parameter = [NSString stringWithFormat:@"%ld", (long)distance];
            [self writeActionLogToServer:actionLog completion:^(TorqueResult *result) {
                if (result.succeed) {
                    // 本地
                    [[TorqueDataOperation sharedInstance] setResetTotalDistanceDate:[NSString currentDate]/*[NSDate date]*/];
                }
            }];
            DeviceInfo *device = [DeviceInfo new];
            device.vinCode = self.obdDevice.deviceInfo.vinCode;
            device.deviceId = self.obdDevice.deviceInfo.deviceId;
            device.mileage = distance;
            [self postObject:device
                        path:kSyncMileage
                  parameters:nil
                     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                         TorqueError *error = [[mappingResult dictionary] objectForKey:@"status"];
                         result.message = error.errorMessage;
                         if (error.errorCode == 0) {
                             result.succeed = YES;
                             result.result = 0;
                         } else if (error.errorCode == 401) {
                             result.result = TorqueSDK_NerWorkOther;//-1;
                         }
                         if (completion) {
                             completion(result);
                         }
                         DDLogInfo(@"方法名:%s result:%ld message:%@", __FUNCTION__, result.result, result.message);
                     } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                         result.result = TorqueSDK_NetWorkFailed;//-1;
                         result.message = error.localizedDescription;
                         result.error = error;
                         if (completion) {
                             completion(result);
                         }
                         DDLogInfo(@"方法名:%s result:%ld message:%@", __FUNCTION__, result.result, result.message);
                     }];
        } else {
            if (completion) {
                completion(result);
            }
            DDLogInfo(@"方法名:%s result:%ld message:%@", __FUNCTION__, result.result, result.message);
        }
    }];
}

- (NSDate *)getLastResetTotalDistanceDate {
    return [[TorqueDataOperation sharedInstance] getLastResetTotalDistanceDate];
}

/**
 *  读取vin码
 *
 *  @param completion 读取vin码的回调block,读取成功error为nil
 */
- (void)readVinCode:(void (^)(NSString *vinCode,TorqueResult *result))completion  {
    [self.obdDevice readVinCode:^(NSString *vinCode, TorqueResult *result) {
        DDLogInfo(@"方法名:%s 读取到的vin码为:%@", __FUNCTION__, vinCode);
        void (^SetCarInfoBlock)(NSString *vinCode) = ^(NSString *vinCode) {
            CarInfo *carInfo = [CarInfo new];
            carInfo.vinCode = vinCode;
            carInfo.sn = [TorqueGlobal sharedInstance].deviceInfo.sn;
            carInfo.userId = [TorqueGlobal sharedInstance].user.userId;
            
            [[TorqueGlobal sharedInstance] setCarInfo:carInfo];
        };
        //成功读取vin码
        if (vinCode.length) {
            //获取该用户名下的所有车辆
            [self getCarsForUser:[TorqueGlobal sharedInstance].user compeltion:^(NSArray *cars, TorqueResult *result) {
                if (cars.count) {
                    BOOL hasMatched=NO;
                    for (CarInfo *carInfo in cars) {
                        //匹配到车辆
                        if ([carInfo.vinCode isEqualToString:vinCode]) {
                            [[TorqueGlobal sharedInstance] setCarInfo:carInfo];
                            hasMatched = YES;
                            break;
                        }
                    }
                    
                    if (!hasMatched) {
                        SetCarInfoBlock(vinCode);
                    }
                }else{
                    SetCarInfoBlock(vinCode);
                }
            }];
        }
        
        if (completion) {
            completion(vinCode,result);
        }
        DDLogInfo(@"方法名:%s result:%ld message:%@, 读取到的vin码为:%@", __FUNCTION__, result.result, result.message, vinCode);
    }];
}

- (void)setVinCode:(NSString *)vinCode completion:(void (^)(TorqueResult *result))completion {
    [self.obdDevice setLastVin:vinCode completion:^(BOOL result) {
        TorqueResult *_result = [TorqueResult new];
        _result.succeed = result;
        if (result) {
            _result.message = @"保存VIN到设置成功!";
        } else {
            _result.message = @"保存VIN到设置失败!";
        }
        if (completion) {
            completion(_result);
        }
        DDLogInfo(@"方法名:%s result:%ld message:%@", __FUNCTION__, _result.result, _result.message);
    }];
}

- (void)readLastVin:(void (^)(NSString *vinCode, TorqueResult *result))completion {
    [self.obdDevice readLastVin:^(NSString *lastVIN, NSError *error) {
        TorqueResult *result = [TorqueResult new];
        result.succeed = (lastVIN != nil);
        if (completion) {
            completion(lastVIN, result);
        }
        DDLogInfo(@"方法名:%s result:%ld message:%@ 上次的vin码为:%@", __FUNCTION__, result.result, result.message, lastVIN);
    }];
}

/**
 *  读取obd信息
 *
 *  @param completion 读取结束的回调block,读取成功error为nil
 */
- (void)readObdInfo:(void (^)(OBDInfo *obdInfo,NSError *error))completion {
    [self.obdDevice readObdInfo:completion];
}

/**
 *  恢复出厂设置
 *
 *  @param completion
 */
- (void)restoreFactorySettings:(void (^)(NSError *error))completion {
    [self.obdDevice restoreFactorySettings:completion];
}

/**
 *  通过设备SN获取用户信息
 *
 *  @param device     设备对象，需初始化SN属性
 *  @param completion 设置完成时的回调block，succeed:YES[成功]/NO[失败] result： -1 失败, 0 成功，1 用户信息未发现
 */
- (void)getUserInfoBySN:(DeviceInfo *)device completion:(void (^)(UserInfo *userInfo, TorqueResult *result))completion {
    TorqueResult *result = [[TorqueResult alloc] init];
    if (!device.sn) {
        if (!device.sn) {
            result.message = kMessage_deviceSnNotNull;
        }
        if (completion) {
            completion(nil, result);
        }
        DDLogInfo(@"方法名:%s result:%ld message:%@", __FUNCTION__, result.result, result.message);
        return;
    }
    
    [self getObjectsAtPath:kTorqueDeviceGetUserInfoBySn
                parameters:kTorqueDeviceGetUserInfoBySnParams(device.sn)
                   success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                       TorqueError *error = [[mappingResult dictionary] objectForKey:@"status"];
                       result.message = error.errorMessage;
                       UserInfo *info = nil;
                       if (error.errorCode == 0) {
                           info = [[mappingResult dictionary] objectForKey:@"result"];
                           if (info) {
                               result.succeed = YES;
                               result.result = 0;
                           } else {
                               result.result = TorqueSDK_NerWorkOther;//-1;
                           }
                       } else if (error.errorCode == 401) {
                           result.result = 1;
                       }
                       if (completion) {
                           completion(info, result);
                       }
                       DDLogInfo(@"方法名:%s result:%ld message:%@", __FUNCTION__, result.result, result.message);
                   } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                       result.result = TorqueSDK_NetWorkFailed;//-1;
                       result.message = error.localizedDescription;
                       result.error = error;
                       if (completion) {
                           completion(nil, result);
                       }
                       DDLogInfo(@"方法名:%s result:%ld message:%@", __FUNCTION__, result.result, result.message);
                   }];
}

/**
 *  发送短信验证码
 *
 *  @param queryModel   包含手机号、SN的查询对象信息
 *  @param completion   设置完成时的回调block，succeed:YES[成功]/NO[失败] result： -1 失败, 0 成功
 */
- (void)getSmsCode:(DeviceUserQueryModel *)queryModel completion:(void (^)(TorqueResult *result))completion {
    TorqueResult *result = [[TorqueResult alloc] init];
    if (!queryModel.sn ||
        !queryModel.phoneNumber) {
        if (!queryModel.sn) {
            result.message = kMessage_deviceSnNotNull;
        }
        if (!queryModel.phoneNumber) {
            result.message = kMessage_phoneNumberNotNull;
        }
        if (completion) {
            completion(result);
        }
        DDLogInfo(@"方法名:%s result:%ld message:%@", __FUNCTION__, result.result, result.message);
        return;
    }
    queryModel.type = 1;
    [self postObject:queryModel
                path:kTorqueDeviceGetSmsCode
          parameters:nil
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 TorqueError *error = [[mappingResult dictionary] objectForKey:@"status"];
                 result.message = error.errorMessage;
                 if (error.errorCode == 0) {
                     result.succeed = YES;
                     result.result = 0;
                 } else if (error.errorCode == 401) {
                     result.result = TorqueSDK_NerWorkOther;//-1;
                 }
                 if (completion) {
                     completion(result);
                 }
                 DDLogInfo(@"方法名:%s result:%ld message:%@", __FUNCTION__, result.result, result.message);
             } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 result.result = TorqueSDK_NetWorkFailed;//-1;
                 result.message = error.localizedDescription;
                 result.error = error;
                 if (completion) {
                     completion(result);
                 }
                 DDLogInfo(@"方法名:%s result:%ld message:%@", __FUNCTION__, result.result, result.message);
             }];
}

#pragma mark - Private Method
- (void)createDescriptors {
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    // device
    RKObjectMapping *deviceInfoMapping = [RKObjectMapping mappingForClass:[DeviceInfo class]];
    /*  [deviceInfoMapping addAttributeMappingsFromDictionary:@{@"sn" : @"sn",
     @"name" : @"name",
     @"edition" : @"mode",
     @"userId" : @"userId",
     @"password" : @"passwd",
     @"vin" : @"vinCode",
     @"hardware_version" : @"hardwareVersion",
     @"firmware_version" : @"softwareVersion",
     @"channel_id" : @"channelId",
     @"channel_type" : @"",
     @"battery_voltage" : @"channelType",
     @"flow_balance" : @"flowBalance",
     @"service_provider" : @"serviceProvider",
     @"simcard_num" : @"simcardNum",
     @"phone_num" : @"phoneNum",
     @"the_charges" : @"theCharges",
     @"status" : @"status",}];*/
    [deviceInfoMapping addAttributeMappingsFromDictionary:@{@"sn" : @"sn",
                                                            @"name" : @"name",
                                                            @"edition" : @"mode",
                                                            @"user_id" : @"userId",
                                                            @"password" : @"passwd",
                                                            @"device_id" : @"deviceId",
                                                            @"firmware_version" : @"hardwareVersion",
                                                            @"vin" : @"vinCode",}];
    
    
    [self responseDescriptorWithMapping:deviceInfoMapping
                                 method:RKRequestMethodGET
                                   path:kTorqueDeviceGetListPath
                            pathPattern:nil
                                keyPath:@"result"
                            statusCodes:statusCodes];
    // 注册设备
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{@"sn" : @"sn",
                                                         @"name" : @"name",
                                                         @"mode" : @"edition",
                                                         @"userId" : @"user_id",
                                                         @"passwd" : @"password"}];
    [self requestDescriptorWithMapping:requestMapping
                           objectClass:[DeviceInfo class]
                                method:RKRequestMethodPOST
                                  path:kTorqueDeviceRegister
                           rootKeyPath:nil];
    
    RKObjectMapping *regRtnDeviceInfoMapping = [RKObjectMapping mappingForClass:[DeviceInfo class]];
    [regRtnDeviceInfoMapping addAttributeMappingsFromDictionary:@{@"sn" : @"sn",
                                                                  @"name" : @"name",
                                                                  @"edition" : @"mode",
                                                                  @"user_id" : @"userId",
                                                                  @"password" : @"passwd",
                                                                  @"device_id" : @"deviceId",
                                                                  @"vin" : @"vinCode"}];
    
    [self responseDescriptorWithMapping:regRtnDeviceInfoMapping
                                 method:RKRequestMethodPOST
                                   path:kTorqueDeviceRegister
                            pathPattern:nil
                                keyPath:@"result"
                            statusCodes:statusCodes];
    
    // 检查设备更新
    RKObjectMapping *deviceUpgradeMapping = [RKObjectMapping mappingForClass:[DeviceCheckUpgradeModel class]];
    [deviceUpgradeMapping addAttributeMappingsFromDictionary:@{@"description"  : @"upgradeDescription",
                                                               @"name"         : @"softwareName",
                                                               @"resultCode"   : @"resultCode",
                                                               @"create_time"  : @"createTime",
                                                               @"url"          : @"url",
                                                               @"version"      : @"version",
                                                               @"prd_version"  : @"prdVersion"}];
    
    
    [self responseDescriptorWithMapping:deviceUpgradeMapping
                                 method:RKRequestMethodGET
                                   path:kCheckDeviceUpgradePath
                            pathPattern:nil
                                keyPath:@"result"
                            statusCodes:statusCodes];
    
    // 获取车列表
    RKObjectMapping *carInfoMapping = [RKObjectMapping mappingForClass:[CarInfo class]];
    [carInfoMapping addAttributeMappingsFromDictionary:@{@"vin" : @"vinCode",
                                                         @"model_id" : @"modelId",
                                                         @"modelName" : @"modelName",
                                                         @"brandId" : @"brand",
                                                         @"brandName" : @"brandName",
                                                         @"seriesId" :@"series",
                                                         @"seriesName" : @"seriesName",
                                                         @"oem" : @"oem",
                                                         @"car_no" : @"plateNumber",
                                                         @"brandLogoUrl" : @"brandCoverImgUrl",
                                                         @"tankCapacity" : @"fueTankCapacity",
                                                         @"buy_date" : @"buyDate",
                                                         @"license_plate" : @"licensePlate",
                                                         @"fuel_type" : @"fuelType",
                                                         @"user_id" : @"userId",
                                                         @"car_id" : @"carId"}];
    
    [self responseDescriptorWithMapping:carInfoMapping
                                 method:RKRequestMethodGET
                                   path:kTorqueDeviceGetCarListPath
                            pathPattern:nil
                                keyPath:@"result"
                            statusCodes:statusCodes];
    
    // 车辆注册
    RKObjectMapping *requestCarMapping = [RKObjectMapping requestMapping];
    [requestCarMapping addAttributeMappingsFromDictionary:@{@"vinCode" : @"vin",
                                                            @"modelId" : @"model_id",
                                                            @"userId" : @"user_id",
                                                            @"mileage" : @"now_mileage",
                                                            @"buyDate" : @"buy_date",
                                                            @"licensePlate" : @"license_plate",
                                                            @"fuelType" : @"fuel_type",
                                                            @"sn" :  @"sn"}];
    [self requestDescriptorWithMapping:requestCarMapping
                           objectClass:[CarInfo class]
                                method:RKRequestMethodPOST
                                  path:kTorqueDeviceRegisterCar
                           rootKeyPath:nil];
    // userInfo
    RKObjectMapping *userInfoMapping = [RKObjectMapping mappingForClass:[UserInfo class]];
    [userInfoMapping addAttributeMappingsFromDictionary:@{@"phone" : @"phoneNumber",
                                                          @"user_id" : @"userId"}];
    
    [self responseDescriptorWithMapping:userInfoMapping
                                 method:RKRequestMethodGET
                                   path:kTorqueDeviceGetUserInfoBySn
                            pathPattern:nil
                                keyPath:@"result"
                            statusCodes:statusCodes];
    
    // 解绑设备
    RKObjectMapping *unregDeviceMapping = [RKObjectMapping requestMapping];
    [unregDeviceMapping addAttributeMappingsFromDictionary:@{@"sn" : @"sn",
                                                             @"smsCode" : @"smscode",
                                                             @"userId" : @"user_id"}];
    [self requestDescriptorWithMapping:unregDeviceMapping
                           objectClass:[DeviceUserQueryModel class]
                                method:RKRequestMethodPOST
                                  path:kTorqueDeviceUnregisterDevice
                           rootKeyPath:nil];
    // 发送验证码
    RKObjectMapping *getSmsCodeMapping = [RKObjectMapping requestMapping];
    [getSmsCodeMapping addAttributeMappingsFromDictionary:@{@"phoneNumber" : @"mobile",
                                                            @"userId" : @"userId",
                                                            @"type" : @"type",
                                                            @"sn" : @"sn"}];
    [self requestDescriptorWithMapping:getSmsCodeMapping
                           objectClass:[DeviceUserQueryModel class]
                                method:RKRequestMethodPOST
                                  path:kTorqueDeviceGetSmsCode
                           rootKeyPath:nil];
    
    // 校准里程
    RKObjectMapping *syncMileageMapping = [RKObjectMapping requestMapping];
    [syncMileageMapping addAttributeMappingsFromDictionary:@{@"vinCode" : @"vinCode",
                                                             @"deviceId" : @"device_id",
                                                             @"mileage" : @"nowMileage"}];
    [self requestDescriptorWithMapping:syncMileageMapping
                           objectClass:[DeviceInfo class]
                                method:RKRequestMethodPOST
                                  path:kSyncMileage
                           rootKeyPath:nil];
    //上传更新
    RKObjectMapping *uploadUpgradeMapping = [RKObjectMapping requestMapping];
    [uploadUpgradeMapping addAttributeMappingsFromDictionary:@{@"sn" : @"sn",
                                                               @"hardwareVersion" : @"prd_version",
                                                               @"softwareVersion" : @"version",
                                                               @"userId" : @"user_id"}];
    [self requestDescriptorWithMapping:uploadUpgradeMapping
                           objectClass:[DeviceInfo class]
                                method:RKRequestMethodPOST
                                  path:kUploadDeviceUpgradeInfoPath
                           rootKeyPath:nil];
    
    // 检查IAP更新
    RKObjectMapping *deviceIAPUpgradeMapping = [RKObjectMapping mappingForClass:[IAPInfo class]];
    [deviceIAPUpgradeMapping addAttributeMappingsFromDictionary:@{@"description"  : @"descriptionContent",
                                                                  @"name"         : @"name",
                                                                  @"resultCode"   : @"needUpdate",
                                                                  @"create_time"  : @"createTime",
                                                                  @"version"      : @"version",
                                                                  @"prd_version"  : @"hardWareVersion"}];
    
    
    [self responseDescriptorWithMapping:deviceIAPUpgradeMapping
                                 method:RKRequestMethodGET
                                   path:kCheckIAPNeedUpgradePath
                            pathPattern:nil
                                keyPath:@"result"
                            statusCodes:statusCodes];
    
    //xyy
    RKObjectMapping *editCarModelMapping = [RKObjectMapping requestMapping];
    [editCarModelMapping addAttributeMappingsFromDictionary:@{@"car_id"  : @"car_id",
                                                              @"model_id"   : @"model_id",
                                                              @"user_id"   : @"user_id",
                                                              @"device_id"  : @"device_id"}];
    
    [self requestDescriptorWithMapping:editCarModelMapping
                           objectClass:[EditCarModel class]
                                method:RKRequestMethodPOST
                                  path:kEditCarModelPath
                           rootKeyPath:nil];
    
}


- (DeviceInfo *)decodeDeviceQRCode:(NSString *)code
{
    NSString *deviceCode = [AESCrypt aes256Decrypt:code];
    
    NSArray *array = [deviceCode componentsSeparatedByString:@","];
    
    DeviceInfo *deviceInfo =nil;
    if (array.count == 3) {
        
        NSString *sn = array[0];
        NSString *pwd = array[1];
        NSString *name = array[2];
        
        //5114007049080--目前sn是13位
        //密码 6 位
        //蓝牙名称 12 位
        if (sn.length != 13
            || pwd.length !=6
            //            || name.length != 11
            ) {
            return deviceInfo;
        }
        
        //
        deviceInfo = [[DeviceInfo alloc] init];
        
        deviceInfo.sn=sn;
        deviceInfo.passwd = pwd;
        deviceInfo.name = name;
        deviceInfo.userId= [TorqueGlobal sharedInstance].user.userId;
    }
    
    return deviceInfo;
}

/**
 *  升级固件
 *
 *  @param completion 升级结束后的回调
 */
- (void)upgradeWithSoftwarePath:(NSString *)softwarePath progressBlock:(void (^)(float, NSString *))progress completion:(void (^)(OBDInfo *, TorqueResult *))completion {
    
    DDLogInfo(@"function:%s 开始升级", __FUNCTION__);
    [self.obdDevice upgradeWithSoftwarePath:softwarePath
                              targetVersion:self.deviceUpgradeInfo.version
                              progressBlock:progress
                                 completion:completion];
}

- (void)checkDeviceUpdateWithSdkVersion:(NSString *)sdkVersion sn:(NSString *)sn completion:(void (^)(DeviceCheckUpgradeModel *deviceUpgradeInfo, TorqueResult *result))completion {
    DDLogInfo(@"function:%s 检查更新", __FUNCTION__);
    TorqueResult *result = [[TorqueResult alloc]init];
    if (!sn|| !sdkVersion) {
        if (!sn) {
            result.message =  kMessage_deviceSnNotNull;
        }
        if (!sdkVersion) {
            result.message = kMessage_sdkVersionNotNull;
        }
        if (completion) {
            completion(nil,result);
        }
        DDLogInfo(@"方法名:%s result:%ld message:%@", __FUNCTION__, result.result, result.message);
        return;
    }
    _deviceUpgradeInfo = nil;
    [self getObjectsAtPath:kCheckDeviceUpgradePath parameters:kCheckDeviceUpgradeParams(sn, sdkVersion) success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        TorqueError *error = [[mappingResult dictionary] objectForKey:@"status"];
        result.message = error.errorMessage;
        if (error.errorCode == 0) {
            _deviceUpgradeInfo = [[mappingResult dictionary] objectForKey:@"result"];
            result.succeed = YES;
            result.result = (_deviceUpgradeInfo.resultCode == 1) ? 1 : 0;
        } else if (error.errorCode == 401 || error.errorCode == 402) {
            DDLogInfo(@"function:%s 检查固件更新失败%ld", __FUNCTION__, (long)error.errorCode);
            _deviceUpgradeInfo = [[mappingResult dictionary] objectForKey:@"result"];
            result.succeed = YES;
            result.result = TorqueSDK_NerWorkOther;//-1;
        }
        if (completion) {
            completion(_deviceUpgradeInfo, result);
        }
        DDLogInfo(@"方法名:%s result:%ld message:%@", __FUNCTION__, result.result, result.message);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        DDLogInfo(@"function:%s 检查固件更新失败%ld", __FUNCTION__, (long)error.code);
        result.result = TorqueSDK_NetWorkFailed;//-1;
        result.message = error.localizedDescription;
        result.error = error;
        if (completion) {
            completion(nil, result);
        }
        DDLogInfo(@"方法名:%s result:%ld message:%@", __FUNCTION__, result.result, result.message);
    }];
}

-(void)downloadSoftwareWithOutputPath:(NSString *)path urlString:(NSString *)urlString completion:(void (^)(NSString *, TorqueResult *))completion {
    DDLogInfo(@"function:%s 开始下载固件", __FUNCTION__);
    TorqueResult *result = [[TorqueResult alloc]init];
    NSURL *url = [NSURL URLWithString:urlString];
    NSString *fileName = [urlString lastPathComponent];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation10 *operation = [[AFHTTPRequestOperation10 alloc]initWithRequest:request];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation10 *operation, id responseObject) {
        DDLogInfo(@"function:%s 下载固件完成", __FUNCTION__);
        NSURL *url = [NSURL fileURLWithPath:path];
        NSError *error;
        [self skipBackupForURL:url error:&error];
        result.succeed = YES;
        completion(filePath, result);
    } failure:^(AFHTTPRequestOperation10 *operation, NSError *error) {
        DDLogInfo(@"function:%s 下载固件失败", __FUNCTION__);
        result.succeed = NO;
        completion(nil, result);
    }];
    
    [operation start];
    
}

- (void)skipBackupForURL:(NSURL *)anUrl error:(NSError **)anError {
    [anUrl setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:anError];
}

- (void)uploadUpgradeResultWithobdInfo:(DeviceInfo *)deviceInfo completion:(void (^)(TorqueResult *))completion {
    DDLogInfo(@"function:%s 开始上传固件", __FUNCTION__);
    TorqueResult *result = [[TorqueResult alloc]init];
    [self postObject:deviceInfo
                path:kUploadDeviceUpgradeInfoPath
          parameters:nil
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 TorqueError *error = [[mappingResult dictionary] objectForKey:@"status"];
                 result.message = error.errorMessage;
                 if (error.errorCode == 0) {
                     DDLogInfo(@"function:%s 上传固件成功", __FUNCTION__);
                     result.succeed = YES;
                     result.result = 0;
                 } else  {
                     DDLogInfo(@"function:%s 上传固件失败", __FUNCTION__);
                     result.result = TorqueSDK_NerWorkOther;//-1;
                 }
                 if (completion) {
                     completion(result);
                 }
                 DDLogInfo(@"方法名:%s result:%ld message:%@", __FUNCTION__, result.result, result.message);
             } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 DDLogInfo(@"function:%s 上传固件失败", __FUNCTION__);
                 result.result = TorqueSDK_NetWorkFailed;//-1;
                 result.message = error.localizedDescription;
                 result.error = error;
                 if (completion) {
                     completion(result);
                 }
                 DDLogInfo(@"方法名:%s result:%ld message:%@", __FUNCTION__, result.result, result.message);
             }];
    
}

- (void)checkIAPUpdateBySn:(NSString *)deviceSn completion:(void (^)(IAPInfo *iapInfo, TorqueResult *result))completion {
    TorqueResult *result = [[TorqueResult alloc]init];
    if (!deviceSn) {
        result.message =  kMessage_deviceSnNotNull;
        DDLogInfo(@"方法名:%s result:%ld message:%@", __FUNCTION__, result.result, result.message);
        return;
    }
    
    [self getObjectsAtPath:kCheckIAPNeedUpgradePath
                parameters:kCheckIAPNeedUpgradeParams(deviceSn)
                   success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                       TorqueError *error = [[mappingResult dictionary] objectForKey:@"status"];
                       result.result = error.errorCode;
                       IAPInfo *iapInfo = nil;
                       result.message = error.errorMessage;
                       if (error.errorCode == 0) {
                           result.succeed = YES;
                           iapInfo = [[mappingResult dictionary] objectForKey:@"result"];
                       } else if (error.errorCode == 401) {
                           result.message = kMessage_deviceSnNotNull;
                       }
                       else if (error.errorCode == 402) {
                           result.message = kMessage_deviceNotFound;
                       }
                       if (completion) {
                           completion(iapInfo, result);
                       }
                       DDLogInfo(@"方法名:%s result:%ld message:%@", __FUNCTION__, result.result, result.message);
                   } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                       result.result = TorqueSDK_NetWorkFailed;//-1;
                       result.message = error.localizedDescription;
                       result.error = error;
                       if (completion) {
                           completion(nil, result);
                       }
                       DDLogInfo(@"方法名:%s result:%ld message:%@", __FUNCTION__, result.result, result.message);
                   }];
}
/**
 *  清除盒子是否插拔过标记
 *
 *  @param completion
 */
- (void)clearPullOutFlag:(void (^)(BOOL result))completion {
    [self.obdDevice clearPullOutFlag:^(BOOL result) {
        DDLogInfo(@"清除插拔状态:%@", result ? @"成功" : @"失败");
        if (completion) {
            completion(result);
        }
    }];
}

//xyy
- (void)editCarModel:(EditCarModel *)car completion:(void (^)(TorqueResult *result))completion
{
    TorqueResult *result = [[TorqueResult alloc]init];
    
    [self postObject:car
                path:kEditCarModelPath
          parameters:nil
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 TorqueError *error = [[mappingResult dictionary] objectForKey:@"status"];
                 result.message = error.errorMessage;
                 if (error.errorCode == 0) {
                     DDLogInfo(@"function:%s 成功", __FUNCTION__);
                     result.succeed = YES;
                     result.result = 0;
                 } else  {
                     DDLogInfo(@"function:%s 失败", __FUNCTION__);
                     result.result = TorqueSDK_NerWorkOther;//-1;
                 }
                 if (completion) {
                     completion(result);
                 }
                 DDLogInfo(@"方法名:%s result:%ld message:%@", __FUNCTION__, result.result, result.message);
             } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 result.result = TorqueSDK_NetWorkFailed;//-1;
                 result.message = error.localizedDescription;
                 result.error = error;
                 if (completion) {
                     completion(result);
                 }
                 DDLogInfo(@"方法名:%s result:%ld message:%@", __FUNCTION__, result.result, result.message);
             }];
}

@end
