//
//  TorqueAccelerationTest+CloudAPI.m
//  TorqueSDK
//
//  Created by zhangjipeng on 6/10/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import "TorqueAccelerationTest+CloudAPI.h"
#import "TorqueGlobal.h"

@interface AccTestHistoryInfo : NSObject

@property (nonatomic) BOOL isPage;
@property (nonatomic) NSInteger pageSize;
@property (nonatomic) NSInteger pageNum;
@property (nonatomic) NSInteger totalPages;
@property (nonatomic) NSInteger totalRecords;

@property (nonatomic, strong) NSArray *records;

@end

@implementation AccTestHistoryInfo

@end

@interface AccTestRecordId : NSObject

@property (nonatomic) NSUInteger recordId;

@end

@implementation AccTestRecordId

@end

@interface AccTestPK : NSObject

@property (nonatomic) AccTestRecordDetail *mine;
@property (nonatomic) AccTestRecordDetail *other;

@end

@implementation AccTestPK

@end


@implementation TorqueAccelerationTest (CloudAPI)

- (void)createDescriptors {
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    // post 测试结果
    // request mapping
    RKObjectMapping *testResultMapping = [RKObjectMapping requestMapping];
    [testResultMapping addAttributeMappingsFromDictionary:@{@"userId" : @"user_id",
                                                            @"deviceId" : @"device_id",
                                                            @"carId" : @"car_id",
                                                            @"useTime" : @"use_time",
                                                            @"result" : @"result",
                                                            @"itemsString" : @"detail"}];
    
    /*
    RKObjectMapping *testItemMapping = [RKObjectMapping requestMapping];//[RKObjectMapping mappingForClass:[AccelerationTestItem class]];
    [testItemMapping addAttributeMappingsFromDictionary:@{@"duration" : @"time",
                                                          @"carSpeed" : @"speed",
                                                          @"rotationSpeed" : @"engine_speed"}];
    
    RKRelationshipMapping *testItemsRelationshipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"items" toKeyPath:@"detail" withMapping:testItemMapping];
    [testResultMapping addPropertyMapping:testItemsRelationshipMapping];
    */
    
    [self requestDescriptorWithMapping:testResultMapping
                           objectClass:[AccTestResult class]
                                method:RKRequestMethodPOST
                                  path:kUploadAccTestResult
                           rootKeyPath:nil];
    
    // response mapping
    RKObjectMapping *recordIdMapping = [RKObjectMapping mappingForClass:[AccTestRecordId class]];
    [recordIdMapping addAttributeMappingsFromDictionary:@{@"acc_id" : @"recordId"}];
    
    [self responseDescriptorWithMapping:recordIdMapping
                                 method:RKRequestMethodPOST
                                   path:kUploadAccTestResult
                            pathPattern:nil
                                keyPath:@"result"
                            statusCodes:statusCodes];
    
    // get 历史测试记录
    RKObjectMapping *historyInfoMapping = [RKObjectMapping mappingForClass:[AccTestHistoryInfo class]];
    [historyInfoMapping addAttributeMappingsFromDictionary:@{@"is_page" : @"isPage",
                                                             @"page_size" : @"pageSize",
                                                             @"page_num" : @"pageNum",
                                                             @"total_page" : @"totalPages",
                                                             @"total_row" : @"totalRecords"}];
    
    RKObjectMapping *historyRecordMapping = [RKObjectMapping mappingForClass:[AccTestRecordInfo class]];
    [historyRecordMapping addAttributeMappingsFromDictionary:@{@"test_time" : @"testTime",
                                                               @"use_time" : @"useTime",
                                                               @"result" : @"success",
                                                               @"id" : @"recordId"}];
    
    RKRelationshipMapping *historyRecordsRelationshipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"history" toKeyPath:@"records" withMapping:historyRecordMapping];
    [historyInfoMapping addPropertyMapping:historyRecordsRelationshipMapping];
    
    [self responseDescriptorWithMapping:historyInfoMapping
                                 method:RKRequestMethodGET
                                   path:kGetAccTestHistoryRecords
                            pathPattern:nil
                                keyPath:@"result"
                            statusCodes:statusCodes];
    
    // get 测试记录详情
    RKObjectMapping *recordDetailMapping = [RKObjectMapping mappingForClass:[AccTestRecordDetail class]];
    [recordDetailMapping addAttributeMappingsFromDictionary:@{@"test_time" : @"testTime",
                                                              @"use_time" : @"useTime",
                                                              @"result" : @"success",
                                                              @"id" : @"recordId"}];
    
    RKObjectMapping *recordItmeMapping = [RKObjectMapping mappingForClass:[AccelerationTestItem class]];
    [recordItmeMapping addAttributeMappingsFromDictionary:@{@"time" : @"duration",
                                                            @"speed" : @"carSpeed",
                                                            @"engine_speed" : @"rotationSpeed"}];
    
    RKRelationshipMapping *recordItmesRelationshipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"details" toKeyPath:@"items" withMapping:recordItmeMapping];
    [recordDetailMapping addPropertyMapping:recordItmesRelationshipMapping];
    
    [self responseDescriptorWithMapping:recordDetailMapping
                                 method:RKRequestMethodGET
                                   path:kGetAccTestRecordDetail
                            pathPattern:nil
                                keyPath:@"result"
                            statusCodes:statusCodes];
    
    // get PK info
    RKObjectMapping *pkInfoMapping = [RKObjectMapping mappingForClass:[AccTestPK class]];
    RKRelationshipMapping *mineRelationshipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"mine" toKeyPath:@"mine" withMapping:recordDetailMapping];
    [pkInfoMapping addPropertyMapping:mineRelationshipMapping];
    RKRelationshipMapping *otherRelationshipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"other" toKeyPath:@"other" withMapping:recordDetailMapping];
    [pkInfoMapping addPropertyMapping:otherRelationshipMapping];
    
    [self responseDescriptorWithMapping:pkInfoMapping
                                 method:RKRequestMethodGET
                                   path:kGetAccTestPKInfo
                            pathPattern:nil
                                keyPath:@"result"
                            statusCodes:statusCodes];
    
    
    // get 百公里测试统计信息
    RKObjectMapping *statisticInfoMapping = [RKObjectMapping mappingForClass:[AccTestStatisticInfo class]];
    [statisticInfoMapping addAttributeMappingsFromDictionary:@{@"cur_time" : @"curTime",
                                                              @"best_time" : @"bestTime",
                                                              @"official_time" : @"officialTime",
                                                              @"all_best_time" : @"allTime"}];
    
    [self responseDescriptorWithMapping:statisticInfoMapping
                                 method:RKRequestMethodGET
                                   path:kGetAccTestStatisticInfo
                            pathPattern:nil
                                keyPath:@"result"
                            statusCodes:statusCodes];
    
    
}

