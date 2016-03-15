//
//  OBDDevice+Trip.m
//  TorqueSDK
//
//  Created by zhangjipeng on 2/9/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import "OBDDevice+Trip.h"
#import "OBDDeviceFuncMacro.h"
#import <objc/runtime.h>
#import "NSString+Date.h"

static const void *keyTime = &keyTime;
@implementation OBDDevice (Trip)
@dynamic timeArray;
-(NSMutableArray *)timeArray {
    return objc_getAssociatedObject(self, keyTime);
}
- (void)setTimeArray:(NSMutableArray *)timeArray {
    objc_setAssociatedObject(self, keyTime, timeArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
/**
 *  获取最后一次行程统计信息
 *
 *  @param completion
 */
- (void)fetchLastTripRecord:(void (^)(TorqueTripInfo *tripRecord, NSError *error))completion {
    FetchDataStreamForType(OBDDataStreamTypeLastTrip, TorqueTripInfo, nil);
}

/**
 *  获取历史行程统计信息
 *
 *  @param completion
 */
- (void)fetchHistoryTripInfo:(void (^)(HistoryTripInfo *historyTripInfo, NSError *error))completion {
    FetchDataStreamForType(OBDDataStreamTypeHistoryTripInfo, HistoryTripInfo, nil);
}

/**
 *  获取指定记录行程信息(批量)
 *
 *  @param range      要读取的记录的范围
 *  @param completion
 */

- (void)batchHistoryTripRecordWithRange:(HistoryTripInfo *)historyTripInfo next:(void (^)(TorqueTripInfo *tripRecord, NSError *error))next completed:(void (^)(NSError *error))completed{
    
    __weak typeof(self) weakSelf = self;
    __block NSUInteger batchCount = 0;
    __block BOOL timeOut = YES;
    __block NSUInteger retryCount = 1;
    __block dispatch_semaphore_t sema;
    
    __block void (^finishCompletion)(NSError *error) = nil;
    
    self.batchTripSuccessCount = 0;
    
    //    如果盒子剩余的数量少于批量设置默认值 则更新默认值
    if(self.batchTripCount > historyTripInfo.count)
    {
        self.batchTripCount = historyTripInfo.count;
    }
    
    self.dataProcessor.errorHandler = ^(NSString *errorCode) {
        [weakSelf.dataProcessor closeDataStreamForType:OBDDataStreamTypeHistoryTripRecord];
        if (errorCode) {
            DDLogDebug(@"收到错误码：%@", errorCode);
            if (!finishCompletion) {
                if ([errorCode isEqualToString:kDeviceDisConnectedString]) {
                    completed([NSError errorWithDomain:@"com.torque"
                                                  code:-1
                                              userInfo:[NSDictionary dictionaryWithObject:kDeviceDisConnectedString forKey:@"message"]]);
                }
                else
                {
                    completed([NSError errorWithDomain:@"com.torque"
                                                  code:-1
                                              userInfo:@{NSLocalizedDescriptionKey: errorCode}]);
                }
                
                finishCompletion = completed;
            }
        }
        weakSelf.dataProcessor.errorHandler = nil;
        
        retryCount = 3;
        dispatch_semaphore_signal(sema);
        
    };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        while (retryCount < 3) {
            sema = dispatch_semaphore_create(0);
            
            NSString *param = [NSString stringWithFormat:@"%ld",(long)(self.batchTripCount)];
            DDLogDebug(@"batch read count = %ld",batchCount);
            DDLogInfo(@"读取记录index:%ld, count数为= %ld",(long)(historyTripInfo.index ),(long)(self.batchTripCount));
            
            [self.dataProcessor fetchDataStreamForType:OBDDataStreamTypeHistoryTripRecord AndParam:param completion:^(OBDDataStream *stream, NSError *error) {
                
                dispatch_semaphore_signal(sema);
                
                timeOut = NO;
                
                if(error) {
                    DDLogError(@"读取行程出现异常");
                    
                    if(error.code == -1)
                    {
                        timeOut = YES;
                        
                        if(retryCount >= 3)
                        {
                            if (!finishCompletion) {
                                
                                CloseDataStreamForType(OBDDataStreamTypeHistoryTripRecord);
                                
                                if (completed) {
                                    completed(error);
                                }
                                
                                finishCompletion = completed;
                            }
                            
                            return ;
                        }
                    }
                    else
                    {
                        if (error.code == 999) {
                            batchCount = self.batchTripCount;
                        }
                    }
                }
                
                if ((batchCount >= weakSelf.batchTripCount) || !stream || retryCount > 3) {
                    DDLogDebug(@"---------------------------该批次读取结束");
                    
                    batchCount = 0;
                    
                    if (!finishCompletion) {
                        
                        [weakSelf.dataProcessor closeDataStreamForType:OBDDataStreamTypeHistoryTripRecord];
                        if (completed) {
                            completed(nil);
                        }
                        
                        finishCompletion = completed;
                    }
                }
                else
                {
                    TorqueTripInfo *tripInfo = [[TorqueTripInfo alloc] initWithDataStream:stream];
                    if (tripInfo.recordId == 0) {
                        DDLogError(@"行程数据recordId为0 !!!!!!!!!!!!!!!!");
                        return;
                    }
                    // 暴露的entity 接收数据  begin
                    if (next) {
                        next(tripInfo, error);
                    }
                    // 暴露的entity 接收数据  end
                    batchCount++;
                    self.batchTripSuccessCount++;
                }
                
            }];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kATBackCallTimer * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                dispatch_semaphore_signal(sema);
                
                if (timeOut) {
                    //                    CloseDataStreamForType(OBDDataStreamTypeHistoryTripRecord);
                    retryCount++;
                }
            });
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            
            if (!timeOut) {
                DDLogDebug(@"读取指令没超时－－－－－－－－－－－－－－－－");
                break;
            }
            
            DDLogDebug(@"读取重试次数:%ld，   之前重试超时",retryCount);
        }//while
        
        //        重试3次，仍超时
        if(timeOut)
        {
            batchCount = 0;
            DDLogDebug(@"重试超时 batchhistory ");
            /*[self.dataProcessor closeDataStreamForType:OBDDataStreamTypeHistoryTripRecord];
             if (completed) {
             completed(nil);
             }*/
        }
        
    });
}

