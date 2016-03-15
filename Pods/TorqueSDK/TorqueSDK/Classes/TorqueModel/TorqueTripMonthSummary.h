//
//  TorqueTripMonthSummary.h
//  TorqueSDK
//
//  Created by Chen Hao 陈浩 on 15/6/17.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TorqueTripInfo.h"
#import "TorqueTripSummary.h"


@interface TorqueTripMonthSummary : NSObject

/**
 *  行程月份
 */
@property (nonatomic, strong, readonly) NSString *month;

/**
 *  月份行程摘要
 */
@property (nonatomic, strong, readonly) TorqueTripSummary *totalArray;

/**
 *  每日行程
 */
@property (nonatomic, strong, readonly) NSArray *daysArray;
@end
