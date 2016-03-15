//
//  OBDDevice+PIDMode.m
//  TorqueSDK
//
//  Created by zhangjipeng on 2/9/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import "OBDDevice+PIDMode.h"

@implementation OBDDevice (PIDMode)

/**
 *  进入PID Mode
 *
 *  @param completion 回调，成功error为nil，失败error非nil
 */
- (void)enterPIDMode:(void (^)(NSError *error))completion {
    [self.dataProcessor fetchDataStreamForType:OBDDataStreamTypePIDOn
                                      AndParam:nil
                                    completion:^(OBDDataStream *stream, NSError *error) {
                                        OBDDataItem *item = [stream.items firstObject];
                                        if ([item.value isEqualToString:@"OK"]) {
                                            DDLogWarn(@"Enter PID Mode!");
                                            // 进入PID模式
                                            self.dataProcessor.obdMode = OBDModePID;
                                            completion(nil);
                                        } else {
                                            completion(error);
                                        }
                                    }];
}

/**
 *  退出PID Mode
 *
 *  @param completion 回调，成功error为nil，失败error非nil
 */
- (void)exitPIDMode:(void (^)(NSError *error))completion {
    if (self.dataProcessor.obdMode == OBDModeNormal) {
        if (completion) {
            completion(nil);
            return;
        }
    }
    // 退出PID模式
    self.dataProcessor.obdMode = OBDModeNormal;
    [self.dataProcessor fetchDataStreamForType:OBDDataStreamTypePIDOff
                                      AndParam:nil
                                    completion:^(OBDDataStream *stream, NSError *error) {
                                        CloseDataStreamForType(OBDDataStreamTypePIDCommand);
                                        OBDDataItem *item = [stream.items firstObject];
                                        if ([item.value isEqualToString:@"OK"]) {
                                            DDLogWarn(@"Exit PID Mode!");
                                            completion(nil);
                                        } else {
                                            completion(error);
                                        }
                                    }];
}


- (void)queryPIDValue:(PidCommand *)command completion:(void (^)(PidModel *pidModelWithCommand, NSError *error))completion {
    if (!command) {
        if (completion) {
            NSError *error = [NSError errorWithDomain:TorqueErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"要查询的command对象不能为空"}];
            completion(nil, error);
        }
        return;
    }
    [self.dataProcessor requestPID:command.name
                        completion:^(NSString *value, NSError *error) {
                            if (!error && value) {
                                NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
                                NSArray *valueArray = [value componentsSeparatedByString:@"\r"];
                                if (valueArray) {
                                    [valueArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                        NSString *objStr = obj;
                                        if (objStr.length > 0) {
                                            [mutableArray addObject:obj];
                                        }
                                    }];
                                }
                                else
                                {
                                    [mutableArray addObject:value];
                                }
                                [mutableArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                    PidModel *pidModel = nil;
                                    pidModel = [PidModel new];
                                    pidModel.pid = (NSString *)obj;
                                    
                                    if (completion) {
                                        completion(pidModel, error);
                                    }
                                }];
                            }
                            else
                            {
                                if (completion) {
                                    completion(nil, error);
                                }
                            }
                        }];
}

- (NSString *)getTroubleCodes {
    __block NSString *troubleCode = nil;
    __block BOOL timeOut = YES;
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [self.dataProcessor fetchDataStreamForType:OBDDataStreamTypeDTC
                                      AndParam:nil
                                    completion:^(OBDDataStream *stream, NSError *error) {
                                        OBDDataItem *item = stream.items[1];
                                        if (item.value && ![item.value isEqualToString:@"NULL"]) {
                                            troubleCode = item.value;
                                        }
                                        timeOut = NO;
                                        dispatch_semaphore_signal(sema);
                                    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kReadDataStreamTimeout * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (timeOut) {
            CloseDataStreamForType(OBDDataStreamTypeDTC);
            dispatch_semaphore_signal(sema);
        }
    });
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    return troubleCode;
}

- (BOOL)cleanTroubleCodes
{
    __block BOOL timeOut = YES;
    __block BOOL succeed = NO;
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [self.dataProcessor fetchDataStreamForType:OBDDataStreamTypeCDI
                                      AndParam:nil
                                    completion:^(OBDDataStream *stream, NSError *error) {
                                        OBDDataItem *item = stream.items[1];
                                        if (item.value && ![item.value isEqualToString:@"OK"]) {
                                            succeed = YES;
                                        }
                                        timeOut = NO;
                                        dispatch_semaphore_signal(sema);
                                    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kReadDataStreamTimeout * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (timeOut) {
            CloseDataStreamForType(OBDDataStreamTypeDTC);
            dispatch_semaphore_signal(sema);
        }
    });
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    return succeed;
}

@end
