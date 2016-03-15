//
//  UserInfoModel+Convert.m
//  TorqueSDK
//
//  Created by huxianchen on 15/3/10.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import "UserInfoModel+Convert.h"

@implementation UserInfoModel (Convert)


- (UserInfoModel *)transferByObject:(UserInfo *)info
{
    [self setUserId:info.userId];
    [self setPhoneNumber:info.phoneNumber];
    
    return self;
}

@end
