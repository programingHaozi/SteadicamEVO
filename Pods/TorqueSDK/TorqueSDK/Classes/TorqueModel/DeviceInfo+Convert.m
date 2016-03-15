//
//  DeviceInfo+Convert.m
//  TorqueSDK
//
//  Created by huxianchen on 15/3/13.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import "DeviceInfo+Convert.h"
#import "UserInfoModel.h"

@implementation DeviceInfo (Convert)

- (DeviceInfo *)transferByModel:(DeviceInfoModel*)model
{
    self.userId = model.userInfo ? model.userInfo.userId : nil;
    self.sn = model.sn;
    self.passwd = model.password;
    self.name = model.name;
    self.deviceId = model.deviceId;
    
    return self;
}

@end
