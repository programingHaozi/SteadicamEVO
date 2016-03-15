//
//  TorqueDataUpload.m
//  TorqueSDK
//
//  Created by huxianchen on 15/3/9.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import "TorqueDataUpload.h"
#import "DataUpload.h"
#import "TorqueGlobal.h"
#import "TorqueSDKCoreDataHelper.h"
#import "TorqueDataOperation.h"
#import "TorqueTripInfoModel+Convert.h"
#import "NSString+Base64.h"
#import "NSString+Date.h"
#import "SBJson4.h"
#import "TorqueDataOperation.h"

static TorqueDataUpload *instance = nil;

@interface TorqueDataUpload()


//是否正在上传
@property (nonatomic) BOOL isUploading;

@property (nonatomic) BOOL allow3G;

@end

@implementation TorqueDataUpload

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [TorqueDataUpload new];
        
        [instance obdDevice];
    });
    return instance;
}

- (NSDate *)getLastDataUpdateTime
{
    return [[TorqueDataOperation sharedInstance] getLastUpdateTime];
}

- (void)createDescriptors {
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{@"jsonStr" : @"jsonStr",
                                                         @"type" : @"type",
                                                         @"userId" : @"userId",
                                                         @"deviceId" : @"deviceId",
                                                         @"appId" : @"appId"}];
    [self requestDescriptorWithMapping:requestMapping
                           objectClass:[DataUpload class]
                                method:RKRequestMethodPOST
                                  path:kTorqueDeviceDataSyncPath
                           rootKeyPath:nil];
}

- (void)uploadDataGCDRepeat:(void(^)(TorqueResult *result))completion {
    if (self.isUploading) {
        return;
    }
    if ((self.allow3G && [TorqueGlobal sharedInstance].networkStatus == TorqueReachableViaWWAN) ||
        ([TorqueGlobal sharedInstance].networkStatus == TorqueReachableViaWiFi) ) {
        self.isUploading = YES;
        [self uploadData:^(CGFloat percentage) {
            
        } completion:^(TorqueResult *result) {
            self.isUploading = NO;
            
            if (completion) {
                completion(result);
            }
        }];
        
        dispatch_queue_t queue = dispatch_queue_create("startDataUploadThread", NULL);
        dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, kAutoUploadTimer * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(timer, ^{
            [self uploadDataGCDRepeat:completion];
        });
        dispatch_resume(timer);
    }
}

/**
 *  上传
 *  @param allow3G 是否允许3G情况下上传数据
 */
- (void)startDataUploadGCD:(BOOL)allow3G
                completion:(void(^)(TorqueResult *result))completion{
    self.allow3G = allow3G;
    [self uploadDataGCDRepeat:completion];
}

/**
 *  上传数据
 *
 *  @param dataSync             数据内容
 *  @param percentageCompletion 上传进度百分比
 *  @param completion           完成回调
 */
- (void)uploadData:(DataUpload *)dataSync
percentageCompletion:(void(^)(CGFloat percentage))percentageCompletion
 timeoutCompletion:(void(^)(void))timeoutCompletion
      completion:(void(^)(TorqueResult *result))completion {
    TorqueResult *result = [TorqueResult new];
    __block BOOL isTimeout = TRUE;
    
    [self postObject:dataSync
                path:kTorqueDeviceDataSyncPath
          parameters:nil
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if (isTimeout) {
                     isTimeout = FALSE;
                     TorqueError *error = [[mappingResult dictionary] objectForKey:@"status"];
                     
                     //上传成功
                     if (error.errorCode == 0) {
                         result.succeed = TRUE;
                         result.result = 1;
                         result.error = nil;

                         DDLogInfo(@"Success");
                         
                     } else {//接口成功,返回值失败
                         result.succeed = FALSE;
                         result.error= nil;
                         result.message=error.errorMessage;
                         result.result= error.errorCode;////具体待定义
                         
                         DDLogInfo(@"errorCode: %ld, errorMessage: %@",(long)error.errorCode, error.errorMessage);
                     }
                     if (completion) {
                         completion(result);
                     }
                 }
             } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 if (isTimeout) {
                     
                     isTimeout = FALSE;
                     if (completion) {
                         TorqueResult *result = [TorqueResult new];
                         result.succeed = FALSE;
                         result.result = -1;
                         result.error = error;
                         completion(result);
                     }
                     DDLogInfo(@"errorCode: %ld, errorMessage: %@",(long)error.code, error.userInfo);
                 }
             }];
    
    
    
    //60秒timeout
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       if (isTimeout) {
                           isTimeout = FALSE;
                           
                           if (completion) {
                               
                               TorqueResult *result = [TorqueResult new];
                               result.succeed = FALSE;
                               result.message = @"上传数据超时";
                               result.result = 0;
                               result.error = nil;
                               completion(result);
                               
                               completion(result);
                           }
                       }
                       
                   });
    
}

