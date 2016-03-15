//
//  OBDDevice+Trip.h
//  TorqueSDK
//
//  Created by zhangjipeng on 2/9/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import "OBDDevice.h"
#import "TorqueTripInfo.h"
#import "HistoryTripInfo.h"

@interface OBDDevice (Trip)

@property (nonatomic, strong)NSMutableArray *timeArray;

/**
 *  获取最后一次行程统计信息
 *
 *  @param completion
 */
- (void)fetchLastTripRecord:(void (^)(TorqueTripInfo *tripRecord, NSError *error))completion;

/**
 *  获取历史行程统计信息
 *
 *  @param completion
 */
- (void)fetchHistoryTripInfo:(void (^)(HistoryTripInfo *historyTripInfo, NSError *error))completion;

/**
 *  获取指定记录行程信息
 *
 *  @param range      要读取的记录的范围
 *  @param completion
 */
- (void)fetchHistoryTripRecordWithRange:(HistoryTripInfo *)historyTripInfo next:(void (^)(TorqueTripInfo *tripRecord, NSError *error))next completed:(void (^)(NSError *error))completed;

/**
 *  获取指定记录行程信息(批量)
 *
 *  @param range      要读取的记录的范围
 *  @param completion
 */
- (void)batchHistoryTripRecordWithRange:(HistoryTripInfo *)historyTripInfo next:(void (^)(TorqueTripInfo *tripRecord, NSError *error))next completed:(void (^)(NSError *error))completed;

/**
 *  删除指定行程统计信息
 *
 *  @param range      要删除的记录的范围
 *  @param completion
 */
- (void)deleteHistoryTripRecordWithRange:(NSRange)range completion:(void (^)(NSError *error))completion;

/**
 *  删除指定行程统计信息(批量)
 *
 *  @param range      要删除的记录的范围
 *  @param completion
 */
- (void)deleteBatchHistoryTripRecordWithRange:(HistoryTripInfo *)tripInfo completion:(void (^)(NSError *error))completion;

/**
 *  写入行程
 *
 *  @param count 写入的行程总数
 *  @param completion
 */
- (void)writeHistoryTripRecordWithCount:(NSUInteger)tripCount completion:(void (^)(NSError *error))completion;


@end
