//
//  OBDPowerOn.m
//  TorqueSDK
//
//  Created by zhangjipeng on 2/9/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import "OBDPowerOn.h"
#import "NSString+Date.h"

@implementation OBDPowerOn

- (instancetype)initWithArray:(NSArray *)items {
    if (self = [super init]) {
        OBDDataItem *item = items[0];
        _reason = item.value.integerValue + 1;
        
        item = items[1];
        _date = [NSString dateFromString:item.value ForDateFormatter:nil];
    }
    return self;
}

@end
