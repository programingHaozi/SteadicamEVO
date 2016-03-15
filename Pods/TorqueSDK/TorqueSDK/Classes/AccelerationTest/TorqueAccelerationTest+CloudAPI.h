//
//  TorqueAccelerationTest+CloudAPI.h
//  TorqueSDK
//
//  Created by zhangjipeng on 6/10/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import "TorqueAccelerationTest.h"
#import "TorqueRestKit.h"
#import "SCPage.h"
#import "AccTestResult.h"
#import "AccTestStatisticInfo.h"
#import "AccTestRecordInfo.h"
#import "AccTestRecordDetail.h"
#import "TorqueResult.h"

@interface TorqueAccelerationTest (CloudAPI)


/**
 *  上传百公里测试结果到后台服务器
 *
 *  @param result     百公里测试结果
 *  @param completion 上传完成的回调
 */
- (void)uploadAccelerationTestResult:(AccTestResult *)result completion:(void(^)(NSUInteger recordId, TorqueResult *result))completion;

/**
 *  获取百公里测试本次统计信息
 *
 *  @param completion 请求完成的回调
 */
- (void)getAccelerationTestCurrStatisticInfo:(NSUInteger)recordId completion:(void(^)(AccTestStatisticInfo *statisticInfo,TorqueResult *result))completion;

/**
 *  获取百公里测试统计信息
 *
 *  @param completion 请求完成的回调
 */
- (void)getAccelerationTestStatisticInfo:(NSUInteger)carId completion:(void(^)(AccTestStatisticInfo *statisticInfo,TorqueResult *result))completion;

/**
 *  获取百公里加速测试历史
 *
 *  @param page       请求是指定的分页信息
 *  @param completion 请求完成的回调
 */
- (void)getAccelerationTestHistoryRecords:(SCPage *)page WithCar:(NSUInteger)carId completion:(void(^)(NSArray *records, SCPage *page, NSUInteger totalRecords, TorqueResult *result))completion;

/**
 *  获取百公里测试历史记录详情
 *
 *  @param recordId   历史记录Id
 *  @param completion 请求完成的回调
 */
- (void)getAccelerationTestHistoryRecordDetail:(NSUInteger)recordId completion:(void(^)(AccTestRecordDetail *recordDetail,TorqueResult *result))completion;

/**
 *  获取百公里测试PK信息
 *
 *  @param recordId   历史记录Id
 *  @param completion 请求完成的回调
 */
- (void)getAccelerationTestPKInfo:(NSUInteger)recordId completion:(void(^)(AccTestRecordDetail *myRecord,AccTestRecordDetail *otherRecord, TorqueResult *result))completion;

@end
