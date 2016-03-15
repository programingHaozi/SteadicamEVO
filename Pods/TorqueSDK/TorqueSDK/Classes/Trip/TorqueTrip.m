//
//  TorqueTrip.m
//  TorqueSDK
//
//  Created by zhangjipeng on 1/29/15.
//  Copyright (c) 2015 chexiang. All rights reserved.
//

#import "TorqueTrip.h"
#import "NSString+Date.h"
#import "OBDDevice+Trip.h"

#define kDateFormat @"yyyy-MM-dd HH:mm:ss"


@implementation TorqueTrip

+ (instancetype)sharedInstance {
    static TorqueTrip *trip = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        trip = [TorqueTrip new];
    });
    return trip;
}

/**
 *  查询盒子里有多少条历史行程需要同步（即：需要从盒子里读取）
 *
 *  @param completion 回调
 */
- (void)getHowManyHistoryTripsNeedSync:(void (^)(NSUInteger count))completion {
    [self.obdDevice fetchHistoryTripInfo:^(HistoryTripInfo *historyTripInfo, NSError *error) {
        if (historyTripInfo && completion) {
            completion(historyTripInfo.count);
        } else if (!historyTripInfo && completion) {
            completion(0);
        }
    }];
}

/**
 *  获取行程摘要信息
 *
 *  @param userIds    用户ID
 *  @param vinCode    车辆vin码
 *  @param from       查询起始日期
 *  @param to         查询结束时期
 *  @param completion 查询结果回调block
 */
- (void)getTripSummary:(NSString *)userId vinCode:(NSString *)vinCode from:(NSDate *)from to:(NSDate *)to completion:(void (^)(TorqueTripSummary *tripSummary, TorqueResult *result))completion {
    TorqueResult *result = [TorqueResult new];
    if (!userId ||
        !vinCode) {
        if (!userId) {
            result.message = kMessage_userIdNotNull;
        }
        if (!vinCode) {
            result.message = kMessage_vinCodeNotNull;
        }
        if (completion) {
            completion(nil,result);
        }
        return;
    }
    NSArray *ids = @[userId];
    [self getTripSummaryByIds:ids vinCode:vinCode from:from to:to completion:completion];
}

/**
 *  获取行程摘要信息
 *
 *  @param userIds    用户ID列表，用’,‘分隔多个用户ID
 *  @param vinCode    车辆vin码
 *  @param from       查询起始日期
 *  @param to         查询结束时期
 *  @param completion 查询结果回调block，succeed:YES[成功]/NO[失败] result： -1 失败, 0 成功，1 userId或vinCode不能为空
 */
- (void)getTripSummaryByIds:(NSArray *)userIds vinCode:(NSString *)vinCode from:(NSDate *)from to:(NSDate *)to completion:(void (^)(TorqueTripSummary *tripSummary, TorqueResult *result))completion {
    
    NSString *_userIds = [userIds componentsJoinedByString:@","];
    NSString *_from = from ? [NSString stringFromDate:from ForDateFormatter:kDateFormat] : @"";
    NSString *_to = from ? [NSString stringFromDate:to ForDateFormatter:kDateFormat] : @"";
    TorqueResult *result = [[TorqueResult alloc] init];
    [self getObjectsAtPath:kGetTripSummary
                parameters:kGetTripSummaryParams(_userIds, vinCode, _from, _to)
                   success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                       TorqueError *error = [[mappingResult dictionary] objectForKey:@"status"];
                       result.message = error.errorMessage;
                       
                       TorqueTripSummary *info = nil;
                       if (error.errorCode == 0) {
                           if (completion) {
                               info = [[mappingResult dictionary] objectForKey:@"result"];
                               result.succeed = YES;
                           }
                       } else if (error.errorCode == 401) {
                           result.result = 1;
                       }
                       
                       if (completion) {
                           completion(info, result);
                       }
                   } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                       result.result = TorqueSDK_NetWorkFailed;//-1;
                       result.message = error.localizedDescription;
                       if (completion) {
                           completion(nil, result);
                       }
                   }];
}

