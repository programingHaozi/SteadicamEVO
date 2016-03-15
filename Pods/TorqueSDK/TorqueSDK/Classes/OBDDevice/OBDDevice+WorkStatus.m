//
//  OBDDevice+WorkStatus.m
//  TorqueSDK
//
//  Created by zhangjipeng on 2/9/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import "OBDDevice+WorkStatus.h"
#import "OBDDeviceFuncMacro.h"
#import "NSString+Date.h"
#import <objc/runtime.h>

@implementation OBDDevice (WorkStatus)

@dynamic dateEngineStart;

- (BOOL)realtimeDataStreamOn {
    NSNumber *result = objc_getAssociatedObject(self, @selector(realtimeDataStreamOn));
    if (!result) {
        return YES;
    } else {
         return [result boolValue];
    }
}

- (void)setRealtimeDataStreamOn:(BOOL)realtimeDataStreamOn {
    objc_setAssociatedObject(self, @selector(realtimeDataStreamOn), @(realtimeDataStreamOn), OBJC_ASSOCIATION_ASSIGN);
}

- (NSDate *)dateEngineStart {
    return objc_getAssociatedObject(self, @selector(dateEngineStart));
}

- (void)setDateEngineStart:(NSDate *)date {
    objc_setAssociatedObject(self, @selector(dateEngineStart), date, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)getEngineStartTime:(void (^)(NSError *error))completion {
    if (!self.dateEngineStart) {
        [self.dataProcessor fetchDataStreamForType:OBDDataStreamTypeECUStart
                                          AndParam:nil
                                        completion:^(OBDDataStream *stream, NSError *error) {
                                            OBDDataItem *item = [stream.items firstObject];
                                            if (item) {
                                                NSString *timeString = item.value;
                                                self.dateEngineStart = [NSString dateFromString:timeString ForDateFormatter:nil];
                                                DDLogVerbose(@"车辆点火时间：%@",[NSString stringFromDate:self.dateEngineStart ForDateFormatter:nil]);
                                                completion(nil);
                                            }
                                        }];
    } else {
        completion(nil);
    }
    
}

/**
 *  获取实时工况数据
 *
 *  @param completion
 */
- (void)subscribeRealTimeWorkStatus:(void (^)(WorkStatus *workStatus, NSError *error))completion {
    if (!self.realtimeDataStreamOn) {
        __weak OBDDevice *weakSelf = self;
        [self.dataProcessor fetchDataStreamForType:OBDDataStreamTypeRTON
                                          AndParam:nil
                                        completion:^(OBDDataStream *stream, NSError *error) {
                                            OBDDataItem *item = stream.items[0];
                                            if ([item.value isEqual:@"OK"]) {
                                                weakSelf.realtimeDataStreamOn = YES;
                                            }
                                        }];
    }
    
    void (^complete)(OBDDataStream *stream, NSError *error) = ^(OBDDataStream *stream, NSError *error)
    {
        if (!stream) {
            completion(nil,error);
            return ;
        }
        
        WorkStatus *ws = [[WorkStatus alloc] initWithDataStream:stream?stream:nil];
#if USE_EST530
        //        之前 [NSDate date] 时差8小时
        NSDate *currDate = [NSString currentDate];
        
        if (self.dateEngineStart) {
            double ms = [currDate timeIntervalSinceDate:self.dateEngineStart];
            ws.currentDuration = (long)ms;
        } else {
            ws.currentDuration = 0;
        }
        
        DDLogWarn(@"当前行驶时长 = %lds",ws.currentDuration);
#endif
        completion(ws, error);
    };
    
    __block BOOL timeOut = YES;
    [self startTimeout:kATBackCallTimer * 2 completion:^(TorqueResult *result) {
        if (timeOut) {
            if (completion) {
                complete(nil,[NSError errorWithDomain:@"com.torque" code:-1 userInfo:nil]);
            }
        }
    }];
    
    [self.dataProcessor fetchDataStreamForType:OBDDataStreamTypeRT
                                      AndParam:nil
                                    completion:^(OBDDataStream *stream, NSError *error) {
                                        timeOut = NO;
                                        complete(stream,error);
                                    }];
#if USE_EST530
    [self getEngineStartTime:^(NSError *error) {
        
    }];
#endif
}

/**
 *  关闭实时工况数据
 */
- (void)unsubscribeRealTimeWorkStatus:(void (^)(NSError *error))completion {
    if (self.realtimeDataStreamOn) {
        __weak OBDDevice *weakSelf = self;
        [self.dataProcessor fetchDataStreamForType:OBDDataStreamTypeRTOff
                                          AndParam:nil
                                        completion:^(OBDDataStream *stream, NSError *error) {
                                            OBDDataItem *item = stream.items[0];
                                            if ([item.value isEqual:@"OK"]) {
                                                weakSelf.realtimeDataStreamOn = NO;
                                            }
                                        }];
        self.dateEngineStart = nil;
    }
    
    //CloseDataStreamForType(OBDDataStreamTypeRT);
}

/**
 *  订阅实时统计数据
 *
 *  @param completion
 */
- (void)subscribeRealTimeStatistics:(void (^)(CurrentStatistics *, NSError *))completion {
    FetchDataStreamForType(OBDDataStreamTypeAMT, CurrentStatistics, nil);
}

/**
 *  退订实时统计数据
 */
- (void)unsubscribeRealTimeStatistics:(void (^)(NSError *error))completion {
    
}

/**
 *  实时数据流开关
 *
 *  @param onOff      传入YES打开实时数据流，出入NO关闭实时数据流
 */
- (void)realTimeDataStreamSwitch:(BOOL)onOff {
    if (onOff) {
        [self.dataProcessor fetchDataStreamForType:OBDDataStreamTypeRTON
                                          AndParam:nil
                                        completion:^(OBDDataStream *stream, NSError *error) {
                                        }];
    } else {
        [self.dataProcessor fetchDataStreamForType:OBDDataStreamTypeRTOff
                                          AndParam:nil
                                        completion:^(OBDDataStream *stream, NSError *error) {
                                        }];
    }
}

@end
