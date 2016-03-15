//
//  OBDDevice.m
//  OBD-DEMO
//
//  Created by zhangjipeng on 1/23/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import "OBDDevice.h"
#import "WorkStatus.h"
#import "NSString+Date.h"
#import "TorqueDevice.h"


@interface OBDDevice ()

@property (nonatomic, strong) id<Connector> connector;


@property (nonatomic) BOOL isPIDMode;               // 是否是PID模式
@property (nonatomic) BOOL isAccelerationTestMode;  // 是否是百公里加速测试模式

@property (nonatomic) NSInteger authTimes;
@property (nonatomic) BOOL authSuccess;

@end

@implementation OBDDevice

+ (instancetype)sharedInstance {
    static OBDDevice *obdDevice = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obdDevice = [OBDDevice new];
        DDLogVerbose(@"Created obdDevice!");
    });
    return obdDevice;
}

- (instancetype)init {
    if (self = [super init]) {
        _dataProcessor = [DataProcessor sharedInstance];
        _log = ^(NSString *message) { };
        _authTimes = 0;
        _deviceIsConnected = NO;
        _authSuccess = NO;
        _maxTripCount = 1024;
    }
    return self;
}


- (void)setConnectMode:(TorqueDeviceConnetMode)connectMode {
    _connectMode = connectMode;
    self.connector = [ConnectorFactory connectorForMode:_connectMode];
    self.dataProcessor.connector = self.connector;
}


/**
 *  搜索设备
 *
 *  @param mode       连接方式
 *  @param completion 返回设备列表
 */
- (void)discoverDeviceForMode:(TorqueDeviceConnetMode)mode
                   completion:(void (^)(NSArray *devices))completion {
    self.connectMode = mode;
    [self.connector discoverDevice:^(NSArray *devices) {
        completion(devices);
    }];
}

/**
 *  逐个搜索设备
 *
 *  @param mode   连接模式
 *  @param next   搜索到的一个设备的name
 *  @param completion 搜索是否超时
 *  @param errorBlock 错误处理block
 */
- (void)discoverDeviceForMode:(TorqueDeviceConnetMode)mode
                         next:(BOOL (^)(NSString *deviceName))next
                   completion:(void (^)(BOOL timeout))completion
                        error:(void (^)(NSError *error))errorBlock; {
    self.connectMode = mode;
    [self.connector discoverDeviceNext:next completion:completion error:errorBlock];
}

/**
 *  连接设备
 *
 *  @param mode               连接模式
 *  @param needAuthentication 是否需要鉴权
 *  @param completion         连接完成时的回调block， result： 0 成功，1 未发现设备，2 失败，3 密码鉴权超时
 *  @param disconnection      断开连接时的回调
 */
