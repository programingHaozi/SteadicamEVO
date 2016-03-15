//
//  TorqueTripInfo.h
//  TorqueSDK
//
//  Created by zhangjipeng on 2/13/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import "TorqueData.h"

@interface TorqueTripInfo : TorqueData

/**
 *  行程记录号，唯一
 */
@property (nonatomic, assign, readonly) long recordId;

/**
 *  行程开始日期时间
 */
@property (nonatomic, strong) NSString *startDate;

/**
 *  行程结束日期时间
 */
@property (nonatomic, strong, readonly) NSString *endDate;

/**
 *  当次热车时长 （s）
 */
@property (nonatomic, assign, readonly) NSUInteger hotCarDuration;

/**
 *  本次怠速时长 （min->s）
 */
@property (nonatomic, assign, readonly) float idlingDuration;

/**
 *  本次行驶时长 （min->s）
 */
@property (nonatomic, assign, readonly) float travelDuration;

/**
 *  本次行驶里程 （km）
 */
@property (nonatomic, assign, readonly) float mileage;

/**
 *  本次怠速耗油 （L）
 */
@property (nonatomic, assign, readonly) float idlingFuel;

/**
 *  本次行驶耗油 （L）
 */
@property (nonatomic, assign, readonly) float drivingFuel;

/**
 *  平均油耗 （L）
 */
@property (nonatomic, assign, readonly) float averageFuel;
/**
 *  总油耗 （L）
 */
@property (nonatomic, assign, readonly) float totalFuel;

/**
 *  本次最高转速 （rpm）
 */
@property (nonatomic, assign, readonly) NSUInteger thisTimeMaxRotationSpeed;

/**
 *  本次最高车速 （km/h）
 */
@property (nonatomic, assign, readonly) float thisTimeMaxCarSpeed;

/**
 *  平均车速 （km/h）
 */
@property (nonatomic, assign, readonly) float averageCarSpeed;

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
@property (nonatomic, assign, readonly) NSUInteger thisTimeSuddenTurnCornerCount;

///**
// *  停车次数
// */
//@property (nonatomic, assign, readonly) NSUInteger parkCount;
//
/**
 *  点火次数
 */
@property (nonatomic, assign, readonly) NSUInteger startCount;

@end