/**
 *  上传百公里测试结果到后台服务器
 *
 *  @param result     百公里测试结果
 *  @param completion 上传完成的回调
 */
- (void)uploadAccelerationTestResult:(AccTestResult *)result completion:(void(^)(NSUInteger recordId, TorqueResult *result))completion {
    TorqueResult *torqueResult = [[TorqueResult alloc] init];
    [self postObject:result
                path:kUploadAccTestResult
          parameters:nil
 needResponseMapping:YES
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 TorqueError *error = [[mappingResult dictionary] objectForKey:@"status"];
                 torqueResult.message = error.errorMessage;
                 
                 if (error.errorCode == 0) {
                     AccTestRecordId *recordIdObj = [[mappingResult dictionary] objectForKey:@"result"];
                     if (completion) {
                         torqueResult.succeed = YES;
                         torqueResult.result = 0;
                         completion(recordIdObj.recordId, torqueResult);
                     }
                 } else {
                     if (completion) {
                         torqueResult.succeed = NO;
                         torqueResult.result = TorqueSDK_NerWorkOther;//-1;
                         completion(0, torqueResult);
                     }
                 }
             } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 torqueResult.message = error.localizedDescription;
                 if (completion) {
                     torqueResult.succeed = NO;
                     torqueResult.result = TorqueSDK_NetWorkFailed;//-1;
                     completion(0, torqueResult);
                 }
             }];
}

/**
 *  获取百公里测试本次统计信息
 *
 *  @param completion 请求完成的回调
 */
