//
//  TorqueDataSync.m
//  TorqueSDK
//
//  Created by huxianchen on 15/3/2.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import "TorqueDataSync.h"
#import "TorqueNetworkConfig.h"
#import "Torque+RestKit.h"
#import "Torque+Private.h"
#import "OBDDevice.h"
#import "DataUpload.h"
#import "TorqueSDKCoreDataHelper.h"
#import "TorqueTripInfoModel.h"
#import "OBDDevice+Trip.h"
#import "TorqueTripInfoModel+Convert.h"
#import "TorqueDataOperation.h"
#import "NSString+Date.h"
#import "TorqueGlobal.h"

#define kTimeIntervalSyncOneTripRecord  (0.7)   // 同步一条行程记录所用的最大时间（s）

#define kRecordPercentageMin 0.0    //行程回传0%
#define kRecordPercentageMax 100.0    //行程回传100%

static CGFloat syncTripSum = 0.0;//计算同步的条数
static NSUInteger totalTripSun = 0;//记录批量读取算法的行程总数

static NSDate *lastSyncDate=nil;//上次同步成功的时间

static TorqueResult *_result = nil;
static TorqueDataSync *instance = nil;

@interface TorqueDataSync()

@property (nonatomic, strong) NSMutableArray *tripItems;
/**
 *  用于统计存储数据次数
 */
@property (nonatomic) NSInteger storeDataCount;

@end

@implementation TorqueDataSync

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [TorqueDataSync new];
        
        [instance obdDevice];
    });
    return instance;
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

- (NSDate *)getLastDataSyncTime
{
    return [[TorqueDataOperation sharedInstance] getLastSyncTime];
}

/**
 *  同步行程 存储机制(单条)
 *  530、531均改为 接收一条存储一条
 *  规避 除断开盒子外，百分比更新，数据上传条数不对的问题
 *  @param completion 完成回调
 */
- (void)storeDataWithSource:(TorqueTripInfo *)tripInfo completion:(void(^)(BOOL insertFinish))completion {
    
    NSUInteger count = 0;
    
    NSDate *startDate  = [NSString dateFromString:tripInfo.startDate ForDateFormatter:kDateFormat];
    
    if ([startDate laterDate:lastSyncDate]) {
        lastSyncDate = startDate;
    }
    
    @try {
        if (![[TorqueDataOperation sharedInstance] tripInfoExist:tripInfo]) {
            TorqueTripInfoModel *model = [[TorqueSDKCoreDataHelper sharedInstance] newByEntityName:@"TorqueTripInfo"];
            [model transferByObject:tripInfo];
            [[TorqueSDKCoreDataHelper sharedInstance] saveContext];
        }
        
        count++;
    }
    @catch (NSException *exception) {
        DDLogInfo(@"存储行程 出现异常 recordID = %ld, %@", tripInfo.recordId,exception.description);
    }
    @finally {}
    
    BOOL succeed = (count > 0);
    
    if (completion) {
        completion(succeed);
    }
}

/**
 *  同步行程 读取后，存取数据库
 *
 *  @param completion 完成回调
 */
- (void)storeData:(void(^)(BOOL insertFinish))complete {
    self.storeDataCount++;
    NSUInteger count = 0;
    
    for (TorqueTripInfo *tripRecord in _tripItems) {
        // 从盒子里读到一条历史行程，存入Core Data
        @try {
            if (![[TorqueDataOperation sharedInstance] tripInfoExist:tripRecord]) {
                TorqueTripInfoModel *model = [[TorqueSDKCoreDataHelper sharedInstance] newByEntityName:@"TorqueTripInfo"];
                [model transferByObject:tripRecord];
                [[TorqueSDKCoreDataHelper sharedInstance] saveContext];
            }
            count++;
        }
        @catch (NSException *exception) {
            DDLogInfo(@"%@", exception.description);
        }
        @finally {}
    }
    BOOL succeed = (count == _tripItems.count);
    if (complete) {
        complete(succeed);
    }
    [_tripItems removeAllObjects];
    if (succeed) {
        // 更新时间
        lastSyncDate = [NSString currentDate];//[NSDate date];
        [[TorqueDataOperation sharedInstance] setLastSyncTime: lastSyncDate];
    }
}

