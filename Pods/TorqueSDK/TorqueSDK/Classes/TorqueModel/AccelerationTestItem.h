//
//  AccelerationTestItem.h
//  TorqueSDK
//
//  Created by zhangjipeng on 2/1/15.
//  Copyright (c) 2015 chexiang. All rights reserved.
//

#import "AccelerationTest.h"

@interface AccelerationTestItem : AccelerationTest

/**
 *  发动机转速 （rpm)
 */
@property (nonatomic, assign, readonly) NSUInteger rotationSpeed;

/**
 *  车速  （km/h）
 */
@property (nonatomic, assign, readonly) float carSpeed;


/**
 *  所用毫秒数  （ms）
 */
@property (nonatomic, assign, readonly) NSUInteger duration;

/**
 *  转速延迟 （ms）
 */
@property (nonatomic, assign, readonly) NSUInteger rpmDelay;

/**
 *  车速延迟 （ms）
 */
@property (nonatomic, assign, readonly) NSUInteger carSpeedDelay;

@end