/**
 *  上传 action
 *
 *  @param completion
 */
- (void)uploadActionData:(DataUpload *)dataSync
  percentageCompletion:(void(^)(CGFloat percentage))percentageCompletion
            completion:(void(^)(TorqueResult *result))completion
{
    
    if (completion) {
        TorqueResult *result = [TorqueResult new];
        result.succeed = TRUE;
        result.message = @"行程 -- 上传成功";
        result.result = 0;
        
        completion(result);
    }
    
//    NSString * jsonStr = @"{\"action\":[{\"id\":1,\"device_id\":001,\"user_id\":1,\"name\":1,\"parameter\":\"parameter test\",\"time\":\"2015-02-05 17:38:13\"},{\"id\":2,\"device_id\":002,\"user_id\":1,\"name\":2,\"parameter\":\"parameter test2\",\"time\":\"2015-02-05 17:38:14\"}],\"date\":\"2015-02-05\"}";
//    
////    NSString *jsonStr = @"";
//    [dataSync setValue:jsonStr forKey:@"jsonStr"];
//    [self uploadData:dataSync percentageCompletion:percentageCompletion timeoutCompletion:nil completion:^(TorqueResult *result) {
//        //上传成功后,需置本地数据已上传
//        
//        
//        if (completion) {
//            completion(result);
//        }
//    }];
}


/**
 *  上传 行程
 *
 *  @param completion
 */
- (void)uploadTripsData:(DataUpload *)dataSync
 percentageCompletion:(void(^)(CGFloat percentage))percentageCompletion
           completion:(void(^)(TorqueResult *result))completion
{
    
    __block NSDate *lastDate=nil;

    NSArray *array = [[TorqueDataOperation sharedInstance] getTorqueTripInfo];
    
    if (array && array.count) {
        
        DDLogInfo(@"本次上传:%ld条", (unsigned long)array.count);
        
        NSMutableArray *tripsInfoArray = [NSMutableArray new];
        for (TorqueTripInfoModel *model in array) {
            
            [tripsInfoArray addObject:[model transferToDict]];
            
//            if ([model.startDate  laterDate:lastDate]) {
//                lastDate = model.startDate;
//            }
        }
        
        SBJson4Writer *jsonWriter = [[SBJson4Writer alloc] init];
        NSMutableDictionary *jsonDict = [NSMutableDictionary new];
        
        [jsonDict setValue:tripsInfoArray  forKey:@"trips"];
        lastDate = [NSString currentDate];//[NSDate date];
        [jsonDict setValue:[NSString stringFromDate:lastDate ForDateFormatter:kDateFormatShort ] forKey:@"date"];
        
        NSString *jsonStr = [jsonWriter stringWithObject:jsonDict];
        [dataSync setValue:jsonStr forKey:@"jsonStr"];
        /***行程数据结构***
         {"trips":[{"id":1,"car_id":1,"vin_code":"1234567890","device_id":001,"user_id":1,"app_id":001,"start_time":"2015-02-05 17:38:13","end_time":"2015-02-05 18:38:13","hot_time":30,"idling_length":1.23,"trip_time":3.63,"mileage":250.02,"idling_fuel":0.23,"driving_fuel":12.43,"apex_engine_speed":77,"apex_speed":35.36,"hurried_speedup":4,"hurried_brake":3,"hurried_change":9},{"id":2,"car_id":1,"vin_code":"1234567890","device_id":001,"user_id":1,"app_id":001,"start_time":"2015-02-05 17:38:13","end_time":"2015-02-05 18:38:13","hot_time":40,"idling_length":5.23,"trip_time":5.63,"mileage":260.02,"idling_fuel":3.23,"driving_fuel":16.43,"apex_engine_speed":76,"apex_speed":34.36,"hurried_speedup":3,"hurried_brake":5,"hurried_change":6}],"date":"2015-02-05"}
         */
        [self uploadData:dataSync percentageCompletion:percentageCompletion timeoutCompletion:nil completion:^(TorqueResult *result) {
            if (result.succeed ) {
                [[TorqueDataOperation sharedInstance] setLastUpdateTime:lastDate];
                //上传成功后,需置本地数据已上传
                for (TorqueTripInfoModel *tripInfo in array) {
                    [tripInfo setIsUploaded:YES];
                }
                
                [[TorqueSDKCoreDataHelper sharedInstance] saveContext];
            }

            if (completion) {
                completion(result);
            }
        }];
    }else{
        if (completion) {
            TorqueResult *result=[TorqueResult new];
            result.succeed = TRUE;
            result.result = -1;
            result.message = @"没有数据";
            completion(result);
        }
    }
}