- (void)addTripItem:(TorqueTripInfo *)object {
    if (object) {
        [_tripItems addObject:object];
    }
}

/**
 *  同步行程 存储结果类型
 */
typedef enum  TripResultCode
{
    DataSyncSuccess = 0,//同步行程成功   yes
    DataNoBlockResponse = 101,//没有行程回调  no
    DataNoUpdate = 102,//选择不上传   no
    DataWaitTimeOut = 104,//获取历史行程记录信息超时  判断同步了多少条
    DataRecevieUnCorrect = 105,//参数解析不正确  判断同步了多少条
    DataSyncInterrupt = 106,//历史行程同步失败，已同步..条,共..条
    DataReceiveTimeOut = 111,//接收蓝牙数据超时  判断同步了多少条
    DataSyncNoNeed = 201,//没有行程记录  yes
};

- (NSDictionary *)tripResultDict
{
    return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"历史行程同步完成"
                                                ,@"没有行程回调"
                                                ,@"选择不上传"
                                                ,@"获取历史行程记录信息超时"
                                                ,@"读取历史行程记录信息超时"/*@"参数解析不正确"*/
                                                ,@"历史行程同步失败,已同步%d条,共%ld条"
                                                ,@"接收数据超时"
                                                ,@"未发现新的行程数据"
                                                ,nil]
                                       forKeys:[NSArray arrayWithObjects:[NSNumber numberWithInt:DataSyncSuccess]
                                                ,[NSNumber numberWithInt:DataNoBlockResponse]
                                                ,[NSNumber numberWithInt:DataNoUpdate]
                                                ,[NSNumber numberWithInt:DataWaitTimeOut]
                                                ,[NSNumber numberWithInt:DataRecevieUnCorrect]
                                                ,[NSNumber numberWithInt:DataSyncInterrupt]
                                                ,[NSNumber numberWithInt:DataReceiveTimeOut]
                                                ,[NSNumber numberWithInt:DataSyncNoNeed]
                                                , nil]];
}

/**
 * 处理不同的回调情况
 */
