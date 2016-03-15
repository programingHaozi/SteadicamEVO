//
//  DeviceInfoModel+Convert.h
//  TorqueSDK
//
//  Created by huxianchen on 15/3/10.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import "DeviceInfoModel.h"
#import "DeviceInfo.h"

@interface DeviceInfoModel (Convert)

- (DeviceInfoModel *)transferByObject:(DeviceInfo *)info;

@end
