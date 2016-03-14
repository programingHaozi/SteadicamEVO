//
//  TFGCDQueue.h
//  TFBaseLib
//
//  Created by xiayiyong on 16/3/3.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TFGCDQueue;

@interface TFGCDTimer : NSObject

@property (strong, readonly, nonatomic) dispatch_source_t dispatchSource;

#pragma 初始化
- (instancetype)init;
- (instancetype)initInQueue:(TFGCDQueue *)queue;

#pragma mark - 用法
- (void)event:(dispatch_block_t)block timeInterval:(uint64_t)interval;
- (void)event:(dispatch_block_t)block timeInterval:(uint64_t)interval delay:(uint64_t)delay;
- (void)event:(dispatch_block_t)block timeIntervalWithSecs:(float)secs;
- (void)event:(dispatch_block_t)block timeIntervalWithSecs:(float)secs delaySecs:(float)delaySecs;
- (void)start;
- (void)destroy;

@end