- (TorqueResult *)handleCompletion:(enum TripResultCode) resultCode summary:(unsigned long)summary
{
    TorqueResult * tempResult = [[TorqueResult alloc] init];
    
    switch (resultCode) {
        case DataSyncSuccess:
        {
            tempResult.succeed = YES;
            tempResult.message = [[self tripResultDict] objectForKey:[NSNumber numberWithInt:DataSyncSuccess]];
            tempResult.result = DataSyncSuccess;
        }
            break;
            
        case DataNoBlockResponse:
        {
            tempResult.succeed = NO;
            
            //            如果是批量读取，要看是否是成功读取过之后，读取行程记录总数超时  成功读取，都为行程同步完成
            if ([OBDDevice sharedInstance].useBatchFetch && (syncTripSum > 0)) {
                tempResult.succeed = YES;
            }
            
            tempResult.message = [[self tripResultDict] objectForKey:[NSNumber numberWithInt:DataNoBlockResponse]];
            tempResult.result = DataNoBlockResponse;
        }
            break;
            
        case DataNoUpdate:
        {
            tempResult.succeed = NO;
            tempResult.message = [[self tripResultDict] objectForKey:[NSNumber numberWithInt:DataNoUpdate]];
            tempResult.result = DataNoUpdate;
        }
            break;
            
        case DataWaitTimeOut:
        {
            if (syncTripSum > 0) {
                tempResult.succeed = YES;
                tempResult.message = [NSString stringWithFormat:@"获取历史行程记录信息超时:已同步:%f条 共:%ld条", syncTripSum, (unsigned long)summary];
            }
            else
            {
                tempResult.succeed = NO;
                tempResult.message = [[self tripResultDict] objectForKey:[NSNumber numberWithInt:DataWaitTimeOut]];
                
            }
            
            tempResult.result = DataWaitTimeOut;
        }
            break;
            
        case DataRecevieUnCorrect:
        {
            if (syncTripSum > 0) {
                tempResult.succeed = YES;
            }
            else
            {
                tempResult.succeed = NO;
            }
            
            tempResult.message = [[self tripResultDict] objectForKey:[NSNumber numberWithInt:DataRecevieUnCorrect]];
            tempResult.result = DataRecevieUnCorrect;
        }
            break;
            
        case DataSyncInterrupt:
        {
            if (syncTripSum > 0) {
                tempResult.succeed = YES;
            }
            else
            {
                tempResult.succeed = NO;
            }
            
            tempResult.message = [NSString stringWithFormat:@"历史行程同步失败,已同步%f条,共%ld条",syncTripSum, (unsigned long)summary];
            tempResult.result = DataSyncInterrupt;
        }
            break;
            
        case DataReceiveTimeOut:
        {
            if (syncTripSum > 0) {
                tempResult.succeed = YES;
            }
            else
            {
                tempResult.succeed = NO;
            }
            
            tempResult.message = [NSString stringWithFormat:@"历史行程同步失败,已同步%f条,共%ld条",syncTripSum, (unsigned long)summary];
            tempResult.result = DataReceiveTimeOut;
        }
            break;
            
        case DataSyncNoNeed:
        {
            tempResult.succeed = NO;
            tempResult.message = [[self tripResultDict] objectForKey:[NSNumber numberWithInt:DataSyncNoNeed]];
            tempResult.result = DataSyncNoNeed;
        }
            break;
            
        default:
            break;
    }
    //            switch end
    
//    syncTripSum = 0;
//    lastSyncDate = nil;
    
    if(tempResult.succeed)
    {
        lastSyncDate = [NSString currentDate];//[NSDate date];
        
        //设置最新的同步时间
        if (lastSyncDate) {
            [[TorqueDataOperation sharedInstance] setLastSyncTime:lastSyncDate];
        }
    }
    
    return tempResult;
}

/**
 *
 *
 *  @return 返回同步数据条数及预计需要时间
 */
- (void)getDataSyncInfo:(void(^)(DataSync *dataSync))dataSyncCompletion
{
    [[OBDDevice sharedInstance] fetchHistoryTripInfo:^(HistoryTripInfo *historyTripInfo, NSError *error) {
        
        DataSync *dataSync = [DataSync new];
        [dataSync setValue:@(historyTripInfo.count) forKey:@"count"];
        [dataSync setValue:@([self getTripSyncCostTime:historyTripInfo.count]) forKey:@"costDate"];
        
        if (dataSyncCompletion) {
            dataSyncCompletion(dataSync);
        }
    }];
}

/**
 *  获取同步行程需要的时长
 *
 *  @param tripCount 行程记录条数
 *
 *  @return 返回值
 */
- (float)getTripSyncCostTime:(NSInteger)tripCount
{
    float perTime = kTimeIntervalSyncOneTripRecord;
    return tripCount*perTime;
}

/**
 *  同步行程
 *
 *  @param completion 完成回调
 */

- (NSUInteger)minusBySelf:(NSUInteger)count
{
    return  count--;
}


