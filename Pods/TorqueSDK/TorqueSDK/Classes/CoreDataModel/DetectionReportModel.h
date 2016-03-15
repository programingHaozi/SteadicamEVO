//
//  DetectionReportModel.h
//  TorqueSDK
//
//  Created by sunxiaofei on 15/3/10.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "EntityBaseModel.h"

@class FaultCodeModel, PIDValueModel;

@interface DetectionReportModel : EntityBaseModel

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSSet *faultItems;
@property (nonatomic, retain) NSSet *pidItems;
@end

@interface DetectionReportModel (CoreDataGeneratedAccessors)

- (void)addFaultItemsObject:(FaultCodeModel *)value;
- (void)removeFaultItemsObject:(FaultCodeModel *)value;
- (void)addFaultItems:(NSSet *)values;
- (void)removeFaultItems:(NSSet *)values;

- (void)addPidItemsObject:(PIDValueModel *)value;
- (void)removePidItemsObject:(PIDValueModel *)value;
- (void)addPidItems:(NSSet *)values;
- (void)removePidItems:(NSSet *)values;

@end
