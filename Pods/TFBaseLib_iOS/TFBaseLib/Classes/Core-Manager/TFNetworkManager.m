//
//  TFNetworkManager.m
//  Treasure
//
//  Created by xiayiyong on 15/9/6.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFNetworkManager.h"

@implementation TFNetworkManager

+ (void)load
{
    [super load];
    [TFNetworkManager sharedManager];
}

+ (instancetype)sharedManager
{
    static TFNetworkManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TFNetworkManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
        [afNetworkReachabilityManager startMonitoring];
    }
    return self;
}

+ (void)setReachabilityStatusChangeBlock:(void (^)(AFNetworkReachabilityStatus status))block
{
    if (block)
    {
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:block];
    }
}

#pragma mark -

- (BOOL)isReachable {
    return [self isReachableViaWWAN] || [self isReachableViaWiFi];
}

- (BOOL)isReachableViaWWAN {
    return self.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN;
}

- (BOOL)isReachableViaWiFi {
    return self.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi;
}

- (AFNetworkReachabilityStatus)networkReachabilityStatus {
    return [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
}

@end
