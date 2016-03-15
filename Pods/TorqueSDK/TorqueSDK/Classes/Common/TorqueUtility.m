//
//  TorqueUtility.m
//  TorqueSDK
//
//  Created by sunxiaofei on 15/3/19.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import "TorqueUtility.h"
#import "TorqueReachability.h"
#import "Torque.h"

typedef enum : NSUInteger {
    /**
     *  状态未知
     */
    TorqueNetWorkStatusUnknow,
    /**
     *  网络已连接
     */
    TorqueNetWorkStatusReachable,
    /**
     *  网络未连接
     */
    TorqueNetWorkStatusNotReachable,
} TorqueNetWorkStatus;

@interface TorqueUtility()

@property (nonatomic, strong) TorqueReachability *reach;
/**
 *  网络连接状态
 */
@property (nonatomic) TorqueNetWorkStatus netWorkStatus;

@end
@implementation TorqueUtility

+ (instancetype)sharedInstance {
    static TorqueUtility *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [TorqueUtility new];
    });
    
    return instance;
}
- (instancetype)init {
    if (self = [super init]) {
        self.netWorkStatus = TorqueNetWorkStatusUnknow;
    }
    return self;
}

+ (NSData *)readFileFromBundle:(NSString *)resourceName fileName:(NSString *)fileName fileType:(NSString *)fileType {
    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:resourceName ofType:@"bundle"];
    if (resourcePath.length > 0) {
        NSBundle *bundle = [[NSBundle alloc] initWithPath:resourcePath];
        NSString *filePath = [bundle pathForResource:fileName ofType: fileType];
        
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        if (!data) {
            DDLogWarn(@"the datastream file %@.%@ not found!",fileName,fileType);
        }
        
        return data;
    } else {
        DDLogWarn(@"the bundle %@ not found!",resourceName);
        return nil;
    }
}

- (void)motionNetwork:(void(^)(TorqueReachability *reach))reachableBlock unreachableBlock:(void(^)())unreachableBlock{
    // Allocate a reachability object
    __weak typeof(self) weakSelf = self;
    _reach = [TorqueReachability reachabilityWithHostname:@"www.baidu.com"];
    _reach.reachableBlock = ^(TorqueReachability*reach) {
        if (weakSelf.netWorkStatus == TorqueNetWorkStatusReachable) {
            return;
        }
        weakSelf.netWorkStatus = TorqueNetWorkStatusReachable;
        if (reachableBlock) {
            reachableBlock(reach);
        }
    };
    
    _reach.unreachableBlock = ^(TorqueReachability*reach) {
        if (weakSelf.netWorkStatus == TorqueNetWorkStatusNotReachable) {
            return;
        }
        weakSelf.netWorkStatus = TorqueNetWorkStatusNotReachable;
        if (unreachableBlock) {
            unreachableBlock();
        }
    };
    
    // Start the notifier, which will cause the reachability object to retain itself!
    [_reach startNotifier];
}
- (void)stopMotionNetwork {
    [_reach stopNotifier];
    _reach.reachableBlock = nil;
    _reach.unreachableBlock = nil;
}

@end