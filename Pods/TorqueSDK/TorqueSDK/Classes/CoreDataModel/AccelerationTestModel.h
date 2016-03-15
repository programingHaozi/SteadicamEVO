//
//  AccelerationTestModel.h
//  TorqueSDK
//
//  Created by sunxiaofei on 15/3/10.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "EntityBaseModel.h"

@class AccelerationTestItemModel;

@interface AccelerationTestModel : EntityBaseModel

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSSet *dataItems;
@end

@interface AccelerationTestModel (CoreDataGeneratedAccessors)

- (void)addDataItemsObject:(AccelerationTestItemModel *)value;
- (void)removeDataItemsObject:(AccelerationTestItemModel *)value;
- (void)addDataItems:(NSSet *)values;
- (void)removeDataItems:(NSSet *)values;

@end