/**
 *  获取指定记录行程信息
 *
 *  @param range      要读取的记录的范围
 *  @param completion
 */
- (void)fetchHistoryTripRecordWithRange:(HistoryTripInfo *)historyTripInfo next:(void (^)(TorqueTripInfo *tripRecord, NSError *error))next completed:(void (^)(NSError *error))completed; {
    
    __weak OBDDevice *weakSelf = self;
    self.timeArray = [NSMutableArray new];
    __block NSMutableDictionary *timeOutItem = [NSMutableDictionary dictionary];
    
    __block void (^isNeedBackComplete )(NSError *error) = nil;
    
    void(^errorBlock)(NSError *error, BOOL timeOut) = ^(NSError *error, BOOL timeOut) {
        
        DDLogDebug(@"读取行程出现异常");
        [weakSelf.dataProcessor closeDataStreamForType:OBDDataStreamTypeHistoryTripRecord];
        [weakSelf.timeArray removeAllObjects];
        for (TimeOutObject *timeOutObj in timeOutItem) {
            if ([timeOutObj isKindOfClass:[TimeOutObject class]]) {
                [timeOutObj clean];
            }
        }
        [timeOutItem removeAllObjects];
        
        if (next) {
            next(nil,nil);
        }
        
        if (completed) {
            completed(error);
        }
    };
    /**
     *  添加一个超时检测对象
     *
     *  @param index 当前序号
     */
    void(^addTimeOutBlock)(NSNumber *index) = ^(NSNumber *index) {
        TimeOutObject *timeOutOjb = [TimeOutObject new];
        [timeOutOjb startTimeout:kATBackCallTimer
                          target:index
                         content:weakSelf.timeArray
                      completion:errorBlock];
        [timeOutItem setObject:timeOutOjb forKey:index];
        [weakSelf.timeArray addObject:index];
    };
    /**
     *  清除超时检测对象
     *
     *  @param index 当前序号
     */
    void(^cleanTimeOutBlock)(NSNumber *index) = ^(NSNumber *index) {
        TimeOutObject *timeOutOjb = [timeOutItem objectForKey:index];
        [timeOutOjb clean];
        
        [timeOutItem removeObjectForKey:index];
        [weakSelf.timeArray removeObject:index];
    };
    self.dataProcessor.errorHandler = ^(NSString *errorCode) {
        
        if (errorCode) {
            DDLogDebug(@"收到错误码：%@", errorCode);
            if (!isNeedBackComplete) {
                if ([errorCode isEqualToString:kDeviceDisConnectedString]) {
                    errorBlock([NSError errorWithDomain:@"com.torque"
                                                   code:-1
                                               userInfo:[NSDictionary dictionaryWithObject:kDeviceDisConnectedString forKey:@"message"]], NO);
                }
                else
                {
                    errorBlock([NSError errorWithDomain:@"com.torque"
                                                   code:-1
                                               userInfo:@{NSLocalizedDescriptionKey: errorCode}],NO);
                }
                
                isNeedBackComplete = completed;
            }
            
        }
        
        weakSelf.dataProcessor.errorHandler = nil;
    };
    __block BOOL isTimeout = YES;
    [weakSelf startTimeout:kATBackCallTimer completion:^(TorqueResult *result) {
        
        if (isTimeout) {
            if (!isNeedBackComplete)
            {
                errorBlock([NSError errorWithDomain:@"com.torque" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"读取行程超时"}], YES);
                
                isNeedBackComplete = completed;
            }
        }
        
    }];
    
    if (historyTripInfo.index - 1 >= historyTripInfo.count) {
        __block NSUInteger from = historyTripInfo.index - historyTripInfo.count;
        __block NSUInteger to = from;
        
        NSString *param = [NSString stringWithFormat:@"%ld,%ld",(long)(from),(long)(to)];
        DDLogDebug(@"读取记录范围:%ld,%ld",(long)(from),(long)(to));
        __block NSUInteger count = 0;
        
        [self.dataProcessor fetchDataStreamForType:OBDDataStreamTypeHistoryTripRecord AndParam:param completion:^(OBDDataStream *stream, NSError *error) {
            isTimeout = NO;
            cleanTimeOutBlock(@(count));
            if(error)
            {
                if (!isNeedBackComplete) {
                    
                    errorBlock(error,(error.code == -1));
                    isNeedBackComplete = completed;
                }
                
                return ;
            }
            
            if (next) {
                
                
                if (count >= historyTripInfo.count) {
                    
                    [weakSelf.dataProcessor closeDataStreamForType:OBDDataStreamTypeHistoryTripRecord];
                    
                    if (!isNeedBackComplete)
                    {
                        if (next) {
                            next(nil,nil);
                        }
                        
                        if (completed) {
                            completed(nil);
                            
                            isNeedBackComplete = completed;
                        }
                    }
                } else {
                    
                    TorqueTripInfo *tripInfo = [[TorqueTripInfo alloc] initWithDataStream:stream];
                    if (tripInfo.recordId == 0) {
                        DDLogDebug(@"行程数据recordId为0 !!!!!!!!!!!!!!!!");
                        
                        if (!isNeedBackComplete)
                        {
                            errorBlock([NSError errorWithDomain:@"com.torque" code:-1 userInfo:@{@"message":@"error"}],(error.code == -1));
                            
                            isNeedBackComplete = completed;
                        }
                        return ;
                    }
                    next(tripInfo,error);
                    count ++;
                    
                    from++;
                    to = from;
                    NSString *param1 = [NSString stringWithFormat:@"%ld,%ld",(long)(from),(long)(to)];
                    // 添加一个超时检测对象
                    addTimeOutBlock(@(count));
                    [weakSelf.dataProcessor fetchDataStreamForType:OBDDataStreamTypeHistoryTripRecord AndParam:param1 completion:nil];
                }
            }
        }];
    } else {
        __block NSUInteger from = self.maxTripCount + historyTripInfo.index - historyTripInfo.count;
        __block NSUInteger to = from;
        __block NSUInteger count = 0;
        NSString *param = [NSString stringWithFormat:@"%ld,%ld",(long)from, (long)to];
        DDLogDebug(@"读取记录范围:%ld,%ld",(long)from, (long)to);
        
        [self.dataProcessor fetchDataStreamForType:OBDDataStreamTypeHistoryTripRecord AndParam:param completion:^(OBDDataStream *stream, NSError *error) {
            isTimeout = NO;
            cleanTimeOutBlock(@(count));
            
            if(error)
            {
                if (!isNeedBackComplete)
                {
                    errorBlock(error,(error.code == -1));
                    
                    isNeedBackComplete = completed;
                }
                return ;
            }
            
            if (next) {
                
                
                if (count == (historyTripInfo.count - historyTripInfo.index + 1)) {
                    [weakSelf.dataProcessor closeDataStreamForType:OBDDataStreamTypeHistoryTripRecord];
                    if (historyTripInfo.index == 1 && completed) {
                        if (!isNeedBackComplete) {
                            
                            completed(nil);
                            isNeedBackComplete = completed;
                        }
                        
                    }  else {
                        from = 1;
                        to = from;
                        NSString *param1 = [NSString stringWithFormat:@"1,%ld",(long)to];
                        DDLogDebug(@"读取记录范围:1,%ld",(long)to);
                        // 添加一个超时检测对象
                        addTimeOutBlock(@(count));
                        
                        [weakSelf.dataProcessor fetchDataStreamForType:OBDDataStreamTypeHistoryTripRecord AndParam:param1 completion:^(OBDDataStream *stream, NSError *error) {
                            cleanTimeOutBlock(@(count));
                            if(error)
                            {
                                if (!isNeedBackComplete)
                                {
                                    errorBlock(error,(error.code == -1));
                                    
                                    isNeedBackComplete = completed;
                                }
                                return ;
                            }
                            
                            if (next) {
                                
                                
                                if (count >= historyTripInfo.count) {
                                    [weakSelf.dataProcessor closeDataStreamForType:OBDDataStreamTypeHistoryTripRecord];
                                    
                                    if (!isNeedBackComplete)
                                    {
                                        if (next) {
                                            next(nil,nil);
                                        }
                                        
                                        if (completed) {
                                            completed(nil);
                                            
                                            isNeedBackComplete = completed;
                                        }
                                    }
                                } else {
                                    
                                    TorqueTripInfo *tripInfo = [[TorqueTripInfo alloc] initWithDataStream:stream];
                                    if (tripInfo.recordId == 0) {
                                        DDLogDebug(@"行程数据recordId为0 !!!!!!!!!!!!!!!!");
                                        if (!isNeedBackComplete) {
                                            errorBlock([NSError errorWithDomain:@"com.torque" code:-1 userInfo:@{@"message":@"error"}],(error.code == -1));
                                            
                                            isNeedBackComplete = completed;
                                        }
                                        
                                        return ;
                                    }
                                    next(tripInfo,error);
                                    
                                    
                                    count++;
                                    
                                    from++;
                                    to = from;
                                    NSString *param2 = [NSString stringWithFormat:@"%ld,%ld",(long)(from),(long)(to)];
                                    // 添加一个超时检测对象
                                    addTimeOutBlock(@(count));
                                    
                                    [weakSelf.dataProcessor fetchDataStreamForType:OBDDataStreamTypeHistoryTripRecord AndParam:param2 completion:nil];
                                }
                            }
                        }];
                    }
                }
                else if (count < (historyTripInfo.count - historyTripInfo.index + 1)) {
                    
                    TorqueTripInfo *tripInfo = [[TorqueTripInfo alloc] initWithDataStream:stream];
                    if (tripInfo.recordId == 0) {
                        DDLogDebug(@"行程数据recordId为0 !!!!!!!!!!!!!!!!");
                        if (!isNeedBackComplete)
                        {
                            errorBlock([NSError errorWithDomain:@"com.torque" code:-1 userInfo:@{@"message":@"error"}],(error.code == -1));
                            
                            isNeedBackComplete = completed;
                        }
                        return ;
                    }
                    next(tripInfo,error);
                    
                    
                    count++;
                    
                    
                    from++;
                    to = from;
                    NSString *param1 = [NSString stringWithFormat:@"%ld,%ld",(long)(from),(long)(to)];
                    // 添加一个超时检测对象
                    addTimeOutBlock(@(count));
                    [weakSelf.dataProcessor fetchDataStreamForType:OBDDataStreamTypeHistoryTripRecord AndParam:param1 completion:nil];
                }
            }
        }];
    }
    
}