- (void)connectWithMode:(TorqueDeviceConnetMode)mode
     needAuthentication:(BOOL)needAuthentication
             completion:(void (^)(NSInteger result))completion
          disconnection:(void (^)(NSError *error))disconnection {
    __weak OBDDevice *weakSelf = self;
    if (self.dataProcessor.obdMode == OBDModeNormal) {
        __block BOOL timeout = YES;
        self.connectMode = mode;
        DeviceConfidential *confidential = [[DeviceConfidential alloc] initWithPassword:self.deviceInfo.passwd];
        
        if (needAuthentication) {
            DDLogVerbose(@"开始鉴权成功");
            [self setAuthentication:^(NSInteger result) {
                if (result == 0) {
#if OBDDeviceRTDefaultOff
                    // 鉴权通过后关闭实时数据流，用到的时候再打开
                    [weakSelf.dataProcessor fetchDataStreamForType:OBDDataStreamTypeRTOff AndParam:nil completion:^(OBDDataStream *stream, NSError *error) {
                    }];
#endif
                    DDLogVerbose(@"鉴权成功。");
                    weakSelf.log(@"鉴权成功。");
                    
                    timeout = NO;
                    [NSObject cancelPreviousPerformRequestsWithTarget:weakSelf selector:@selector(authenticate:) object:confidential.password];
                    weakSelf.authSuccess = YES;
                    
                    // 鉴权成功，校准RTC时间
                    NSDate *date = [NSString currentDate];//[NSDate date];
                    [weakSelf setObdRTCDate:date completion:^(NSInteger result) {
                        if (result == 1) {
                            DDLogError(@"Set OBD RTC Date Field!");
                        } else {
                            DDLogDebug(@"Set OBD RTC Date %@ Success!",[NSString stringFromDate:date ForDateFormatter:nil]);
                        }
                    }];
                    
                    DDLogVerbose(@"开始读取obdInfo");
                    // 读取obdInfo
                    [weakSelf readObdInfo:^(OBDInfo *obdInfo, NSError *error) {
                        if (!obdInfo) {
                            DDLogDebug(@"未读取到obdInfo");
                            if (completion) {
                                completion(2);
                            }
                            [weakSelf disconnect];
                        } else {
                            DDLogDebug(@"读取obdInfo成功");
                            if (completion) {
                                completion(0);
                            }
                        }
                    }];
                }
                else//增加认证失败的处理逻辑   gsy  15-8-18
                {
                    if (completion) {
                        completion(2);
                    }
                    [weakSelf disconnect];
                }
            }];
        }
        
        _deviceIsConnected = NO;
        [self.connector connectDevice:self.deviceInfo
                     withConfidential:confidential
                     AndDataProcessor:self.dataProcessor
                           completion:^(NSInteger result) {
                               if (result == 0) {
                                   _deviceIsConnected = YES;
                                   // 如果需要鉴权，则添加鉴权超时及鉴权逻辑
                                   if (needAuthentication) {
                                       // 连接成功，开始鉴权
                                       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kAuthenticationTimeout * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                           if (timeout && self.deviceIsConnected) {
                                               DDLogVerbose(@"鉴权超时。");
                                               weakSelf.log(@"鉴权超时。");
                                               [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(authenticate:) object:nil];
                                               [self.dataProcessor closeDataStreamForType:OBDDataStreamTypeAuthentication];
                                               [self disconnect];
                                               completion(3);
                                           }
                                       });
                                       
                                       DDLogVerbose(@"连接成功，开始鉴权。");
                                       self.log(@"连接成功，开始鉴权。");
                                       
                                       self.authTimes = 0;
                                       self.authSuccess = NO;
                                       [self performSelector:@selector(authenticate:) withObject:confidential.password afterDelay:0.5];
                                   }
                               } else {
                                   if (completion) {
                                       completion(result);
                                   }
                               }
                           }
                        disconnection:^(NSError *error) {
                            DDLogVerbose(@"连接断开。");
                            self.log(@"连接断开。");
                            [[NSNotificationCenter defaultCenter] postNotificationName:kNotifactionDisConnectedInSDK object:nil];

                            _deviceIsConnected = NO;
                            _dataProcessor.obdMode = OBDModeNormal;
                            if (disconnection) {
                                disconnection(error);
                            }
                        }];
    } else {
        [self.connector connectDevice:self.deviceInfo withConfidential:nil AndDataProcessor:self.dataProcessor completion:completion disconnection:^(NSError *error) {
            _deviceIsConnected = NO;
            _dataProcessor.obdMode = OBDModeNormal;
            if (disconnection) {
                disconnection(error);
            }
        }];
    }
}
/**
 *  连接设备
 *
 *  @param mode       连接模式
 *  @param completion 连接完成时的回调block， result： 0 成功，1 未发现设备，2 失败，3 密码鉴权超时
 */
- (void)connectWithMode:(TorqueDeviceConnetMode)mode
             completion:(void (^)(NSInteger result))completion
          disconnection:(void (^)(NSError *error))disconnection {
    [self connectWithMode:mode needAuthentication:YES completion:completion disconnection:disconnection];
}

