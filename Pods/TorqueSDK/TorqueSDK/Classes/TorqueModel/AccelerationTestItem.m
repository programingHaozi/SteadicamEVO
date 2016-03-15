//
//  AccelerationTestItem.m
//  TorqueSDK
//
//  Created by zhangjipeng on 2/1/15.
//  Copyright (c) 2015 chexiang. All rights reserved.
//

#import "AccelerationTestItem.h"

@implementation AccelerationTestItem

- (instancetype)initWithArray:(NSArray *)items {
    if (self = [super initWithArray:items]) {
        OBDDataItem *item = items[1];
        _rotationSpeed = item.value.integerValue;
        
        item = items[2];
        _carSpeed = item.value.floatValue;
        
        item = items[3];
        _duration = item.value.integerValue;
        
        item = items[4];
        _rpmDelay = item.value.integerValue;
        
        item = items[5];
        _carSpeedDelay = item.value.integerValue;
    }
    return self;
}

@end
