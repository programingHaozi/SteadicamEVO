//
//  AccTestResult.h
//  TorqueSDK
//
//  Created by zhangjipeng on 6/10/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccelerationTestItem.h"

@interface AccTestResult : NSObject

@property (nonatomic, assign) NSUInteger userId;
@property (nonatomic, assign) NSUInteger deviceId;
@property (nonatomic, assign) NSUInteger carId;
@property (nonatomic, assign) NSUInteger useTime;  // ms
@property (nonatomic, assign) BOOL result;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSString *itemsString;

@end
