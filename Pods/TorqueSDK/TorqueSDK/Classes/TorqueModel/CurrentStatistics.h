//
//  CurrentStatistics.h
//  TorqueSDK
//
//  Created by zhangjipeng on 1/29/15.
//  Copyright (c) 2015 chexiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TorqueData.h"

@interface CurrentStatistics : TorqueData

/**
 *  本次行驶里程 （km）
 */
@property (nonatomic, assign, readonly) CGFloat thisTimeDistance;

/**
 *  累计行驶里程 （km）
 */
@property (nonatomic, assign, readonly) CGFloat accumulateDistance;

/**
 *  总里程 （km）
 */
@property (nonatomic, assign, readonly) CGFloat totalDistance;

/**
 *  本次耗油量 （L）
 */
@property (nonatomic, assign, readonly) CGFloat thisTimeFuel;

/**
 *  累计耗油量 （L）
 */
@property (nonatomic, assign, readonly) CGFloat accumulateFuel;

/**
 *  本次急加速次数
 */
@property (nonatomic, assign, readonly) NSUInteger thisTimeSuddenSeedUpCount;

/**
 *  本次急减速次数
 */
@property (nonatomic, assign, readonly) NSUInteger thisTimeSuddenSpeedReduceCount;

@end