- (void)getAccelerationTestCurrStatisticInfo:(NSUInteger)recordId completion:(void(^)(AccTestStatisticInfo *statisticInfo,TorqueResult *result))completion {
    TorqueResult *torqueResult = [[TorqueResult alloc] init];
    [self getObjectsAtPath:kGetAccTestStatisticInfo
                parameters:kGetAccTestCurrStatisticInfoParams(recordId)
                   success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                       TorqueError *error = [[mappingResult dictionary] objectForKey:@"status"];
                       torqueResult.message = error.errorMessage;
                       
                       if (error.errorCode == 0) {
                           AccTestStatisticInfo *statisticInfo = [[mappingResult dictionary] objectForKey:@"result"];
                           if (completion) {
                               torqueResult.succeed = YES;
                               torqueResult.result = 0;
                               completion(statisticInfo, torqueResult);
                           }
                       } else {
                           if (completion) {
                               torqueResult.succeed = NO;
                               torqueResult.result = TorqueSDK_NerWorkOther;//-1;
                               completion(nil, torqueResult);
                           }
                       }
                   }
                   failure:^(RKObjectRequestOperation *operation, NSError *error) {
                       torqueResult.message = error.localizedDescription;
                       if (completion) {
                           torqueResult.succeed = NO;
                           torqueResult.result = TorqueSDK_NetWorkFailed;//-1;
                           completion(nil, torqueResult);
                       }
                   }];
}

/**
 *  获取百公里测试统计信息
 *
 *  @param completion 请求完成的回调
 */
- (void)getAccelerationTestStatisticInfo:(NSUInteger)carId completion:(void(^)(AccTestStatisticInfo *statisticInfo,TorqueResult *result))completion {
    TorqueResult *torqueResult = [[TorqueResult alloc] init];
    TorqueGlobal *torqueGlobal = [TorqueGlobal sharedInstance];
    [self getObjectsAtPath:kGetAccTestStatisticInfo
                parameters:kGetAccTestStatisticInfoParams(torqueGlobal.user.userId,carId)
                   success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                       TorqueError *error = [[mappingResult dictionary] objectForKey:@"status"];
                       torqueResult.message = error.errorMessage;
                       
                       if (error.errorCode == 0) {
                           AccTestStatisticInfo *statisticInfo = [[mappingResult dictionary] objectForKey:@"result"];
                           if (completion) {
                               torqueResult.succeed = YES;
                               torqueResult.result = 0;
                               completion(statisticInfo, torqueResult);
                           }
                       } else {
                           if (completion) {
                               torqueResult.succeed = NO;
                               torqueResult.result = TorqueSDK_NerWorkOther;//-1;
                               completion(nil, torqueResult);
                           }
                       }
                   }
                   failure:^(RKObjectRequestOperation *operation, NSError *error) {
                       torqueResult.message = error.localizedDescription;
                       if (completion) {
                           torqueResult.succeed = NO;
                           torqueResult.result = TorqueSDK_NetWorkFailed;//-1;
                           completion(nil, torqueResult);
                       }
                   }];
}

/**
 *  获取百公里加速测试历史
 *
 *  @param page       请求是指定的分页信息
 *  @param completion 请求完成的回调
 */
- (void)getAccelerationTestHistoryRecords:(SCPage *)page WithCar:(NSUInteger)carId completion:(void(^)(NSArray *records, SCPage *page, NSUInteger totalRecords, TorqueResult *result))completion {
    TorqueResult *torqueResult = [[TorqueResult alloc] init];
    TorqueGlobal *torqueGlobal = [TorqueGlobal sharedInstance];
    
    [self getObjectsAtPath:kGetAccTestHistoryRecords
                parameters:kGetAccTestHistoryRecordsParams(torqueGlobal.user.userId, torqueGlobal.deviceInfo.deviceId, @(carId), page.isPage, page.pageSize, page.currentIndex)
                   success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                       TorqueError *error = [[mappingResult dictionary] objectForKey:@"status"];
                       torqueResult.message = error.errorMessage;
                       
                       if (error.errorCode == 0) {
                           AccTestHistoryInfo *historyInfo = [[mappingResult dictionary] objectForKey:@"result"];
                           if (completion) {
                               torqueResult.succeed = YES;
                               torqueResult.result = 0;
                               completion(historyInfo.records, newPage(historyInfo.isPage, historyInfo.pageSize, historyInfo.pageNum, historyInfo.totalPages), historyInfo.totalRecords,torqueResult);
                           }
                       } else {
                           if (completion) {
                               torqueResult.succeed = NO;
                               torqueResult.result = TorqueSDK_NerWorkOther;//-1;
                               completion(nil, nil, 0, torqueResult);
                           }
                       }
                   }
                   failure:^(RKObjectRequestOperation *operation, NSError *error) {
                       torqueResult.message = error.localizedDescription;
                       if (completion) {
                           torqueResult.succeed = NO;
                           torqueResult.result = TorqueSDK_NetWorkFailed;//-1;
                           completion(nil, nil, 0, torqueResult);
                       }
                   }];
}

