//
//  OBDDevice+AccelerationTest.m
//  TorqueSDK
//
//  Created by zhangjipeng on 2/9/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import "OBDDevice+AccelerationTest.h"
#import <objc/runtime.h>

@implementation OBDDevice (AccelerationTest)

- (NSMutableArray*)accItems {
    NSMutableArray *items = objc_getAssociatedObject(self, @selector(accItems));
    if (!items) {
        items = [NSMutableArray new];
        objc_setAssociatedObject(self, @selector(accItems), items, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return items;
}


/**
 *  进入百公里加速测试模式
 *
 *  @param completion
 */
- (void)EnterAccelerationTestMode:(void (^)(AccelerationTest *acceleartionTest, NSError *error))completion {
    __block typeof (self) weakSelf = self;
    void(^errorBlock)(NSError *error) = ^(NSError *error) {
        
        DDLogDebug(@"读取加速测试数据出现异常");
        
        if (completion) {
            completion(nil,error);
        }
        [weakSelf.dataProcessor closeDataStreamForType:OBDDataStreamTypeACCOn];
        [weakSelf ExitAccelerationTestMode:^(AccelerationTest *acceleartionTest, NSError *error) {
            DDLogDebug(@"Exit Acceleration Test Mode!");
        }];
    };
    
    self.dataProcessor.errorHandler = ^(NSString *errorCode) {
        if (errorCode) {
            DDLogDebug(@"收到错误码：%@", errorCode);
            
            //  如果错误不是json表的 处理异常
            errorCode = [[weakSelf.dataProcessor.errors allKeys] containsObject:errorCode] ? errorCode : @"503";
            errorBlock([NSError errorWithDomain:@"com.torque"
                                           code:-1
                                       userInfo:@{NSLocalizedDescriptionKey: [weakSelf.dataProcessor.errors objectForKey:errorCode]}]);
            weakSelf.dataProcessor.errorHandler = nil;
        }
    };
    [self.dataProcessor fetchDataStreamForType:OBDDataStreamTypeACCOn AndParam:ATACCParamEnter completion:^(OBDDataStream *stream, NSError *error) {
        if (completion) {
            if (!error) {
                DDLogDebug(@"Enter Acceleration Test Mode!");
            }
            completion(nil, error);
        }
    }];
}

/**
 *  开始百公里加速测试
 *
 *  @param completion 每隔200毫秒返回一次测试数据
 */
- (void)startAccelerationTest:(void (^)(AccelerationTestItem *acceleartionTestItem, NSError *error))everyTime completion:(void (^)(AccelerationTestItem *acceleartionTestItem, NSError *error))finish {
    
    __block BOOL isOverTest = NO;
    __block typeof (self) weakSelf = self;
    
    NSUInteger timeCounter = 20000;//ms
    
//   没有达到20s，就达到100 和  如果超出20s，则手动结束测试
//    收到错误码 中断加速测试
    
    void(^errorBlock)(NSError *error) = ^(NSError *error) {
        
        DDLogDebug(@"读取加速测试数据出现异常");
        
        if (finish) {
            finish(nil,error);
        }
        [weakSelf.dataProcessor closeDataStreamForType:OBDDataStreamTypeACCStart];
        [weakSelf ExitAccelerationTestMode:^(AccelerationTest *acceleartionTest, NSError *error) {
            DDLogDebug(@"Exit Acceleration Test Mode!");
        }];
    };
    
    self.dataProcessor.errorHandler = ^(NSString *errorCode) {
        if (errorCode) {
            DDLogDebug(@"收到错误码：%@", errorCode);
            
//            如果错误不是json表的 处理异常
            errorCode = [[weakSelf.dataProcessor.errors allKeys] containsObject:errorCode]?errorCode:@"503";
            isOverTest = YES;
            errorBlock([NSError errorWithDomain:@"com.torque" code:-1 userInfo:@{NSLocalizedDescriptionKey: [weakSelf.dataProcessor.errors objectForKey:errorCode]}]);
            weakSelf.dataProcessor.errorHandler = nil;
        }
    };
    
    [self.dataProcessor fetchDataStreamForType:OBDDataStreamTypeACCStart AndParam:ATACCParamStart completion:^(OBDDataStream *stream, NSError *error) {
        DDLogDebug(@"Doing Acceleration Test ...");
        
        if(!isOverTest)
        {
            AccelerationTestItem *item = [[AccelerationTestItem alloc] initWithDataStream:stream];
            if (everyTime) {
                if (item.duration > timeCounter) {
                    isOverTest = YES;
                    
                    OBDDataItem *durationItem = stream.items[3];
                    durationItem.value = [NSString stringWithFormat:@"%ld",timeCounter];
                    
                    item = [[AccelerationTestItem alloc] initWithDataStream:stream];
                     finish(item,error);
                    [weakSelf.dataProcessor closeDataStreamForType:OBDDataStreamTypeACCStart];
                    [weakSelf ExitAccelerationTestMode:^(AccelerationTest *acceleartionTest, NSError *error) {
                        DDLogDebug(@"Exit Acceleration Test Mode!");
                    }];
                }
                else
                {
                    [weakSelf.accItems addObject:item];
                    everyTime(item,error);
                }
            }
        }
        else
        {
            AccelerationTestItem *item = [[AccelerationTestItem alloc] initWithDataStream:stream];
            finish(item,error);
            [weakSelf.dataProcessor closeDataStreamForType:OBDDataStreamTypeACCStart];
            [weakSelf ExitAccelerationTestMode:^(AccelerationTest *acceleartionTest, NSError *error) {
                DDLogDebug(@"Exit Acceleration Test Mode!");
            }];
        }
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((timeCounter/1000) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        isOverTest = YES;
    });
    
    [self.dataProcessor fetchDataStreamForType:OBDDataStreamTypeACCEnd AndParam:nil completion:^(OBDDataStream *stream, NSError *error) {
                DDLogDebug(@"Acceleration Test Completed!");
                if (finish) {
                    AccelerationTestItem *item = [[AccelerationTestItem alloc] initWithDataStream:stream];
                    if (item.carSpeed > 100.0) {
#if 0
                        AccelerationTestItem *lastItem = [weakSelf.accItems lastObject];
#endif
                        CGFloat ms = item.duration;
                        
    #if 0
                        CGFloat a = 0;
                        CGFloat b = 0;

                        //lastItem.carSpeed == lastItem.duration * a + b;
                        //a = (lastItem.carSpeed - b) / lastItem.duration;
                        
                        //item.carSpeed == item.duration * a - b;
                        //b == item.duration * a - item.carSpeed;
                        
                        //a = (lastItem.carSpeed - item.duration * a + item.carSpeed) / lastItem.duration;
                        //a = lastItem.carSpeed / lastItem.duration - (item.duration * a) / lastItem.duration + item.carSpeed / lastItem.duration;
                        //a * (1 + item.duration / lastItem.duration) = lastItem.carSpeed / lastItem.duration + item.carSpeed / lastItem.duration;
                        a = (lastItem.carSpeed / lastItem.duration + item.carSpeed / lastItem.duration) / (1 + item.duration / lastItem.duration);
                        b = item.duration * a - item.carSpeed;
                        
                        CGFloat speed = 100.0;
                        ms = (speed - b) / a;

                        
                        OBDDataItem *speedItem = stream.items[2];
                        speedItem.value = @"100";
    #else
                        OBDDataItem *speedItem = stream.items[2];
                        speedItem.value = [NSString stringWithFormat:@"%f",item.carSpeed];
    #endif
                        OBDDataItem *durationItem = stream.items[3];
                        if (item.duration > timeCounter) {
                            durationItem.value = [NSString stringWithFormat:@"%ld", (long)timeCounter];
                        }
                        else
                        {
                            durationItem.value = [NSString stringWithFormat:@"%ld", (long)ms];
                        }
                        
                        item = [[AccelerationTestItem alloc] initWithDataStream:stream];
                    }
                    
                    finish(item,error);
                }

                [weakSelf.dataProcessor closeDataStreamForType:OBDDataStreamTypeACCStart];
                [weakSelf ExitAccelerationTestMode:^(AccelerationTest *acceleartionTest, NSError *error) {
                    DDLogDebug(@"Exit Acceleration Test Mode!");
                }];
            }];
}

/**
 *  退出百公里加速测试模式
 *
 *  @param completion
 */
- (void)ExitAccelerationTestMode:(void (^)(AccelerationTest *acceleartionTest, NSError *error))completion {
    
    __block typeof (self) weakSelf = self;
    void(^errorBlock)(NSError *error) = ^(NSError *error) {
        
        DDLogDebug(@"退出加速测试模式出现异常");
        
        if (completion) {
            completion(nil,error);
        }
        [weakSelf.dataProcessor closeDataStreamForType:OBDDataStreamTypeACCOff];
    };
    
    self.dataProcessor.errorHandler = ^(NSString *errorCode) {
        if (errorCode) {
            DDLogDebug(@"收到错误码：%@", errorCode);
            
            //  如果错误不是json表的 处理异常
            errorCode = [[weakSelf.dataProcessor.errors allKeys] containsObject:errorCode] ? errorCode : @"503";
            errorBlock([NSError errorWithDomain:@"com.torque"
                                           code:-1
                                       userInfo:@{NSLocalizedDescriptionKey: [weakSelf.dataProcessor.errors objectForKey:errorCode]}]);
            weakSelf.dataProcessor.errorHandler = nil;
        }
    };
    
    FetchDataStreamForType(OBDDataStreamTypeACCOff, AccelerationTest, ATACCParamExit);
}

@end
