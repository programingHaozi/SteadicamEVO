//
//  OBDDevice+PIDMode.h
//  TorqueSDK
//
//  Created by zhangjipeng on 2/9/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import "OBDDevice.h"
#import "PidCommand.h"

@interface OBDDevice (PIDMode)

/**
 *  进入PID Mode
 *
 *  @param completion 回调，成功error为nil，失败error非nil
 */
- (void)enterPIDMode:(void (^)(NSError *error))completion;

/**
 *  退出PID Mode
 *
 *  @param completion 回调，成功error为nil，失败error非nil
 */
- (void)exitPIDMode:(void (^)(NSError *error))completion;

/**
 *  发送PID指令
 *
 *  @param command    包含PID指令的对象
 *  @param completion 完成回调
 */
- (void)queryPIDValue:(PidCommand *)command completion:(void (^)(PidModel *pidModelWithCommand, NSError *error))completion;
/**
 *  获取故障码
 *
 *  @return 返回故障码，用‘|’分隔
 */
- (NSString *)getTroubleCodes;

/**
 *  清除当前车辆故障码
 *
 *  @return YES- 成功 / NO- 失败
 */
- (BOOL)cleanTroubleCodes;

@end