//行程同步完成回调
- (void)handleCompletionWithResultCode:(enum TripResultCode)resultCode andDeviceStatus:(BOOL)deviceDisConnect andTripSummary:(NSUInteger)summary
              withpercentageCompletion:(void(^)(CGFloat percentage))percentageCompletion
                            completion:(void(^)(TorqueResult *result))completion
{
    _result = [self handleCompletion:resultCode summary:summary];
    
    if(!(_result.succeed))
    {
        if (percentageCompletion) {
            percentageCompletion(
                                 (resultCode == DataSyncNoNeed)?kRecordPercentageMax:kRecordPercentageMin);
        }
    }
    else
    {
#if 1
//        宝盒 与盒子断开连接 不在界面回传正确的进度
        if (percentageCompletion) {
            percentageCompletion(kRecordPercentageMax);
        }
#else
        if(!deviceDisConnect)
        {
            if (percentageCompletion) {
                percentageCompletion(kRecordPercentageMax);
            }
        }
        else
        {
            if (percentageCompletion) {
                percentageCompletion((totalTripSun > 0)?(kRecordPercentageMax * syncTripSum / totalTripSun):kRecordPercentageMin);
            }
        }
#endif
    }
    
    //    与盒子失去连接的判断 还要使用
    syncTripSum = 0;
    lastSyncDate = nil;
    
    if (completion) {
        percentageCompletion = nil;
        completion(_result);
    }
    
}


//* 读一条删一条
- (void)getHistoryRecords:(int(^)(HistoryTripInfo *historyTripInfo, float costTime))tripInfoCompletion
     percentageCompletion:(void(^)(CGFloat percentage))percentageCompletion
               completion:(void(^)(TorqueResult *result))completion
{
    __block typeof(self) weakSelf = self;
    
    //    行程记录总数
    __block NSUInteger tripSummary = 0;
    
    //    是否与盒子断开连接
    __block BOOL isDeviceDisconnected = NO;
    
    //    避免block重复回传
    __block void(^isFinishCompletion)(TorqueResult *result) = nil;
    
    void(^TripEndBlock)(enum TripResultCode resultCode) = ^(enum TripResultCode resultCode) {
        
        if (!isFinishCompletion) {
            
            [weakSelf handleCompletionWithResultCode:resultCode
                                     andDeviceStatus:isDeviceDisconnected
                                      andTripSummary:tripSummary withpercentageCompletion:percentageCompletion completion:completion];
            
            isFinishCompletion = completion;
        }
    };
    
    //    读取行程记录总数超时 开关
    __block BOOL isTripInfoTimeout = YES;
    
    //    同步所有行程预估超时时间 开关
    __block BOOL isTripRecordTimeout = YES;
    
    
    //    监控行程记录总数 读取超时
    [self startTimeout:kATBackCallTimer completion:^(TorqueResult *result) {
        if (isTripInfoTimeout) {
            TripEndBlock(DataNoBlockResponse);
        }
    }];
    
    //   读取行程总数
    [[OBDDevice sharedInstance] fetchHistoryTripInfo:^(HistoryTripInfo *historyTripInfo, NSError *error) {
        
        DDLogInfo(@"本次读取到 %ld 条行程 syncTripSum ＝ %f", (unsigned long)historyTripInfo.count,syncTripSum);
        
        isTripInfoTimeout = NO;
        
        tripSummary = historyTripInfo.count;
        
        // 行程记录总数为0，结束同步
        if (historyTripInfo.count == 0 && completion) {
            
            TripEndBlock(DataSyncNoNeed);
            return;
        }
        
        //超时多增加15s
        float tripRecordTimeout = [weakSelf getTripSyncCostTime:historyTripInfo.count];
        int isSyncTrip = tripInfoCompletion(historyTripInfo, tripRecordTimeout);
        
        //如果是后台默认同步 或 需要进行同步
        if (!isSyncTrip){
            DDLogInfo(@"不在同步状态");
            TripEndBlock(DataNoUpdate);
        }
        else
        {
            
            //监控读取行程超时  开关
            [weakSelf startTimeout:tripRecordTimeout+15 completion:^(TorqueResult *result) {
                
                if (isTripRecordTimeout) {
                    DDLogInfo(@"获取行程 超时处理机制");
                    TripEndBlock(DataWaitTimeOut);
                }
            }];
            
            //            读取行程
            [[OBDDevice sharedInstance] fetchHistoryTripRecordWithRange:historyTripInfo next:^(TorqueTripInfo *tripRecord, NSError *error) {
                //需要处理数据业务
                if(tripRecord || error)
                {
                    DDLogInfo(@"dataRead:第%f条, 记录唯一号:%ld, startTime:%@, endDate:%@",syncTripSum, tripRecord.recordId,tripRecord.startDate, tripRecord.endDate);
                    
                    //            将读取的行程存入本地数据库 成功，则更新百分比，并执行删除指令
                    [self storeDataWithSource:tripRecord completion:^(BOOL insertFinish)
                     {
                         
                         if(!insertFinish)
                         {
                             DDLogInfo(@"530 数据存储失败");
                             TripEndBlock(DataSyncInterrupt);
                         }
                         else
                         {
                             [[OBDDevice sharedInstance] deleteHistoryTripRecordWithRange:NSMakeRange(tripRecord.recordId , 1) completion:^(NSError *error) {
                                 DDLogInfo(@"Has Deleted History Trip Record %ld!", (long)tripRecord.recordId);
                             }];
                             sleep(0.08);
                             
                             if (percentageCompletion) {
                                 percentageCompletion(kRecordPercentageMax * ++syncTripSum / historyTripInfo.count);
                             }
                         }
                     }];
                    
                }
            } completed:^(NSError *error) {
                
                isTripRecordTimeout = NO;
                DDLogInfo(@"530同步行程数据结束");
                
                if (error) {
                    if ([[error.userInfo objectForKey:@"message"] isEqualToString:kDeviceDisConnectedString]) {
                        isDeviceDisconnected = YES;
                    }
                    
                    TripEndBlock(DataRecevieUnCorrect);
                    return ;
                }
                
                //插入的数据与获取的数据一样的同步完成
                if (syncTripSum == historyTripInfo.count) {
                    DDLogInfo(@"530同步行程数据完成");
                    TripEndBlock(DataSyncSuccess);
                }
                else
                {
                    DDLogInfo(@"530 同步过程中断");
                    TripEndBlock(DataSyncInterrupt);
                }
                return ;
            }];
            
        }
        
        
    }];
}

