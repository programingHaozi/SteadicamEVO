//
//  Torque.h
//  OBD-DEMO
//
//  Created by zhangjipeng on 1/23/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TorqueTypeDefine.h"
#import "DeviceConfidential.h"
#import "DeviceInfo.h"
#import "CarInfo.h"
#import "UserInfo.h"
#import "TorqueResult.h"
#import "TorqueFeature.h"
#import <CocoaLumberjack.h>

// 注意！！！以下参数在开发时可自由调整，提交时请还原
//static const DDLogLevel ddLogLevel = DDLogLevelDebug;
//static const DDLogLevel ddLogLevel = DDLogLevelWarning;
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;

@interface Torque : NSObject

+ (instancetype)sharedInstance;

- (void)startTimeout:(float)timeout completion:(void(^)(TorqueResult *result))completion;

@end
/**
 *  用于超时判断的对象
 */
@interface TimeOutObject : NSObject

@property (nonatomic, copy) void(^completionBlock)(NSError *error, BOOL timeOut);

/**
 *  启动超时检测
 *
 *  @param timeout    超时时间
 *  @param target     要检测的对象
 *  @param content    检测池
 *  @param completion 超时回调
 */
- (void)startTimeout:(float)timeout
              target:(NSNumber *)target
             content:(NSArray *)content
          completion:(void(^)(NSError *error, BOOL timeOut))completion;

/**
 *  启动超时检测
 *
 *  @param timeout    超时时间
 *  @param target     要检测的对象
 *  @param content    检测池
 *  @param completion 超时回调
 */
- (void)startTimeout:(float)timeout
    targetWithString:(NSString *)target
             content:(NSArray *)content
          completion:(void(^)(NSError *error, BOOL timeOut))completion;

/**
 *  清除注册的超时回调
 */
- (void)clean;

@end