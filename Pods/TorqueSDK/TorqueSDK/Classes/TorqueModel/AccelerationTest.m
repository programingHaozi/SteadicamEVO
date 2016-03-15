//
//  AccelerationTest.m
//  TorqueSDK
//
//  Created by zhangjipeng on 2/1/15.
//  Copyright (c) 2015 chexiang. All rights reserved.
//

#import "AccelerationTest.h"

@implementation AccelerationTest

- (instancetype)initWithArray:(NSArray *)items {
    if (self = [super init]) {
        
        OBDDataItem *item = items[0];
        _date = item.value;
    }
    return self;
}

@end