/**
 *  获取行程摘要信息
 *
 *  @param months     月份列表
 *  @param userId     用户ID
 *  @param vinCode    车辆vin码
 *  @param completion 查询结果回调block，succeed:YES[成功]/NO[失败] result： -1 失败, 0 成功，1 userId或vinCode不能为空
 */
- (void)getTripSummaryByMonths:(NSArray *)months userId:(NSString *)userId vinCode:(NSString *)vinCode completion:(void (^)(NSArray *tripMonthsSummary, TorqueResult *result))completion {
    NSString *_months = [months componentsJoinedByString:@","];
    TorqueResult *result = [[TorqueResult alloc]init];
    
    if (!userId ||
        !vinCode ||
        !months) {
        if (!userId) {
            result.message = kMessage_userIdNotNull;
        }
        if (!vinCode) {
            result.message = kMessage_vinCodeNotNull;
        }
        if (!months) {
            result.message = kMessage_fromNotNull;
        }
        if (completion) {
            completion(nil,result);
        }
        return;
    }
    [self getObjectsAtPath:kGetTripSummaryByMonths parameters:kGetTripSummaryByMonthParams(_months, userId, vinCode) success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
       
        TorqueError *error = [[mappingResult dictionary] objectForKey:@"status"];
        result.message = error.errorMessage;
        NSArray *info = nil;
        if (error.errorCode == 0) {
            if (completion) {
                info = [[mappingResult dictionary] objectForKey:@"result"];
                result.succeed = YES;
            }
        }else if (error.errorCode == 400) {
            result.result = 1; 
        }
        if (completion) {
            completion(info, result);
        }
        
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
        result.message = error.localizedDescription;
        result.error = error;
        result.result = TorqueSDK_NetWorkFailed;
        if (completion) {
            completion(nil, result);
        }
    }];
    
}

/**
 *  获取行程数据列表
 *
 *  @param userId     用户ID
 *  @param vinCode    车辆vin码
 *  @param from       查询起始日期
 *  @param count      要获取的数据数量
 *  @param completion 查询结果回调block，succeed:YES[成功]/NO[失败] result： -1 失败, 0 成功，1 userId/vinCode/from/count不能为空
 */
- (void)getTripList:(NSString *)userId vinCode:(NSString *)vinCode from:(NSDate *)from count:(NSInteger)count completion:(void (^)(NSArray *tripInfoList, TorqueResult *result))completion {
    TorqueResult *result = [[TorqueResult alloc] init];
    if (!userId ||
        !vinCode ||
        !from) {
        if (!userId) {
            result.message = kMessage_userIdNotNull;
        }
        if (!vinCode) {
            result.message = kMessage_vinCodeNotNull;
        }
        if (!from) {
            result.message = kMessage_fromNotNull;
        }
        if (completion) {
            completion(nil,result);
        }
        return;
    }
    
    NSString *_from = [NSString stringFromDate:from ForDateFormatter:kDateFormat];
    [self getObjectsAtPath:kGetTripList
                parameters:kGetTripListParams(userId, vinCode, _from, [NSNumber numberWithInteger:count])
                   success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                       TorqueError *error = [[mappingResult dictionary] objectForKey:@"status"];
                       result.message = error.errorMessage;
                       NSArray *infoList = nil;
                       if (error.errorCode == 0) {
                           if (completion) {
                               infoList = [[mappingResult dictionary] objectForKey:@"result"];
                               result.succeed = YES;
                           }
                       }  else if (error.errorCode == 400) {
                           result.result = 1;
                       }
                       
                       if (completion) {
                           completion(infoList, result);
                       }
                   } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                       result.message = error.localizedDescription;
                       result.error = error;
                       if (completion) {
                           completion(nil, result);
                       }
                   }];
}

#pragma mark - Private Method

