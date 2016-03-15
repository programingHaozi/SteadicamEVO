//
//  UserInfoModel+Convert.h
//  TorqueSDK
//
//  Created by huxianchen on 15/3/10.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import "UserInfoModel.h"
#import "UserInfo.h"

@interface UserInfoModel (Convert)

- (UserInfoModel *)transferByObject:(UserInfo *)info;

@end
