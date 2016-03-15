//
//  WorkStatus.m
//  TorqueSDK
//
//  Created by zhangjipeng on 1/29/15.
//  Copyright (c) 2015 chexiang. All rights reserved.
//

#import "WorkStatus.h"
#import "OBDDataStream.h"
#import "OBDDataItem.h"

@implementation WorkStatus

- (instancetype)initWithArray:(NSArray *)items {
    if (self = [super init]) {
        
//        判断items是否有值
        if (items) {
            OBDDataItem *item = items[0];
            _batteryVoltage = item.value.floatValue;
            
            item = items[1];
            _rotationSpeed = item.value.integerValue;
            
            item = items[2];
            _carSpeed = item.value.floatValue;
            
            item = items[3];
            _throttlePosition = item.value.floatValue;
            
            item = items[4];
            _engineLoad = item.value.floatValue;
            
            item = items[5];
            _coolantTemperature = item.value.floatValue;
            
            item = items[6];
            _instantFuel = item.value.floatValue;
            
            item = items[7];
            _averageFuel = item.value.floatValue;
            
#if USE_EST527
            item = items[8];
            _fuelLevel = item.value.floatValue;
            
            item = items[9];
            _faultCount = item.value.integerValue;
            
#elif USE_EST530
            item = items[8];
            _thisTimeDistance = item.value.floatValue;
            
            item = items[9];
            _totalDistance = item.value.floatValue;
            
            item = items[10];
            _thisTimeFuel = item.value.floatValue;
            
            item = items[11];
            _accumulateFuel = item.value.floatValue;
            
            item = items[12];
            _faultCount = item.value.integerValue;
            
            item = items[13];
            _thisTimeSuddenSeedUpCount = item.value.integerValue;
            
            item = items[14];
            _thisTimeSuddenSpeedReduceCount = item.value.integerValue;
            
            item = items[15];
            _thisTimeSuddenTurnCount = item.value.integerValue;
            
            item = items[16];
            _fuelLevel = item.value.floatValue;
#endif
        }
    }
    return self;
}

@end
