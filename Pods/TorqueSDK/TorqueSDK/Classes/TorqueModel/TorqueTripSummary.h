//
//  TripSummary.h
//  TorqueSDK
//
//  Created by sunxiaofei on 15/3/4.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  行程摘要对象
 */
@interface TorqueTripSummary : NSObject

/**
 *  首次行程时间
 */
@property (nonatomic,strong) NSString *firstStartTime;
/**
 *  最后一次行程时间
 */
@property (nonatomic,strong) NSString *lastStartTime;

/**
 *  总里程
 */
@property (nonatomic,assign) double totalMileage;

/**
 *  行驶里程
 */
@property (nonatomic,assign) double runMileage;

/**
 *  行驶时长
 */
@property (nonatomic,assign) NSInteger totaleTripTime;

/**
 *  行程次数
 */
@property (nonatomic,assign) NSInteger tripCount;

/**
 *  最高车速
 */
@property (nonatomic,assign) NSInteger maxSpeed;

/**
 *  最高转速
 */
@property (nonatomic,assign) double maxEngineSpeed;

/**
 *  总油耗
 */
@property (nonatomic,assign) double totalFuelCons;

/**
 *  平均油耗
 */
@property (nonatomic,assign) double avgAverageFuelCons;

/**
 *  平均车速
 */
@property (nonatomic,assign) double avgAverageSpeed;

@end

///**
// *  行程摘要查询对象
// */
//@interface TorqueTripSummaryQueryModel : NSObject
//
///**
// *  用户ID
// */
//@property (nonatomic, strong) NSString *userId;
//
///**
// *  汽车vin码
// */
//@property (nonatomic, strong) NSString *vinCode;
///**
// *  开始时间
// */
//@property (nonatomic, strong) NSDate *from;
///**
// *  结束时间
// */
//@property (nonatomic, strong) NSDate *to;
//
//@end