- (void)authenticate:(NSString *)confidential {
    if (!_deviceIsConnected) {
        return;
    }
    NSString *password = [NSString stringWithFormat:@"ATAKEY=%@",confidential];
    DDLogVerbose(@"Write password:%@ to authenticate.",password);
    NSData *data = [[password stringByAppendingString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding];
    [self.connector sendData:data];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(authenticate:) object:confidential];
    
    self.authTimes++;
    if (self.authTimes < kAuthenticationTimes && !self.authSuccess) {
        [self performSelector:@selector(authenticate:) withObject:confidential afterDelay:kAuthenticationTimeinterval];
    }
}

/**
 *  车辆是否进入怠速状态
 *
 *  @param completion 回调
 */
- (void)engineIsIdling:(void (^)(BOOL result))completion {
    __block BOOL timeOut = YES;
    
    [self.dataProcessor suspendDataStreamForType:OBDDataStreamTypeRT];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kEngineIdlingTimeout * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (timeOut) {
            CloseDataStreamForType(OBDDataStreamTypeEngineIdling);
            [self.dataProcessor resumeDataStreamForType:OBDDataStreamTypeRT];
            if (completion) {
                completion(NO);
            }
        }
    });
    
    __weak OBDDevice *weakSelf = self;
    [self.dataProcessor fetchDataStreamForType:OBDDataStreamTypeEngineIdling
                                      AndParam:nil
                                    completion:^(OBDDataStream *stream, NSError *error) {
                                        timeOut = NO;
                                       
                                        if (completion) {
                                            if (!stream || ![stream isKindOfClass:[OBDDataStream class]]|| [stream isEqual:@"?"] || error) {
                                                completion(NO);
                                            }
                                            else
                                            {
                                                OBDDataItem *item = [stream.items firstObject];
                                                if ([item.value integerValue] == 1) {
                                                    completion(YES);
                                                } else {
                                                    completion(NO);
                                                }
                                            }
                                        }
                                        
                                        [weakSelf.dataProcessor resumeDataStreamForType:OBDDataStreamTypeRT];
                                        [weakSelf.dataProcessor closeDataStreamForType:OBDDataStreamTypeEngineIdling];
                                    }];
}

/**
 *  车辆是否进入启动
 *
 *  @param completion 回调
 */
- (void)engineIsIdlingWithMode:(void (^)(NSInteger))completion {
    __block BOOL timeOut = YES;
    
    [self.dataProcessor suspendDataStreamForType:OBDDataStreamTypeRT];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kEngineIdlingTimeout * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (timeOut) {
            CloseDataStreamForType(OBDDataStreamTypeEngineIdling);
            [self.dataProcessor resumeDataStreamForType:OBDDataStreamTypeRT];
            if (completion) {
                completion(-1);
            }
        }
    });
    
    __weak OBDDevice *weakSelf = self;
    [self.dataProcessor fetchDataStreamForType:OBDDataStreamTypeEngineIdling
                                      AndParam:nil
                                    completion:^(OBDDataStream *stream, NSError *error) {
                                        timeOut = NO;
                                        
                                        if (completion) {
                                            if (!stream || ![stream isKindOfClass:[OBDDataStream class]]|| [stream isEqual:@"?"] || error) {
                                                completion(-1);
                                            }
                                            else
                                            {
                                                OBDDataItem *item = [stream.items firstObject];
                                                completion([item.value integerValue]);
                                            }
                                        }
                                        
                                        [weakSelf.dataProcessor resumeDataStreamForType:OBDDataStreamTypeRT];
                                        [weakSelf.dataProcessor closeDataStreamForType:OBDDataStreamTypeEngineIdling];
                                    }];
}

/**
 *  断开连接
 */
- (void)disconnect {
    [self.connector disconnect];
    _deviceIsConnected = NO;
}

#if 0
/**
 *  重新连接
 *
 *  @param mode          连接模式
 *  @param completion    连接完成时的回调block， result： 0 成功，1 未发现设备，2 失败，3 密码鉴权失败
 *  @param disconnection 连接断开回调
 */