/**
 *  删除指定行程统计信息
 *
 *  @param range      要删除的记录的范围
 *  @param completion
 */
- (void)deleteHistoryTripRecordWithRange:(NSRange)range completion:(void (^)(NSError *error))completion {
    __block BOOL timeOut = YES;
    __block void (^isNeedBackComplete )(NSError *error) = nil;
    
    [self startTimeout:kATBackCallTimer completion:^(TorqueResult *result) {
        if (timeOut) {
            if(!isNeedBackComplete)
            {
                if (completion) {
                    completion([NSError errorWithDomain:@"com.torque" code:-1 userInfo:nil]);
                    
                    isNeedBackComplete = completion;
                }
            }
        }
    }];
    NSString *param = [NSString stringWithFormat:@"%ld,%ld",(long)range.location,(long)(range.location + range.length - 1)];
    [self.dataProcessor fetchDataStreamForType:OBDDataStreamTypeDeleteHistoryTrip AndParam:param completion:^(OBDDataStream *stream, NSError *error) {
        /*if (!timeOut) {
         return;
         }*/
        timeOut = NO;
        OBDDataItem *item = stream.items[0];
        
        if(!isNeedBackComplete)
        {
            if (completion) {
                completion(([item.value isEqual:@"OK"]) ? nil : [NSError errorWithDomain:@"com.torque" code:-1 userInfo:nil]);
            }
            
            isNeedBackComplete = completion;
        }
    }];
}

