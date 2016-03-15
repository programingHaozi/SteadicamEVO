//
//  TorqueAccelerationTest.h
//  TorqueSDK
//
//  Created by zhangjipeng on 1/29/15.
//  Copyright (c) 2015 chexiang. All rights reserved.
//

#import "TorqueEquipment.h"
#import "AccelerationTestItem.h"

@class AccelerationTest;
@class AccelerationTestItem;

@interface TorqueAccelerationTest : TorqueEquipment


/**
 *  进入百公里加速测试模式
 *
 *  @param completion
 */
- (void)EnterAccelerationTestMode:(void (^)(AccelerationTest *acceleartionTest, NSError *error))completion;

/**
 *  开始百公里测试
 *
 *  @param completion 每隔300毫秒返回一次测试数据
 */
- (void)startAccelerationTest:(void (^)(AccelerationTestItem *acceleartionTestItem, NSError *error))everyTime completion:(void (^)(AccelerationTestItem *acceleartionTestItem, NSError *error))finish;

/**
 *  退出百公里加速测试模式
 *
 *  @param completion
 */
- (void)ExitAccelerationTestMode:(void (^)(AccelerationTest *acceleartionTest, NSError *error))completion;


@end
