//
//  TorqueTrip.h
//  TorqueSDK
//
//  Created by zhangjipeng on 1/29/15.
//  Copyright (c) 2015 chexiang. All rights reserved.
//

#import "TorqueEquipment.h"
#import "TorqueTripInfo.h"
#import "HistoryTripInfo.h"
#import "TorqueTripSummary.h"
#import "TorqueTripMonthSummary.h"

@interface TorqueTrip : TorqueEquipment

/**
 *  查询盒子里有多少条历史行程需要同步（即：需要从盒子里读取）
 *
 *  @param completion 回调
 */
- (void)getHowManyHistoryTripsNeedSync:(void (^)(NSUInteger count))completion;

/**
 *  获取行程摘要信息
 *
 *  @param userIds    用户ID
 *  @param vinCode    车辆vin码
 *  @param from       查询起始日期
 *  @param to         查询结束时期
 *  @param completion 查询结果回调block，succeed:YES[成功]/NO[失败] result： -1 失败, 0 成功，1 userId或vinCode不能为空
 */
- (void)getTripSummary:(NSString *)userId vinCode:(NSString *)vinCode from:(NSDate *)from to:(NSDate *)to completion:(void (^)(TorqueTripSummary *tripSummary, TorqueResult *result))completion;


/**
 *  获取行程摘要信息
 *
 *  @param months     月份列表
 *  @param userId     用户ID
 *  @param vinCode    车辆vin码
 *  @param completion 查询结果回调block，succeed:YES[成功]/NO[失败] result： -1 失败, 0 成功，1 userId或vinCode不能为空
 */
- (void)getTripSummaryByMonths:(NSArray *)months userId:(NSString *)userId vinCode:(NSString *)vinCode completion:(void (^)(NSArray *tripMonthsSummary, TorqueResult *result))completion;


/**
 *  获取行程数据列表
 *
 *  @param userId     用户ID
 *  @param vinCode    车辆vin码
 *  @param from       查询起始日期
 *  @param count      要获取的数据数量
 *  @param completion 查询结果回调block，succeed:YES[成功]/NO[失败] result： -1 失败, 0 成功，1 userId/vinCode/from/count不能为空
 */
- (void)getTripList:(NSString *)userId vinCode:(NSString *)vinCode from:(NSDate *)from count:(NSInteger)count completion:(void (^)(NSArray *tripInfoList, TorqueResult *result))completion;

@end
