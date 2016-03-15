//
//  EntityBaseModel.m
//  TorqueSDK
//
//  Created by sunxiaofei on 15/3/10.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import "EntityBaseModel.h"
#import "TorqueGlobal.h"

@implementation EntityBaseModel

@dynamic isUploaded;
@dynamic sn;
@dynamic userId;
@dynamic vinCode;
@dynamic deviceId;

- (void)setBaseObject {
    [self setIsUploaded:NO];
    [self setSn:[TorqueGlobal sharedInstance].deviceInfo.sn];
    [self setUserId:[TorqueGlobal sharedInstance].user.userId];
    [self setVinCode:[TorqueGlobal sharedInstance].carInfo.vinCode];
    [self setDeviceId:[TorqueGlobal sharedInstance].deviceInfo.deviceId];
}

@end