/**
 *  上传 百公里加速测试
 *
 *  @param completion
 */
- (void)uploadSpeedUpData:(DataUpload *)dataSync
   percentageCompletion:(void(^)(CGFloat percentage))percentageCompletion
             completion:(void(^)(TorqueResult *result))completion
{
    
    if (completion) {
        TorqueResult *result = [TorqueResult new];
        result.succeed = TRUE;
        result.message = @"行程 -- 上传成功";
        result.result = 0;
        
        completion(result);
    }
    
    
//    
//    NSString * jsonStr = @"{\"speedup_log\":[{\"id\":1,\"car_id\":1,\"user_id\":1,\"device_id\":001,\"result_time\":60,\"test_time\":\"2015-02-05 17:38:13\",\"app_id\":\"1\"},{\"id\":1,\"car_id\":1,\"user_id\":1,\"device_id\":001,\"result_time\":30,\"test_time\":\"2015-02-05 17:38:13\",\"app_id\":\"1\"}],\"date\":\"2015-02-05\"}";
//    
////    NSString *jsonStr= @"";
//    
//    [dataSync setValue:jsonStr forKey:@"jsonStr"];
//    [self uploadData:dataSync percentageCompletion:percentageCompletion  timeoutCompletion:nil completion:^(TorqueResult *result) {
//        //上传成功后,需置本地数据已上传
//        
//        
//        
//        if (completion) {
//            completion(result);
//        }
//    }];
    
}

/**
 *  上传 检测报告
 *
 *  @param completion
 */
- (void)uploadExamReportsData:(DataUpload *)dataSync
       percentageCompletion:(void(^)(CGFloat percentage))percentageCompletion
                 completion:(void(^)(TorqueResult *result))completion
{
    if (completion) {
        TorqueResult *result = [TorqueResult new];
        result.succeed = TRUE;
        result.message = @"行程 -- 上传成功";
        result.result = 0;
        
        completion(result);
    }
    
//    
//    NSString * jsonStr = @"{\"exam_reports\":[{\"id\":1,\"car_id\":1,\"device_id\":001,\"app_id\":1,\"user_id\":1,\"create_time\":\"2015-02-05 17:38:13\",\"error_num\":3,\"score\":90,\"detail\":\"this is description\"},{\"id\":2,\"car_id\":3,\"device_id\":002,\"app_id\":2,\"user_id\":1,\"create_time\":\"2015-02-05 17:38:15\",\"error_num\":3,\"score\":80,\"detail\":\"this is description2\"}],\"date\":\"2015-02-05\"}";
//    
////    NSString *jsonStr=@"";
//    
//    [dataSync setValue:jsonStr forKey:@"jsonStr"];
//    [self uploadData:dataSync percentageCompletion:percentageCompletion  timeoutCompletion:nil completion:^(TorqueResult *result) {
//        //上传成功后,需置本地数据已上传
//        
//        
//        if (completion) {
//            completion(result);
//        }
//    }];
    
}

- (void)uploadData:(TorqueDataSyncType)type
          dataSync:(DataUpload *)dataSync
percentageCompletion:(void(^)(CGFloat percentage))percentageCompletion
        completion:(void(^)(TorqueResult *result))completion {
    switch (type) {
        case TorqueDataSyncTypeAction:
            [dataSync setValue:@"action" forKey:@"type"];
            [self uploadActionData:dataSync percentageCompletion:percentageCompletion completion:completion];
            break;
            
        case TorqueDataSyncTypeTrips:
            [dataSync setValue:@"trips" forKey:@"type"];
            [self uploadTripsData:dataSync percentageCompletion:percentageCompletion completion:completion];
            break;
            
        case TorqueDataSyncTypeSpeedUp:
            [dataSync setValue:@"speedup" forKey:@"type"];
            [self uploadSpeedUpData:dataSync percentageCompletion:percentageCompletion completion:completion];
            break;
            
        case TorqueDataSyncTypeExamReport:
            [dataSync setValue:@"exam_reports" forKey:@"type"];
            [self uploadExamReportsData:dataSync percentageCompletion:percentageCompletion completion:completion];
            break;
            
        default:
            if (completion) {
                TorqueResult *result = [TorqueResult new];
                result.message=@"未知同步类型";
                result.succeed = FALSE;
                completion(result);
            }
            break;
    }
}


