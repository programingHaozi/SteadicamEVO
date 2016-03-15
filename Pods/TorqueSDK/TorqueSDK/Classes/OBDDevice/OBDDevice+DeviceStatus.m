//
//  OBDDevice+DeviceStatus.m
//  TorqueSDK
//
//  Created by zhangjipeng on 2/9/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import "OBDDevice+DeviceStatus.h"
#import "OBDDeviceFuncMacro.h"
#import "TorqueSDKCoreDataHelper.h"
#import "TorqueContextModel.h"
#import "DeviceInfoModel.h"
#import "NSString+Date.h"

@implementation OBDDevice (DeviceStatus)

/**
 *  读取盒子是否插拔过标记
 *
 *  @param completion
 */
- (void)readPullOutFlag:(void (^)(BOOL result))completion {
    __weak OBDDevice *weakSelf = self;
    [self.dataProcessor fetchDataStreamForType:OBDDataStreamTypeReadPullOut
                                      AndParam:nil
                                    completion:^(OBDDataStream *stream, NSError *error) {
                                        OBDDataItem *item = [stream.items firstObject];
                                        if ([item.value isEqualToString:@"1"]) {
                                            completion(YES);
                                            DDLogDebug(@"%s 盒子插拔过!", __FUNCTION__);
#if 0
                                            [weakSelf clearPullOutFlag:^(BOOL result) {
                                                if (result) {
                                                    DDLogDebug(@"Clear Pull Out Flage Success!");
                                                } else {
                                                    DDLogDebug(@"Clear Pull Out Flage Failed!");
                                                }
                                            }];
#endif
                                        } else {
                                            completion(NO);
                                            DDLogDebug(@"%s 盒子未插拔过!", __FUNCTION__);
                                        }
                                    }];
}

/**
 *  清除盒子是否插拔过标记
 *
 *  @param completion
 */
- (void)clearPullOutFlag:(void (^)(BOOL result))completion {
    [self.dataProcessor fetchDataStreamForType:OBDDataStreamTypeClearPullOut
                                      AndParam:nil
                                    completion:^(OBDDataStream *stream, NSError *error) {
                                        OBDDataItem *item = [stream.items firstObject];
                                        if ([item.value isEqualToString:@"0"]) {
                                            completion(YES);
                                            DDLogDebug(@"Clear Pull Out Flage Success!");
                                        } else {
                                            completion(NO);
                                            DDLogDebug(@"Clear Pull Out Flage Failed!");
                                        }
                                    }];
}

/**
 *  设置盒子所插入的车辆的vin码
 *
 *  @param vin        车辆vin码
 *  @param completion
 */
- (void)setLastVin:(NSString *)vin completion:(void (^)(BOOL result))completion {
    [self.dataProcessor fetchDataStreamForType:OBDDataStreamTypeSetLastVin
                                      AndParam:vin
                                    completion:^(OBDDataStream *stream, NSError *error) {
                                        OBDDataItem *item = [stream.items firstObject];
                                        if ([item.value isEqualToString:@"0"]) {
                                            completion(YES);
                                        } else {
                                            completion(NO);
                                        }
                                    }];
}

/**
 *  读取盒子上次连接的车辆的vin码
 *
 *  @param completion
 */
- (void)readLastVin:(void (^)(NSString *lastVIN, NSError *error))completion {
    __block BOOL timeOut = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kReadDataStreamTimeout * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (timeOut) {
            CloseDataStreamForType(OBDDataStreamTypeReadLastVin);
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"读取盒子上次连接的车辆的vin码超时！"};
            NSError *aError = [NSError errorWithDomain:OBDErrorDomain code:OBDErrorReadLastVin userInfo:userInfo];
            if (completion) {
                completion(nil,aError);
            }
        }
    });
    [self.dataProcessor fetchDataStreamForType:OBDDataStreamTypeReadLastVin
                                      AndParam:nil
                                    completion:^(OBDDataStream *stream, NSError *error) {
                                        timeOut = NO;
                                        OBDDataItem *item = [stream.items firstObject];
                                        if (item.value) {
                                            if ([item.value isEqualToString:@"NULL"]) {
                                                NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"盒子lastVin码为null"};
                                                NSError *aError = [NSError errorWithDomain:OBDErrorDomain code:OBDErrorReadLastVin userInfo:userInfo];
                                                completion(nil,aError);
                                            } else {
                                                completion(item.value, nil);
                                            }
                                        } else {
                                            NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"读取盒子上次连接的车辆的vin码失败！"};
                                            NSError *aError = [NSError errorWithDomain:OBDErrorDomain code:OBDErrorReadLastVin userInfo:userInfo];
                                            completion(nil,aError);
                                        }
                                    }];
}

- (void)deviceWasPullOut:(void (^)(BOOL result))completion {
    [self readPullOutFlag:^(BOOL result) {
        if (completion) {
            completion(result);
        }
    }];
}

- (void)powerOnReasonAndTime:(void (^)(OBDPowerOn *powerOn, NSError *error))completion {
    __block BOOL timeOut = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kPowerOnReasonTimeout * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (timeOut) {
            CloseDataStreamForType(OBDDataStreamTypeStatus);
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"获取设备启动类型超时！"};
            NSError *aError = [NSError errorWithDomain:OBDErrorDomain code:OBDErrorTimeout userInfo:userInfo];
            if (completion) {
                completion(nil,aError);
            }
        }
    });
    [self.dataProcessor fetchDataStreamForType:OBDDataStreamTypeStatus
                                      AndParam:nil
                                    completion:^(OBDDataStream *stream, NSError *error) {
                                        OBDPowerOn *powerOn = [[OBDPowerOn alloc] initWithDataStream:stream];
                                        timeOut = NO;
                                        if (completion) {
                                            completion(powerOn,error);
                                        }
    }];
}

@end
