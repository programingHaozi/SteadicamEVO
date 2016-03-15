//
//  DeviceInfoModel.h
//  TorqueSDK
//
//  Created by sunxiaofei on 15/3/10.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TorqueContextModel, UserInfoModel;

@interface DeviceInfoModel : NSManagedObject

@property (nonatomic, retain) NSNumber * mode;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * sn;
@property (nonatomic, retain) NSString * deviceId;
@property (nonatomic, retain) UserInfoModel *userInfo;
@property (nonatomic, retain) TorqueContextModel *torqueContext;

@end
