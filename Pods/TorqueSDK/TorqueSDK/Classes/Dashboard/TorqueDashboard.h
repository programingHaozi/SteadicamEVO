//
//  TorqueDashboard.h
//  TorqueSDK
//
//  Created by zhangjipeng on 1/29/15.
//  Copyright (c) 2015 chexiang. All rights reserved.
//

#import "TorqueEquipment.h"
#import "WorkStatus.h"
#import "CurrentStatistics.h"

@interface TorqueDashboard : TorqueEquipment

/**
 *  订阅实时工况数据
 *
 *  @param completion
 */
- (void)subscribeRealTimeWorkStatus:(void (^)(WorkStatus *workStatus, NSError *error))completion;

/**
 *  退订实时工况数据
 */
- (void)unsubscribeRealTimeWorkStatus:(void (^)(NSError *error))completion;

#if USE_EST527
/**
 *  获取实时统计数据
 *
 *  @param completion
 */
- (void)subscribeRealTimeStatistics:(void (^)(CurrentStatistics *, NSError *))completion;

/**
 *  关闭实时统计数据
 */
- (void)unsubscribeRealTimeStatistics:(void (^)(NSError *error))completion;
#endif

/**
 *  实时数据流开关
 *
 *  @param onOff      传入YES打开实时数据流，出入NO关闭实时数据流
 */
- (void)realTimeDataStreamSwitch:(BOOL)onOff;
@end