/**
 *  获取百公里测试历史记录详情
 *
 *  @param recordId   历史记录Id
 *  @param completion 请求完成的回调
 */
- (void)getAccelerationTestHistoryRecordDetail:(NSUInteger)recordId completion:(void(^)(AccTestRecordDetail *recordDetail,TorqueResult *result))completion {
    TorqueResult *torqueResult = [[TorqueResult alloc] init];
    [self getObjectsAtPath:kGetAccTestRecordDetail
                parameters:kGetAccTestRecordDetailParams(recordId)
                   success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                       TorqueError *error = [[mappingResult dictionary] objectForKey:@"status"];
                       torqueResult.message = error.errorMessage;
                       
                       if (error.errorCode == 0) {
                           AccTestRecordDetail *recordDetail = [[mappingResult dictionary] objectForKey:@"result"];
                           if (completion) {
                               torqueResult.succeed = YES;
                               torqueResult.result = 0;
                               completion(recordDetail, torqueResult);
                           }
                       } else {
                           if (completion) {
                               torqueResult.succeed = NO;
                               torqueResult.result = TorqueSDK_NerWorkOther;//-1;
                               completion(nil, torqueResult);
                           }
                       }
                   }
                   failure:^(RKObjectRequestOperation *operation, NSError *error) {
                       torqueResult.message = error.localizedDescription;
                       if (completion) {
                           torqueResult.succeed = NO;
                           torqueResult.result = TorqueSDK_NetWorkFailed;//-1;
                           completion(nil, torqueResult);
                       }
                   }];
}

/**
 *  获取百公里测试PK信息
 *
 *  @param recordId   历史记录Id
 *  @param completion 请求完成的回调
 */
- (void)getAccelerationTestPKInfo:(NSUInteger)recordId completion:(void(^)(AccTestRecordDetail *myRecord,AccTestRecordDetail *otherRecord, TorqueResult *result))completion {
    TorqueResult *torqueResult = [[TorqueResult alloc] init];
    [self getObjectsAtPath:kGetAccTestPKInfo
                parameters:kGetAccTestPKInfoParams(recordId)
                   success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                       TorqueError *error = [[mappingResult dictionary] objectForKey:@"status"];
                       torqueResult.message = error.errorMessage;
                       
                       if (error.errorCode == 0) {
                           AccTestPK *pkInfo = [[mappingResult dictionary] objectForKey:@"result"];
                           AccTestRecordDetail *myRecord = pkInfo.mine;
                           AccTestRecordDetail *otherRecord = pkInfo.other;
                           if (completion) {
                               torqueResult.succeed = YES;
                               torqueResult.result = 0;
                               completion(myRecord, otherRecord,torqueResult);
                           }
                       } else {
                           if (completion) {
                               torqueResult.succeed = NO;
                               torqueResult.result = TorqueSDK_NerWorkOther;//-1;
                               completion(nil, nil, torqueResult);
                           }
                       }
                   }
                   failure:^(RKObjectRequestOperation *operation, NSError *error) {
                       torqueResult.message = error.localizedDescription;
                       if (completion) {
                           torqueResult.succeed = NO;
                           torqueResult.result = TorqueSDK_NetWorkFailed;//-1;
                           completion(nil, nil, torqueResult);
                       }
                   }];
}

@end
