//
//  OBDDevice+WorkStatus.h
//  TorqueSDK
//
//  Created by zhangjipeng on 2/9/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import "OBDDevice.h"
#import "WorkStatus.h"
#import "CurrentStatistics.h"

@interface OBDDevice (WorkStatus)

/**
 *  实时数据流是否打开
 */
@property (nonatomic) BOOL realtimeDataStreamOn;

/**
 *  发动机点火时间
 */
@property (nonatomic, strong) NSDate *dateEngineStart;

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
 *  实时数据流开关, 仅供debug使用
 *
 *  @param onOff      传入YES打开实时数据流，出入NO关闭实时数据流
 *  @param completion 结果回调，YES 操作成功，NO 操作失败
 */
- (void)realTimeDataStreamSwitch:(BOOL)onOff;
@end
