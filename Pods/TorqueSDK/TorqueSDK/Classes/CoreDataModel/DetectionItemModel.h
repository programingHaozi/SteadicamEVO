//
//  DetectionItemModel.h
//  TorqueSDK
//
//  Created by sunxiaofei on 15/3/10.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DetectionItemModel : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * explain;

@end
