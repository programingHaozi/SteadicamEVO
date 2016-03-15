//
//  AccelerationTestItemModel.h
//  TorqueSDK
//
//  Created by sunxiaofei on 15/3/10.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AccelerationTestModel;

@interface AccelerationTestItemModel : NSManagedObject

@property (nonatomic, retain) NSNumber * carSpeed;
@property (nonatomic, retain) NSNumber * carSpeedDelay;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSNumber * rotationSpeed;
@property (nonatomic, retain) NSNumber * rpmDelay;
@property (nonatomic, retain) AccelerationTestModel *test;

@end
