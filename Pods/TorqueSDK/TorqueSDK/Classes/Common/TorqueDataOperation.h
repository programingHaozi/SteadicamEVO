//
//  TorqueDataOperation.h
//  TorqueSDK
//
//  Created by huxianchen on 15/3/9.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CarInfo.h"
#import "UserInfo.h"
#import "DeviceInfo.h"
#import "TorqueTrip.h"

/**
 *  CoreData 数据操作
 */
@interface TorqueDataOperation : NSObject

+ (instancetype)sharedInstance;

/**
 *  重新设置个人名下的车辆信息
 *
 *  @param array 车辆信息数组
 */
- (void)resetCarInfo:(NSArray *)array;


- (void)resetDevicesInfo:(NSArray *)array;


/**
 *  设置当前设备
 *
 *  @param deviceInfo 当前设备
 */
- (void)setCurrentDevice:(DeviceInfo *)deviceInfo;


/**
 *  设置当前车辆信息
 *
 *  @param userInfo 当前车辆信息
 */
- (void)setCurrentUser:(UserInfo *)userInfo;


/**
 *  设置当前车辆
 *
 *  @param carInfo 当前车辆信息
 */
- (void)setCurrentCar:(CarInfo *)carInfo;



/**
 *  获取当前车辆的信息
 *
 *  @return 车辆信息
 */
-(CarInfo *)getCurrentCar;

/**
 *  获取所有车辆信息列表
 *
 *  @return 所有车辆信息列表
 */
- (NSArray *)getAllCarArray;

- (DeviceInfo *)getCurrentDeviceInfo;

- (NSArray *)getTorqueTripInfo;
/**
 *  判断指定的行程是否存在
 *
 *  @param trip 要查询的行程对象
 *
 *  @return YES-存在 NO－不存在
 */
- (BOOL)tripInfoExist:(TorqueTripInfo *)trip;

/**
 *  是否允许3G上传
 */
- (void)setIs3GAllow:(BOOL)is3gAllow;

/**
 *  设置上次同步时间
 */
- (void)setLastSyncTime:(NSDate *)lastSyncTime;
/**
 *  设置上次上传时间
 */
- (void)setLastUpdateTime:(NSDate *)lastUpdateTime;

/**
 *  获取上次同步时间
 *
 *  @return 时间
 */
- (NSDate *)getLastSyncTime;

/**
 *  获取上次上传时间
 *
 *  @return 时间
 */
- (NSDate *)getLastUpdateTime;

/**
 *  设置校准里程日期
 */
- (void)setResetTotalDistanceDate:(NSDate *)resetTotalDistanceDate;

/**
 *  获取上次校准里程日期
 *
 *  @return 上次校准里程日期
 */
- (NSDate *)getLastResetTotalDistanceDate;

@end
