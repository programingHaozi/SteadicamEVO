//
//  FaultCodeModel.h
//  TorqueSDK
//
//  Created by sunxiaofei on 15/3/10.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DetectionItemModel.h"

@class DetectionReportModel;

@interface FaultCodeModel : DetectionItemModel

@property (nonatomic, retain) DetectionReportModel *detectionReport;

@end