- (void)createDescriptors {
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    // 获取行程摘要信息
    RKObjectMapping *getTripSummaryMapping = [RKObjectMapping mappingForClass:[TorqueTripSummary class]];
    [getTripSummaryMapping addAttributeMappingsFromArray:@[@"firstStartTime", @"lastStartTime",@"totalMileage",@"runMileage",@"totaleTripTime",@"tripCount",@"maxSpeed",@"maxEngineSpeed",@"totalFuelCons",@"avgAverageFuelCons",@"avgAverageSpeed"]];
    
    [self responseDescriptorWithMapping:getTripSummaryMapping
                                 method:RKRequestMethodGET
                                   path:kGetTripSummary
                            pathPattern:nil
                                keyPath:@"result"
                            statusCodes:statusCodes];

    // 获取行程数据列表
    
    RKObjectMapping *getTripListMapping = [RKObjectMapping mappingForClass:[TorqueTripInfo class]];
    [getTripListMapping addAttributeMappingsFromDictionary:@{@"id":@"recordId",
                                                             /*@"car_id":@"mileage",
                                                             @"device_id":@"idlingDuration",
                                                             @"user_id":@"idlingDuration",*/
                                                             @"start_time" : @"startDate",
                                                             @"end_time" : @"endDate",
                                                             @"hot_time" : @"hotCarDuration",
                                                             @"idling_length" : @"idlingDuration",
                                                             @"trip_time" : @"travelDuration",
                                                             @"mileage" : @"mileage",
                                                             @"idling_fuel" : @"idlingFuel",
                                                             @"driving_fuel" : @"drivingFuel",
                                                             @"apex_engine_speed" : @"thisTimeMaxRotationSpeed",
                                                             @"apex_speed" : @"thisTimeMaxCarSpeed",
                                                             @"hurried_speedup" : @"thisTimeSuddenSeedUpCount",
                                                             @"hurried_brake" : @"thisTimeSuddenSpeedReduceCount",
                                                             @"hurried_change" : @"thisTimeSuddenTurnCornerCount"
                                                             }];
    
    [self responseDescriptorWithMapping:getTripListMapping
                                 method:RKRequestMethodGET
                                   path:kGetTripList
                            pathPattern:nil
                                keyPath:@"result"
                            statusCodes:statusCodes];
    
    //获取月份行程信息
    
    RKObjectMapping *getDaylyTripMapping = [RKObjectMapping mappingForClass:[TorqueTripInfo class]];
    [getDaylyTripMapping addAttributeMappingsFromDictionary:@{
                                                              @"day"                : @"startDate",
                                                              @"totalTripTime"      : @"travelDuration",
                                                              @"runMileage"         : @"mileage",
                                                              @"totalFuelCons"      : @"totalFuel",
                                                              @"maxEngineSpeed"     : @"thisTimeMaxRotationSpeed",
                                                              @"maxSpeed"           : @"thisTimeMaxCarSpeed",
                                                              @"avgAverageFuelCons" : @"averageFuel",
                                                              @"avgAverageSpeed"    : @"averageCarSpeed",
                                                              @"tripCount"          : @"startCount"
                                                              }];
    
    RKObjectMapping *getMonthTripSummaryMapping = [RKObjectMapping mappingForClass:[TorqueTripMonthSummary class]];
    [getMonthTripSummaryMapping addAttributeMappingsFromArray:@[@"month"]];
    [getMonthTripSummaryMapping setSourceToDestinationKeyTransformationBlock:^NSString *(RKObjectMapping *mapping, NSString *sourceKey) {
        if ([sourceKey isEqualToString:@"days"]) {
            return @"daysArray";
        } else if ([sourceKey isEqualToString:@"total"]) {
            return @"totalArray";
        } else {
            return sourceKey;
        }
    }];
    
    [getMonthTripSummaryMapping addRelationshipMappingWithSourceKeyPath:@"total" mapping:getTripSummaryMapping];
    [getMonthTripSummaryMapping addRelationshipMappingWithSourceKeyPath:@"days" mapping:getDaylyTripMapping];
    
    [self responseDescriptorWithMapping:getMonthTripSummaryMapping
                                 method:RKRequestMethodGET
                                   path:kGetTripSummaryByMonths
                            pathPattern:nil
                                keyPath:@"result"
                            statusCodes:statusCodes];
}

@end