- (void)reConnectWithMode:(TorqueDeviceConnetMode)mode
               completion:(void (^)(NSInteger result))completion
            disconnection:(void (^)(NSError *error))disconnection {
    __weak OBDDevice *weakSelf = self;
    if (self.dataProcessor.obdMode == OBDModeNormal) {
        [self setAuthentication:^(NSInteger result) {
            if (result == 0) {
#if OBDDeviceRTDefaultOff
                // 鉴权通过后关闭实时数据流，用到的时候再打开
                [weakSelf.dataProcessor fetchDataStreamForType:OBDDataStreamTypeRTOff AndParam:nil completion:^(OBDDataStream *stream, NSError *error) {
                }];
#endif
                
                if (result == 0) {
                    NSDate *date = [NSString currentDate];//[NSDate date];
                    [weakSelf setObdRTCDate:date completion:^(NSInteger result) {
                        DDLogDebug(@"Set OBD RTC Date %@ Success!",[NSString stringFromDate:date ForDateFormatter:nil]);
                    }];
                }
                completion(0);
            } else {
                completion(3);
            }
        }];
        
        self.connectMode = mode;
        DeviceConfidential *confidential = [[DeviceConfidential alloc] initWithPassword:self.deviceInfo.passwd];
        [self.connector reConnectDevicewithConfidential:confidential completion:completion disconnection:disconnection];
    } else {
        [self.connector reConnectDevicewithConfidential:nil completion:completion disconnection:disconnection];
    }

}
#endif

/**
 *  校准总里程
 *
 *  @param distance 汽车仪表盘上显示的总里程
 */
- (void)resetTotalDistance:(NSUInteger)distance
                completion:(void (^)(TorqueResult *result))completion {
    TorqueResult *_result = [[TorqueResult alloc] init];
    
    __weak OBDDevice *weakSelf = self;
    __block BOOL timeout = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kAdjustTotalDistanceTimeout * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (timeout) {
            [self.dataProcessor closeDataStreamForType:OBDDataStreamTypeADJ];
            _result.succeed = NO;
            _result.result = 306;
            _result.message = [[weakSelf.dataProcessor.errors objectForKey:@"306"] objectForKey:@"message"];
            if (completion) {
                completion(_result);
            }
        }
    });
    /*
    self.dataProcessor.errorHandler = ^(NSString *errorCode) {
        if ([errorCode isEqualToString:@"304"] || [errorCode isEqualToString:@"305"] || [errorCode isEqualToString:@"306"]) {
            _result.succeed = NO;
            _result.result = errorCode.integerValue;
            _result.message = [[weakSelf.dataProcessor.errors objectForKey:errorCode] objectForKey:@"message"];
            if (!timeout && completion) {
                completion(_result);
            }
        }
    };
     */
    
    [self.dataProcessor fetchDataStreamForType:OBDDataStreamTypeADJ
                                      AndParam:[NSString stringWithFormat:@"%lu",(unsigned long)distance]
                                    completion:^(OBDDataStream *stream, NSError *error) {
                                        NSArray *items = stream.items;
                                        OBDDataItem *item = [items firstObject];
                                        NSString *result = [item value];
                                        
                                        timeout = NO;
                                        if (completion) {
                                            if ([result isEqualToString:@"OK"]) {
                                                _result.succeed = YES;
                                                _result.result = 0;
                                                completion(_result);
                                            } else {
                                                _result.result = -1;
                                                completion(_result);
                                            }
                                        }
                                    }];
}


