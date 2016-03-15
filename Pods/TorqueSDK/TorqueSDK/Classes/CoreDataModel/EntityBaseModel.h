//
//  EntityBaseModel.h
//  TorqueSDK
//
//  Created by sunxiaofei on 15/3/10.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EntityBaseModel : NSManagedObject

@property (nonatomic, assign) BOOL isUploaded;
@property (nonatomic, retain) NSString * sn;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * vinCode;
@property (nonatomic, retain) NSString * deviceId;

- (void)setBaseObject;

@end
