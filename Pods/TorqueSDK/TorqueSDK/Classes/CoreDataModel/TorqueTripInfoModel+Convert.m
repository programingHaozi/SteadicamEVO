//
//  TorqueTripInfoModel+Convert.m
//  TorqueSDK
//
//  Created by huxianchen on 15/3/10.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import "TorqueTripInfoModel+Convert.h"
#import "NSString+Date.h"
#import "TorqueGlobal.h"

@implementation TorqueTripInfoModel (Convert)


- (TorqueTripInfoModel *)transferByObject:(TorqueTripInfo *)info
{
    [self setDrivingFuel:@(info.drivingFuel)];
    [self setHotCarDuration:@(info.hotCarDuration)];
    [self setIdlingDuration:@(info.idlingDuration)];
    [self setIdlingFuel:@(info.idlingFuel)];
    [self setMileage:@(info.mileage)];
    [self setThisTimeMaxCarSpeed:@(info.thisTimeMaxCarSpeed)];
    //    debug模式 将recordid 赋值给最大转速 便于查看行程同步数据
//#ifdef DEBUG
//    [self setThisTimeMaxRotationSpeed:@(info.recordId)];
//#else
    [self setThisTimeMaxRotationSpeed:@(info.thisTimeMaxRotationSpeed)];
//#endif

    [self setThisTimeSuddenSeedUpCount:@(info.thisTimeSuddenSeedUpCount)];
    [self setThisTimeSuddenSpeedReduceCount:@(info.thisTimeSuddenSpeedReduceCount)];
    [self setThisTimeSuddenTurnCornerCount:@(info.thisTimeSuddenTurnCornerCount)];
    [self setTravelDuration:@(info.travelDuration)];
    [self setRecordId:@(info.recordId)];
    [self setAverageCarSpeed:@(info.averageCarSpeed)];
    
    [self setStartDate:[NSString dateFromString:info.startDate ForDateFormatter:kDateFormat]];
    [self setEndDate:[NSString dateFromString:info.endDate ForDateFormatter:kDateFormat]];
    
    [self setBaseObject];
    
    return self;
}

- (TorqueTripInfo *)transferToObject
{
    TorqueTripInfo *info = [TorqueTripInfo new];
    
    [info setValue:self.drivingFuel forKey:@"drivingFuel"];
    [info setValue:self.endDate forKey:@"endDate"];
    [info setValue:self.hotCarDuration forKey:@"hotCarDuration"];
    [info setValue:self.idlingDuration forKey:@"idlingDuration"];
    [info setValue:self.idlingFuel forKey:@"idlingFuel"];
    [info setValue:self.mileage forKey:@"mileage"];
    [info setValue:self.startDate forKey:@"startDate"];
    [info setValue:self.thisTimeMaxCarSpeed forKey:@"thisTimeMaxCarSpeed"];
    [info setValue:self.thisTimeMaxRotationSpeed forKey:@"thisTimeMaxRotationSpeed"];
    [info setValue:self.thisTimeSuddenSeedUpCount forKey:@"thisTimeSuddenSeedUpCount"];
    [info setValue:self.thisTimeSuddenSpeedReduceCount forKey:@"thisTimeSuddenSpeedReduceCount"];
    [info setValue:self.thisTimeSuddenTurnCornerCount forKey:@"thisTimeSuddenTurnCornerCount"];
    [info setValue:self.travelDuration forKey:@"travelDuration"];
    [info setValue:self.recordId forKey:@"recordId"];
    [info setValue:self.averageFuel forKey:@"averageFuel"];
    [info setValue:self.totalFuel forKey:@"totalFuel"];
    [info setValue:self.averageCarSpeed forKey:@"averageCarSpeed"];
    [info setValue:self.parkCount forKey:@"parkCount"];
    [info setValue:self.startCount forKey:@"startCount"];
    
    return info;
}

- (NSMutableDictionary *)transferToDict
{
    NSString *startDate = nil;
    NSString *endDate = nil;
    @try {
        startDate = [NSString stringFromDate:self.startDate ForDateFormatter:kDateFormat];
    }
    @catch (NSException *exception) {}
    @try {
        endDate = [NSString stringFromDate:self.endDate ForDateFormatter:kDateFormat];
    }
    @catch (NSException *exception) {}
    NSMutableDictionary *dict= [NSMutableDictionary new];

    [dict setValue:startDate ? startDate : @""  forKey:@"start_time"];
    [dict setValue:endDate ? endDate : @"" forKey:@"end_time"];
    [dict setValue:self.recordId forKey:@"id"];
    [dict setValue:self.sn forKey:@"sn"];
    [dict setValue:self.deviceId forKey:@"device_id"];
    [dict setValue:self.userId forKey:@"user_id"];
    [dict setValue:[TorqueGlobal sharedInstance].appId forKey:@"app_id"];
    //[dict setValue:@"111" forKey:@"car_id"];
    [dict setValue:self.hotCarDuration forKey:@"hot_time"];
    [dict setValue:self.idlingDuration forKey:@"idling_length"];
    [dict setValue:self.travelDuration forKey:@"trip_time"];
    [dict setValue:self.mileage forKey:@"mileage"];
    [dict setValue:self.idlingFuel forKey:@"idling_fuel"];
    [dict setValue:self.drivingFuel forKey:@"driving_fuel"];
    [dict setValue:self.thisTimeMaxRotationSpeed forKey:@"apex_engine_speed"];
    [dict setValue:self.thisTimeMaxCarSpeed forKey:@"apex_speed"];
    [dict setValue:self.thisTimeSuddenSeedUpCount forKey:@"hurried_speedup"];
    [dict setValue:self.thisTimeSuddenSpeedReduceCount forKey:@"hurried_brake"];
    [dict setValue:self.thisTimeSuddenTurnCornerCount forKey:@"hurried_change"];
    [dict setValue:self.vinCode forKey:@"vin_code"];
    
    return dict;
    
}

@end