- (void)uploadData:(NSInteger)index
   updateTypeArray:(NSArray *)updateTypeArray
        dataUpload:(DataUpload *)dataUpload
percentageCompletion:(void(^)(CGFloat percentage))percentageCompletion
        completion:(void(^)(TorqueResult *result))completion
{   
    if (index >= 0 && index < updateTypeArray.count) {
        
        //每一步占用的 percentage
        CGFloat perStep = 100. /updateTypeArray.count;
        
        
        TorqueDataSyncType type = [updateTypeArray[index] integerValue];
        
        [self uploadData:type dataSync:dataUpload percentageCompletion:^(CGFloat percentage) {
            
            if (percentageCompletion) {
                percentageCompletion(perStep * index + percentage /perStep);
            }
            
        } completion:^(TorqueResult *result) {
            if (!result.succeed) {
                if (completion) {
                    completion(result);
                }
                return;
            }
            //下一步 索引
            NSInteger  nextStepIndex = index+1;
            
            //完成每一步 再进行 进度更新
            if (percentageCompletion) {
                percentageCompletion(perStep * nextStepIndex);
            }
            
            //是否有下一步的更新
            if (nextStepIndex < updateTypeArray.count) {
                
                [self uploadData:nextStepIndex updateTypeArray:updateTypeArray dataUpload:dataUpload percentageCompletion:percentageCompletion completion:completion];
                
            }else{//如果没有就结束
                
                if (percentageCompletion) {
                    percentageCompletion(100);
                }
                
                if (completion) {
                    
                    TorqueResult *result = [TorqueResult new];
                    result.succeed = TRUE;
                    result.result = 0;
                    result.error = nil;
                    
                    completion(result);
                }
            }
            
        }];
        
    }else{//超出范围
        
        if (percentageCompletion) {
            percentageCompletion(100);
        }
        
        if (completion) {
            
            TorqueResult *result = [TorqueResult new];
            result.succeed = FALSE;
            result.message = @"上传步骤为空";
            result.error = nil;
            result.result  = 101;
            
        }
    }
}


- (BOOL)hasDataUpload
{
    NSArray *array = [[TorqueDataOperation sharedInstance] getTorqueTripInfo];
    
    if (array && array.count    ) {
        return TRUE;
    }

    return FALSE;
}

- (void)uploadData:(void(^)(CGFloat percentage))percentageCompletion
        completion:(void(^)(TorqueResult *result))completion
{
    TorqueResult *result = [TorqueResult new];
    
    
    //是否有数据上传
    if (![self hasDataUpload]) {
        result.result = 305;
        result.message = @"无上传数据";
        
        if (completion) {
            completion(result);
        }
        
        return;
    }
 
    
    if (![TorqueGlobal sharedInstance].user || ![TorqueGlobal sharedInstance].user.userId) {
        result.result = 301;
        result.message = @"用户userId为空";
        
        if (completion) {
            completion(result);
        }
        
        return;
    }
    
    
    if (![TorqueGlobal sharedInstance].carInfo || ![TorqueGlobal sharedInstance].carInfo.vinCode) {
        result.result = 302;
        result.message = @"车辆信息vin码为空";
        
        if (completion) {
            completion(result);
        }
        
        return;
    }
    
    if (![TorqueGlobal sharedInstance].deviceInfo || ![TorqueGlobal sharedInstance].deviceInfo.sn) {
        result.result = 303;
        result.message = @"设备信息sn为空";
        
        if (completion) {
            completion(result);
        }
        
        return;
    }
    
    if (![TorqueGlobal sharedInstance].appId) {
        result.result = 304;
        result.message = @"appId为空";
        
        if (completion) {
            completion(result);
        }
        
        return;
    }
    
    DataUpload *dataUpload = [DataUpload new];
    dataUpload.userId      = [TorqueGlobal sharedInstance].user.userId;
    dataUpload.appId       = [TorqueGlobal sharedInstance].appId;
    dataUpload.sn          = [TorqueGlobal sharedInstance].deviceInfo.sn;
    dataUpload.deviceId    = [TorqueGlobal sharedInstance].deviceInfo.deviceId;
    
    NSArray *updateTypeArray = [NSArray arrayWithObjects:
                                @(TorqueDataSyncTypeTrips),
                                nil];
    
    [self uploadData:0 updateTypeArray:updateTypeArray dataUpload:dataUpload percentageCompletion:percentageCompletion completion:completion];
    
}



@end
