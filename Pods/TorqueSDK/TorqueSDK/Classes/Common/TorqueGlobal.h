//
//  TorqueGlobal.h
//  TorqueSDK
//
//  Created by sunxiaofei on 15/3/9.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TorqueSDK.h"
#import "TorqueUtility.h"

@interface TorqueGlobal : NSObject
/**
 *  appId
 */
@property (nonatomic, strong) NSString *appId;


/**
 *  server Url
 */
@property (nonatomic, copy) NSString *serverUrl;


/**
 *  全局用户信息
 */
@property (nonatomic, strong) UserInfo *user;
/**
 *  全局设备信息
 */
@property (nonatomic, strong) DeviceInfo *deviceInfo;
/**
 *  全局车信息
 */
@property (nonatomic, strong) CarInfo *carInfo;

/**
 *  全局所有车辆列表
 */
@property (nonatomic, strong) NSArray *allCarArray;

/**
 *  是否允许3G上传
 */
@property (nonatomic, assign) BOOL is3GAllow;

/**
 *  当前网络状态
 */
@property (nonatomic, assign) TorqueNetworkStatus networkStatus;

/**
 *  上次同步时间
 */
@property (nonatomic, strong) NSDate *lastSyncTime;
/**
 *  上次上传时间
 */
@property (nonatomic, strong) NSDate *lastUpdateTime;

#pragma mark - methods

+ (instancetype)sharedInstance;

/**
 *  检测网络连接状态
 */
- (void)motionNetwork;

/**
 *  从本地定义的ActionLog类型转换为服务端定义的类型
 *
 *  @param actionType 本地定义的类型
 *
 *  @return 服务端定义的类型值
 */
+ (NSInteger)switchActionTypeFromLocal:(ActionLogType)actionType;

@end