/*
 * 批量读取算法实现
 * 1.读取盒子剩余的行程记录总数 jump 2
 * 2.读取一次批量数据      jump 3
 * 3.读一条，存储数据库一条    jump 4
 * 4.读完一批数据，则删除该批数据  jump 5
 * 5.删除成功，跳转到1
 */
- (void)getBatchHistoryRecords:(int(^)(HistoryTripInfo *historyTripInfo, float costTime))tripInfoCompletion
          percentageCompletion:(void(^)(CGFloat percentage))percentageCompletion
                    completion:(void(^)(TorqueResult *result))completion
{
    __block typeof(self) weakSelf = self;
    
    //    监控读取行程记录总数超时  开关
    __block BOOL isTripInfoTimeout = YES;
    
    //    监控 批量读取行程预计时间超时 开关
    __block BOOL isTripRecordTimeout = YES;
    
    //    与盒子断开连接
    __block BOOL isDeviceDisconnected = NO;
    
    //    避免block重复回传
    __block void(^isFinishCompletion)(TorqueResult *result) = nil;
    
    void(^TripBatchEndBlock)(enum TripResultCode resultCode) = ^(enum TripResultCode resultCode) {
        
        if (!isFinishCompletion) {
            [weakSelf handleCompletionWithResultCode:resultCode
                                     andDeviceStatus:isDeviceDisconnected
                                      andTripSummary:totalTripSun withpercentageCompletion:percentageCompletion completion:completion];
            
            isFinishCompletion = completion;
        }
    };
    
    
    //    监控行程记录总数 读取超时
    [self startTimeout:kATBackCallTimer completion:^(TorqueResult *result) {
        if (isTripInfoTimeout) {
            
            TripBatchEndBlock(DataNoBlockResponse);
        }
    }];
    
    //读取行程记录总数
    [[OBDDevice sharedInstance] fetchHistoryTripInfo:^(HistoryTripInfo *historyTripInfo, NSError *error) {
        
        isTripInfoTimeout = NO;
        
        if (totalTripSun == 0) {
            totalTripSun = historyTripInfo.count;
        }
        
        DDLogInfo(@" 当前读取到 %ld 条行程 已同步的syncTripSum ＝ %f， 行程记录总数为：… %ld", (unsigned long)historyTripInfo.count,syncTripSum,totalTripSun);
        
        // 531
        if (historyTripInfo.count == 0 ) {
            
            // 判断是否第一次取的行程记录 就是0
            TripBatchEndBlock((totalTripSun >0)?DataSyncSuccess:DataSyncNoNeed);
            
            return;
        }
        
        float tripRecordTimeout = [weakSelf getTripSyncCostTime:historyTripInfo.count];
        int isSyncTrip = tripInfoCompletion(historyTripInfo, tripRecordTimeout);
        
        //如果是后台默认同步 或 需要进行同步
        if (!isSyncTrip)
        {
            TripBatchEndBlock(DataNoUpdate);
            
            return;
        }
        
        ////监控读取行程超时  开关
        [weakSelf startTimeout:(tripRecordTimeout + 15) completion:^(TorqueResult *result) {
            if (isTripRecordTimeout) {
                
                DDLogInfo(@"获取行程 超时处理机制");
                
                TripBatchEndBlock(DataWaitTimeOut);
            }
        }];
        
        // 开始指读取行程
        [[OBDDevice sharedInstance] batchHistoryTripRecordWithRange:historyTripInfo next:^(TorqueTripInfo *tripRecord, NSError *error) {
            //需要处理数据业务
            if (tripRecord || error) {
                
                DDLogInfo(@"dataSync:第%f条, 记录唯一号:%ld, startTime:%@, endDate:%@", (syncTripSum), tripRecord.recordId,tripRecord.startDate, tripRecord.endDate);
                
                if (error) {
                    // 更新进度
                    TripBatchEndBlock(DataSyncInterrupt);
                    return ;
                }
                
                //            将读取的行程存入本地数据库 成功，则更新百分比，并执行删除指令
                [self storeDataWithSource:tripRecord completion:^(BOOL insertFinish)
                 {
                     
                     if(!insertFinish)
                     {
                         DDLogInfo(@"批量数据存储失败");
                         TripBatchEndBlock(DataSyncInterrupt);
                     }
                     else
                     {
                         if (percentageCompletion) {
                             percentageCompletion(kRecordPercentageMax * (++syncTripSum / totalTripSun)/*historyTripInfo.count*/);
                         }
                     }
                 }];
            }
        } completed:^(NSError *error) {
            isTripRecordTimeout = NO;
            
            //                    与盒子断开连接 之外的 error 将盒子里遇到error之前的数据进行同步上传 并执行删除指令
            if (error) {
                DDLogInfo(@"eoorcode 回调");
                
                //                        断开的时候 卡住进度
                if ([[error.userInfo objectForKey:@"message"] isEqualToString:kDeviceDisConnectedString]) {
                    
                    isDeviceDisconnected = YES;
                    
                    TripBatchEndBlock(DataRecevieUnCorrect);
                    return ;
                    
                }
            }
            
            //批量删除
            [[OBDDevice sharedInstance] deleteBatchHistoryTripRecordWithRange:historyTripInfo completion:^(NSError *error) {
                
                if((historyTripInfo.count > 0)  && !error) {
                    DDLogInfo(@"------------------ 已同步的行程为:%f" ,syncTripSum);
                    // 开启新一轮批量读取
                    [weakSelf getBatchHistoryRecords:tripInfoCompletion percentageCompletion:percentageCompletion completion:completion];
                } else {
                    DDLogInfo(@"completion completion 是否完成同步或同步中断判断----------------");
                    //插入的数据与获取的数据一样的同步完成
                    if (syncTripSum == totalTripSun) {
                        TripBatchEndBlock(DataSyncSuccess);
                    } else {
                        TripBatchEndBlock(DataSyncInterrupt);
                    }
                }
            }];
        }];
        
        
        
        
    }];
    //    －－－－－－－－－－－－－－－结束批量读取数据－－－－－－－－－－－－－－－
}

