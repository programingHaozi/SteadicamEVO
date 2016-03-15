//
//  OBDDevice+DeviceStatus.h
//  TorqueSDK
//
//  Created by zhangjipeng on 2/9/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import "OBDDevice.h"
#import "OBDPowerOn.h"


@interface OBDDevice (DeviceStatus)


/**
 *  设备是否被被拔掉过
 *
 *  @param completion 是否被拔掉过的回调
 */
- (void)deviceWasPullOut:(void (^)(BOOL result))completion;

/**
 *  设备启动原因
 *
 *  @param completion 回调
 */
- (void)powerOnReasonAndTime:(void (^)(OBDPowerOn *powerOn, NSError *error))completion NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, "方法已作废");

/**
 *  设置盒子所插入的车辆的vin码
 *
 *  @param vin        车辆vin码
 *  @param completion
 */
- (void)setLastVin:(NSString *)vin completion:(void (^)(BOOL result))completion;

/**
 *  读取盒子上次连接的车辆的vin码
 *
 *  @param completion
 */
- (void)readLastVin:(void (^)(NSString *lastVIN, NSError *error))completion;
/**
 *  清除盒子是否插拔过标记
 *
 *  @param completion
 */
- (void)clearPullOutFlag:(void (^)(BOOL result))completion;
@end
