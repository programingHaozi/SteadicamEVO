//
//  TorqueTripInfo.m
//  TorqueSDK
//
//  Created by zhangjipeng on 2/13/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import "TorqueTripInfo.h"
#import "OBDDataStream.h"
#import "OBDDataItem.h"
#import "NSString+Date.h"

@implementation TorqueTripInfo

- (instancetype)initWithArray:(NSArray *)items {
    if (self = [super init]) {
        OBDDataItem *item = items[0];
        _recordId = item.value.integerValue;
        
        item = items[1];
        _startDate = item.value;// [NSString dateFromString:item.value ForDateFormatter:nil];
        
        item = items[2];
        _endDate = item.value;// [NSString dateFromString:item.value ForDateFormatter:nil];
        
        item = items[3];
        _hotCarDuration = item.value.integerValue;
        
        item = items[4];
        _idlingDuration = item.value.floatValue*60;
        
        item = items[5];
        _travelDuration = item.value.floatValue*60;
        
        item = items[6];
        _mileage = item.value.floatValue;
        
        item = items[7];
        _idlingFuel = item.value.floatValue;
        
        item = items[8];
        _drivingFuel = item.value.floatValue;
        
        item = items[9];
        _thisTimeMaxRotationSpeed = item.value.integerValue;
        
        item = items[10];
        _thisTimeMaxCarSpeed = item.value.floatValue;
        
        item = items[11];
        _thisTimeSuddenSeedUpCount = item.value.integerValue;
        
        item = items[12];
        _thisTimeSuddenSpeedReduceCount = item.value.integerValue;
        
        item = items[13];
        _thisTimeSuddenTurnCornerCount = item.value.integerValue;
    }
    return self;
}

@end
