//
//  Torque.m
//  OBD-DEMO
//
//  Created by zhangjipeng on 1/23/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import "Torque.h"
#import "Torque+Private.h"
#import "Torque+RestKit.h"


@implementation Torque

+ (instancetype)sharedInstance {
    NSAssert(1 > 2, @"Must override in subclass!!!");
    return nil;
}

- (instancetype)init {
    if (self = [super init]) {
        [self createDescriptors];
    }
    return self;
}


- (void)startTimeout:(float)timeout completion:(void(^)(TorqueResult *result))completion
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeout * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (completion) {
            completion([TorqueResult new]);
        }
    });
}

@end
@implementation TimeOutObject

/**
 *  启动超时检测
 *
 *  @param timeout    超时时间
 *  @param target     要检测的对象
 *  @param content    检测池
 *  @param completion 超时回调
 */
- (void)startTimeout:(float)timeout
              target:(NSNumber *)target
             content:(NSArray *)content
          completion:(void(^)(NSError *error, BOOL timeOut))completion {
    self.completionBlock = completion;
    __weak typeof(self) weakSelf = self;
    __block BOOL timeOut = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeout * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (NSNumber *item in content) {
            if (item.intValue == target.intValue) {
                timeOut = YES;
                break;
            }
        }
        if (weakSelf.completionBlock) {
            weakSelf.completionBlock([NSError errorWithDomain:@"com.torque" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"读取超时"}], timeOut);
        }
    });
}
/**
 *  启动超时检测
 *
 *  @param timeout    超时时间
 *  @param target     要检测的对象
 *  @param content    检测池
 *  @param completion 超时回调
 */
- (void)startTimeout:(float)timeout
    targetWithString:(NSString *)target
             content:(NSArray *)content
          completion:(void(^)(NSError *error, BOOL timeOut))completion {
    self.completionBlock = completion;
    __weak typeof(self) weakSelf = self;
    __block BOOL timeOut = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeout * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (NSString *item in content) {
            if ([item isEqualToString:target]) {
                timeOut = YES;
                break;
            }
        }
        if (weakSelf.completionBlock) {
            weakSelf.completionBlock((timeOut) ? [NSError errorWithDomain:@"com.torque" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"读取超时"}] : nil, timeOut);
        }
    });

}
/**
 *  清除注册的超时回调
 */
- (void)clean {
    self.completionBlock = nil;
}
@end
