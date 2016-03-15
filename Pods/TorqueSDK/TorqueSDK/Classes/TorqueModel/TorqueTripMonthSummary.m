//
//  TorqueTripMonthSummary.m
//  TorqueSDK
//
//  Created by Chen Hao 陈浩 on 15/6/17.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import "TorqueTripMonthSummary.h"

@implementation TorqueTripMonthSummary
- (id)proxyForJson {
    return @{@"monthTripSummary" : _totalArray,
             @"daylyTripInfo" : _daysArray};
}
@end

