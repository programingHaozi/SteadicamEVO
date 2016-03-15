//
//  WorkStatus.h
//  TorqueSDK
//
//  Created by zhangjipeng on 1/29/15.
//  Copyright (c) 2015 chexiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TorqueData.h"

@interface WorkStatus : TorqueData

/**
 *  电瓶电压 （v）
 */
@property (nonatomic, assign, readonly) CGFloat batteryVoltage;


/**
 *  发动机转速 （rpm)
 */
@property (nonatomic, assign, readonly) NSUInteger rotationSpeed;

/**
 *  车速  （km/h）
 */
@property (nonatomic, assign, readonly) CGFloat carSpeed;

/**
 *  节气门开度  （%）
 */
@property (nonatomic, assign, readonly) CGFloat throttlePosition;

/**
 *  发动机负荷  （%）
 */
@property (nonatomic, assign, readonly) CGFloat engineLoad;

/**
 *  发动机冷却液温度 （℃）-40 ~ 215
 */
@property (nonatomic, assign, readonly) CGFloat coolantTemperature;

/**
 *  瞬时油耗 （L/100km）
 */
@property (nonatomic, assign, readonly) CGFloat instantFuel;

/**
 *  平均油耗 （L/100km）
 */
@property (nonatomic, assign, readonly) CGFloat averageFuel;


/**
 *  剩余油量 （%）
 */
@property (nonatomic, assign, readonly) CGFloat fuelLevel;


/**
 *  当前故障码个数
 */
@property (nonatomic, assign, readonly) NSUInteger faultCount;

#if USE_EST530

/**
 *  本次行驶里程 （km）
 */
@property (nonatomic, assign, readonly) CGFloat thisTimeDistance;

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

/**
 *  本次急转弯次数
 */
@property (nonatomic, assign, readonly) NSUInteger thisTimeSuddenTurnCount;

/**
 *  本次行驶时长，从发动机点火算起的秒数
 */
@property (nonatomic, assign) long currentDuration;

#endif

@end
