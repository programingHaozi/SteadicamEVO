//
//  TorqueAccelerationTest.m
//  TorqueSDK
//
//  Created by zhangjipeng on 1/29/15.
//  Copyright (c) 2015 chexiang. All rights reserved.
//

#import "TorqueAccelerationTest.h"
#import "OBDDevice+AccelerationTest.h"


@interface TorqueAccelerationTest()

@property (nonatomic, assign) BOOL isStarted;

@end
@implementation TorqueAccelerationTest

+ (instancetype)sharedInstance {
    static TorqueAccelerationTest *accTest = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        accTest = [TorqueAccelerationTest new];
    });
    return accTest;
}

/**
 *  进入百公里加速测试模式
 *
 *  @param completion
 */
- (void)EnterAccelerationTestMode:(void (^)(AccelerationTest *acceleartionTest, NSError *error))completion {
    [[OBDDevice sharedInstance] EnterAccelerationTestMode:completion];
}

/**
 *  开始百公里测试
 *
 *  @param completion 每隔200毫秒返回一次测试数据
 */
- (void)startAccelerationTest:(void (^)(AccelerationTestItem *acceleartionTestItem, NSError *error))everyTime completion:(void (^)(AccelerationTestItem *acceleartionTestItem, NSError *error))finish {
    [[OBDDevice sharedInstance] startAccelerationTest:everyTime completion:finish];
}


/**
 *  退出百公里加速测试模式
 *
 *  @param completion
 */
- (void)ExitAccelerationTestMode:(void (^)(AccelerationTest *acceleartionTest, NSError *error))completion {
    [[OBDDevice sharedInstance] ExitAccelerationTestMode:completion];
}


@end