/**
 *  同步行程
 *  MODIFY GSY
 *  @param completion 完成回调
 */
- (void)syncTrip:(int(^)(HistoryTripInfo *historyTripInfo, float costTime))tripInfoCompletion
percentageCompletion:(void(^)(CGFloat percentage))percentageCompletion
      completion:(void(^)(TorqueResult *result))completion
{
    syncTripSum = 0;
    totalTripSun = 0;
    lastSyncDate=nil;
    
    _storeDataCount = 0;
    
    _result = [[TorqueResult alloc] init];
    if (![OBDDevice sharedInstance].useBatchFetch)
    {
        DDLogInfo(@"读取530的行程记录总数");
        [self getHistoryRecords:tripInfoCompletion percentageCompletion:percentageCompletion completion:completion];
    }
    else
    {
        DDLogInfo(@"读取531的行程记录总数");
        [self getBatchHistoryRecords:tripInfoCompletion percentageCompletion:percentageCompletion completion:completion];
    }
}


/**
 * 同步算法
 * 存储数据库 异常 跳出同步过程
 * 同步指令，收到error 跳出同步过程
 * 同步，数据超时，跳出同步过程
 * 如果，成功读取到行程，即使一部分，仍然返回同步百分百，否则返回0
 * 行程记录总数为0，则提示“未发现新的行程数据”
 * 与盒子连接断开，则进度百分比，不改变回传
 */
