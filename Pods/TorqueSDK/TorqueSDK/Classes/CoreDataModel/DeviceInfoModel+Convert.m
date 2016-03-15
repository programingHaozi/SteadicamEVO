//
//  DeviceInfoModel+Convert.m
//  TorqueSDK
//
//  Created by huxianchen on 15/3/10.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import "DeviceInfoModel+Convert.h"

@implementation DeviceInfoModel (Convert)

- (DeviceInfoModel *)transferByObject:(DeviceInfo *)info
{
    [self setMode:[@(info.mode) copy]];
    [self setName:[info.name copy]];
    [self setPassword:[info.passwd copy]];
    [self setSn:[info.sn copy]];
    [self setDeviceId:[info.deviceId copy]];
    
    return self;
}

@end