- (void)getVinCode:(NSInteger)index
           timeoutArray:(NSArray *)timeoutArray
        completion:(void (^)(NSString *vinCode,TorqueResult *result))completion
{
    
   __block BOOL isCompletion = FALSE;
    
    [self.dataProcessor fetchDataStreamForType:OBDDataStreamTypeVI AndParam:nil
                                    completion:^(OBDDataStream *stream, NSError *error) {
                                        TorqueResult *result = [TorqueResult new];
                                        
                                        if (!error) {
                                            isCompletion = TRUE;
                                            
                                            OBDDataItem *item = [stream.items lastObject];
                                            NSString *value = item.value;
                                            if (completion) {
                                                DDLogVerbose(@"read Vin Time1:%@ Success!",value);
                                                
                                                if (value && ![value isEqualToString:@"NULL"]) {
                                                    result.succeed = TRUE;
                                                    result.result = 0;
                                                    result.message=@"成功获取vin码";
                                                    
                                                }else{
                                                    value = nil;
                                                    result.succeed = FALSE;
                                                    result.result = 101;
                                                    result.message = @"获取到的vin码值为空";
                                                }
                                                
                                                completion(value,result);
                                            }
                                        }else{//失败-即超时
                                            DDLogVerbose(@"read Vin Time1 error!");
                                            
                                        }
                                    }];
    
    __block NSInteger nextIndex = index + 1;
    NSInteger count = timeoutArray.count;

    if (nextIndex > count ) {
        if (completion) {
            TorqueResult *result = [TorqueResult new];
            result.succeed = FALSE;
            result.result = 102;
            result.message = @"获取vin码超时";
            
            completion(nil, result);
        }
        
        return;
    }
    
    float timeout = [timeoutArray[index] floatValue];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeout * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       if (!isCompletion) {
                               [self getVinCode:nextIndex timeoutArray:timeoutArray completion:completion];
                       }
                   });
}

/**
 *  读取vin码
 *
 *  @param completion 读取vin码的回调block,读取成功error为nil
 */
- (void)readVinCode:(void (^)(NSString *vinCode,TorqueResult *result))completion
 {
#if USE_EST527
    [self.dataProcessor fetchDataStreamForType:OBDDataStreamTypeVIN AndParam:nil
                                    completion:^(OBDDataStream *stream, NSError *error) {
        OBDDataItem *item = [stream.items firstObject];
        NSString *value = item.value;
        if (completion) {
            completion(value,error);
        }
    }];
#elif USE_EST530
    
    CGFloat time1=0.5f;
    CGFloat time2=1.f;
    CGFloat time3=1.5f;
    
    NSArray *timeoutArray = @[@(time1),@(time2), @(time3)];
    
    [self getVinCode:0 timeoutArray:timeoutArray completion:^(NSString *vinCode, TorqueResult *result) {
        DDLogVerbose(@"vin:%@, error:%@", vinCode, result.message);
        if (completion) {
            completion(vinCode, result);
        }
    }];    
#endif
}

/**
 *  读取obd信息
 *
 *  @param completion 读取结束的回调block,读取成功error为nil
 */
- (void)readObdInfo:(void (^)(OBDInfo *obdInfo,NSError *error))completion {
//    __block BOOL timeOut = YES;
//    [self startTimeout:kATBackCallTimer completion:^(TorqueResult *result) {
//        if (timeOut) {
//            DDLogDebug(@"读取obdInfo超时");
//            CloseDataStreamForType(OBDDataStreamTypeDeviceInfo);
//            if (completion) {
//                completion(nil, nil);
//            }
//        }
//    }];
    [self.dataProcessor fetchDataStreamForType:OBDDataStreamTypeDeviceInfo AndParam:nil
                                    completion:^(OBDDataStream *stream, NSError *error) {
                                        //timeOut = NO;
                                        OBDInfo *obdInfo = [[OBDInfo alloc] initWithDataStream:stream];
                                        
                                        if(obdInfo.hardwareVersion)
                                        {
                                            DDLogDebug(@"fetchDataStreamForType_读取到obdInfo");
                                            self.isReadOBDSucess = YES;
                                            
                                            if ([obdInfo.hardwareVersion isEqualToString:kEST530HardwareVersion]) {
                                                // 判断软件版本号是否大于4.0
                                                // 如果大于4.0则把最大行程和批量读取行程的参数设置为与531的一致
                                                BOOL softVerLargeThan40 = [[[obdInfo.softwareVersion lowercaseString] stringByReplacingOccurrencesOfString:@"v" withString:@""] floatValue] >= 4.0;
                                                DDLogInfo(@"盒子硬件版本号:%@, EST530",obdInfo.hardwareVersion);
                                                self.maxTripCount = softVerLargeThan40 ? kEST531MaxTripCount :kEST530MaxTripCount;
                                                self.batchTripCount = softVerLargeThan40 ? kEST531BatchTripCount : kEST530BatchTripCount;
                                                self.useBatchFetch = softVerLargeThan40 ? YES : NO;
                                            } else if ([obdInfo.hardwareVersion isEqualToString:kEST531HardwareVersion]) {
                                                DDLogInfo(@"盒子硬件版本号:%@, EST531",obdInfo.hardwareVersion);
                                                self.maxTripCount = kEST531MaxTripCount;
                                                self.batchTripCount = kEST531BatchTripCount;
                                                self.useBatchFetch = YES;
                                            }
                                            
                                            if (completion) {
                                                completion(obdInfo,error);
                                            }
                                        }
                                        else
                                        {
                                            DDLogDebug(@"fetchDataStreamForType_读取obd信息失败");
                                            self.isReadOBDSucess = NO;
                                            if (completion) {
                                                //读取obd信息失败
                                                completion(nil,[NSError errorWithDomain:@"com.torque" code:-1 userInfo:nil]);
                                            }
                                        }
                                        
                                    }];
}