//以上是 读一条删一条 与批量读删通用的地方
//difference ：批量读取 如果遇到?等异常数据 跳过读取下一跳数据


// *******行程同步完成回调处理*******
//如果succeed 为NO
//            如果 不是行程总数为0，则回传0%
//            如果行程总数为0，则回传100%
//如果succeed 为YES
//            如果与盒子断开连接，进度不修改
//            如果未与盒子断开连接，回传100%

/**
 *  数据同步
 *
 *  @param backgroundSync       是否后台静默同步
 *  @param syncInfoCompletion   同步统计信息
 *  @param percentageCompletion 进度百分比
 *  @param completion           同步完成后的 回调
 */
- (void)dataSync:(int(^)(long count, float costTime))syncInfoCompletion
percentageCompletion:(void(^)(CGFloat percentage))percentageCompletion
      completion:(void(^)(TorqueResult *result))completion
{
    
    TorqueGlobal *global = [TorqueGlobal sharedInstance];
    TorqueResult *result = [TorqueResult new];
    
    if (!global.user || !global.user.userId) {
        result.result = 301;
        result.message = @"用户userId为空";
        
        if (completion) {
            completion(result);
        }
        
        return;
    }
    
    
    if (!global.carInfo || !global.carInfo.vinCode) {
        result.result = 302;
        result.message = @"车辆信息vin码为空";
        
        if (completion) {
            completion(result);
        }
        
        return;
    }
    
    if (!global.deviceInfo || !global.deviceInfo.sn) {
        result.result = 303;
        result.message = @"设备信息sn为空";
        
        if (completion) {
            completion(result);
        }
        
        return;
    }
    
    if (![[OBDDevice sharedInstance] isReadOBDSucess]) {
        result.message = @"同步失败";//获取OBD信息失败
        
        if (completion) {
            completion(result);
        }
        
        return;
    }
    
    [self syncTrip:^int(HistoryTripInfo *historyTripInfo, float costTime) {
        DDLogInfo(@"存入数据库的 打印 totalnum %ld",totalTripSun);
        if (syncInfoCompletion) {
            return  syncInfoCompletion(/*historyTripInfo.count*/([OBDDevice sharedInstance].maxTripCount == kEST530MaxTripCount)?historyTripInfo.count:totalTripSun, costTime);
        }
        
        return 0;
    } percentageCompletion:percentageCompletion completion:completion];
    
}

@end