/**
 *  删除指定行程统计信息(批量)
 *
 *  @param range      要删除的记录的范围
 *  @param completion
 */

- (void)deleteBatchHistoryTripRecordWithRange:(HistoryTripInfo *)tripInfo completion:(void (^)(NSError *error))completion {
    __block BOOL timeOut = YES;
    __block NSUInteger retryCount = 1;
    __block void (^isNeedBackComplete )(NSError *error) = nil;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (retryCount < 3) {
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            
            NSString *param = [NSString stringWithFormat:@"%ld,%ld",(long)(tripInfo.index),(long)(self.self.batchTripSuccessCount)];
            DDLogDebug(@"删除指令 写地址为: %ld count数为: %ld",(long)(tripInfo.index),(long)(self.self.batchTripSuccessCount));
            
            [self.dataProcessor fetchDataStreamForType:OBDDataStreamTypeDeleteHistoryTrip AndParam:param completion:^(OBDDataStream *stream, NSError *error) {
                
                dispatch_semaphore_signal(sema);
                
                if(error)
                {
                    timeOut = YES;
                }
                else
                {
                    timeOut = NO;
                    OBDDataItem *item = stream.items[0];
                    NSError *_error = [NSError errorWithDomain:@"com.torque" code:-1 userInfo:nil];
                    
                    if (!isNeedBackComplete) {
                        if (completion) {
                            completion(([item.value isEqual:@"OK"]) ? nil : _error);
                        }
                        
                        retryCount = 3;
                        
                        isNeedBackComplete = completion;
                    }
                    
                }
                
            }];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kATBackCallTimer * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                dispatch_semaphore_signal(sema);
                
                if (timeOut) {
                    //                    timeOut = NO;
                    //
                    //                    CloseDataStreamForType(OBDDataStreamTypeDeleteHistoryTrip);
                    retryCount++;
                }
            });
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            
            if (!timeOut) {
                DDLogDebug(@"删除指令没超时－－－－－－－－－－－－－－－－");
                break;
                
            }
            
            DDLogDebug(@"删除重试次数:%ld，   之前重试超时",retryCount);
        }//while
        
        if(timeOut)
        {
            DDLogDebug(@"结束重试机制");
            if (!isNeedBackComplete) {
                if (completion) {
                    completion([NSError errorWithDomain:@"com.torque" code:-1 userInfo:nil]);
                }
                
                isNeedBackComplete = completion;
            }
        }
    });
}


/**
 *  写入行程
 *
 *  @param count 写入的行程总数
 *  @param completion
 */
- (void)writeHistoryTripRecordWithCount:(NSUInteger)tripCount completion:(void (^)(NSError *error))completion
{
    NSString *param = [NSString stringWithFormat:@"%ld",(long)tripCount];
    [self.dataProcessor fetchDataStreamForType:OBDDataStreamTypeWriteTrip AndParam:param completion:^(OBDDataStream *stream, NSError *error) {
        
        OBDDataItem *item = stream.items[0];
        if ([item.value isEqual:@"OK"]) {
            completion(nil);
        }
    }];
}

@end