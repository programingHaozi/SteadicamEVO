//
//  TFNetworkManager.h
//  Treasure
//
//  Created by xiayiyong on 15/9/6.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "AFNetworkReachabilityManager.h"

@interface TFNetworkManager : NSObject

#define kTFNetworkManager  ([TFNetworkManager sharedManager])

+ (instancetype)sharedManager;

/**
 *  判断网络状态
 */
+ (void)setReachabilityStatusChangeBlock:(void (^)(AFNetworkReachabilityStatus status))block;

/**
 *  网络状态
 */
@property (readonly, nonatomic, assign) AFNetworkReachabilityStatus networkReachabilityStatus;

/**
 *  网络可用
 */
@property (readonly, nonatomic, assign, getter = isReachable) BOOL reachable;

/**
 *  移动网络
 */
@property (readonly, nonatomic, assign, getter = isReachableViaWWAN) BOOL reachableViaWWAN;

/**
 *  wifi网络
 */
@property (readonly, nonatomic, assign, getter = isReachableViaWiFi) BOOL reachableViaWiFi;

@end
