//
//  TorqueTripInfoModel.h
//  TorqueSDK
//
//  Created by huxianchen on 15/3/10.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "EntityBaseModel.h"

@interface TorqueTripInfoModel : EntityBaseModel

@property (nonatomic, retain) NSNumber * drivingFuel;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSNumber * hotCarDuration;
@property (nonatomic, retain) NSNumber * idlingDuration;
@property (nonatomic, retain) NSNumber * idlingFuel;
@property (nonatomic, retain) NSNumber * mileage;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSNumber * thisTimeMaxCarSpeed;
@property (nonatomic, retain) NSNumber * thisTimeMaxRotationSpeed;
@property (nonatomic, retain) NSNumber * thisTimeSuddenSeedUpCount;
@property (nonatomic, retain) NSNumber * thisTimeSuddenSpeedReduceCount;
@property (nonatomic, retain) NSNumber * thisTimeSuddenTurnCornerCount;
@property (nonatomic, retain) NSNumber * travelDuration;
@property (nonatomic, retain) NSNumber * recordId;
@property (nonatomic, retain) NSNumber * averageFuel;
@property (nonatomic, retain) NSNumber * totalFuel;
@property (nonatomic, retain) NSNumber * averageCarSpeed;
@property (nonatomic, retain) NSNumber * parkCount;
@property (nonatomic, retain) NSNumber * startCount;


@end
