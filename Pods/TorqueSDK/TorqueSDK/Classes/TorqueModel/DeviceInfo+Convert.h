//
//  DeviceInfo+Convert.h
//  TorqueSDK
//
//  Created by huxianchen on 15/3/13.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import "DeviceInfo.h"
#import "DeviceInfoModel.h"

@interface DeviceInfo (Convert)

- (DeviceInfo *)transferByModel:(DeviceInfoModel*)model;

@end
