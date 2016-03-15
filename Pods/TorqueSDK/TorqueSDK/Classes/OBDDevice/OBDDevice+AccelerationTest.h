//
//  OBDDevice+AccelerationTest.h
//  TorqueSDK
//
//  Created by zhangjipeng on 2/9/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import "OBDDevice.h"
#import "AccelerationTest.h"
#import "AccelerationTestItem.h"

#define ATACCParamExit    @"0"  // 退出测试模式
#define ATACCParamEnter   @"1"  // 进入测试模式
#define ATACCParamStart   @"2"  // 开始测试模式

@interface OBDDevice (AccelerationTest)

@property (nonatomic, strong, readonly) NSMutableArray *accItems;

/**
 *  进入百公里加速测试模式
 *
 *  @param completion
 */
- (void)EnterAccelerationTestMode:(void (^)(AccelerationTest *acceleartionTest, NSError *error))completion;

/**
 *  开始百公里测试
 *
 *  @param completion 每隔200毫秒返回一次测试数据
 */
- (void)startAccelerationTest:(void (^)(AccelerationTestItem *acceleartionTestItem, NSError *error))everyTime completion:(void (^)(AccelerationTestItem *acceleartionTestItem, NSError *error))finish;

/**
 *  退出百公里加速测试模式
 *
 *  @param completion
 */
- (void)ExitAccelerationTestMode:(void (^)(AccelerationTest *acceleartionTest, NSError *error))completion;

@end