/**
 *  读取obd RTC日期时间
 *
 *  @param completion
 */
- (void)readObdRTCDate:(void (^)(NSDate *date,NSError *error))completion {
    [self.dataProcessor fetchDataStreamForType:OBDDataStreamTypeGetRTC AndParam:nil completion:^(OBDDataStream *stream, NSError *error) {
        OBDDataItem *item = [stream.items lastObject];
        NSString *value = item.value;
        NSDate *date = [NSString dateFromString:value ForDateFormatter:nil];
        if (completion) {
            completion(date,error);
        }
    }];
}

/**
 *  设置obd RTC日期时间
 *
 *  @param date 日期时间
 *  @param completion 设置完成时的回调block， result： 0 成功，1 失败
 */
- (void)setObdRTCDate:(NSDate *)date
           completion:(void (^)(NSInteger result))completion {
    NSString *dateString = [NSString stringFromDate:date ForDateFormatter:@"yyyyMMdd HHmmss"];
    [self.dataProcessor fetchDataStreamForType:OBDDataStreamTypeSetRTC AndParam:dateString completion:^(OBDDataStream *stream, NSError *error) {
        OBDDataItem *item = [stream.items lastObject];
        NSString *value = item.value;
        if (completion) {
            if ([value isEqualToString:@"OK"]) {
                completion(0);
            } else {
                completion(1);
            }
            
        }
    }];
}

/**
 *  恢复出厂设置
 *
 *  @param completion
 */
- (void)restoreFactorySettings:(void (^)(NSError *error))completion {
    
    __block typeof (self) weakSelf = self;
    
    [self.dataProcessor fetchDataStreamForType:OBDDataStreamTypeZ AndParam:nil completion:^(OBDDataStream *stream, NSError *error) {
//        异常处理  by gsy   2015-08-21
        if (completion) {
            if(stream && stream.items)
            {
                OBDDataItem *item = [stream.items lastObject];
                NSString *value = item.value;
                
                    if ([value isEqualToString:@"OK"]) {
                        completion(nil);
                    } else {
                        //completion(1);
                        completion(error);
                    }
                
            }
            else
            {
                completion([NSError errorWithDomain:@"com.torque"
                                               code:-1
                                           userInfo:@{NSLocalizedDescriptionKey: [weakSelf.dataProcessor.errors objectForKey:@"503"]}]);
            }
        }
    }];
}

#pragma mark - Private method
- (void)setAuthentication:(void (^)(NSInteger result))completion {
    [self.dataProcessor fetchDataStreamForType:OBDDataStreamTypeAuthentication
                                      AndParam:nil
                                    completion:^(OBDDataStream *stream, NSError *error) {
                                        OBDDataItem *item = [stream.items lastObject];
                                        NSString *value = item.value;
                                        if (completion) {
                                            if ([value isEqualToString:@"0"]) {
                                                DDLogVerbose(@"Authenticate Success!");
                                                completion(0);
                                            } else {
                                                DDLogVerbose(@"Authenticate Failed!");
                                                completion(1);
                                            }
                                        }
                                    }];
}

@end
