//
//  UserInfoModel.m
//  TFMVVMLib
//
//  Created by xiayiyong on 15/9/16.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFBaseUser.h"

#pragma mark -
#pragma mark - UserInfoModel
@implementation TFBaseUser

-(NSString *)mobile
{
    return _mobile==nil?@"":_mobile;
}

-(NSString *)token
{
    return _token==nil?@"":_token;
}

-(NSNumber *)userId
{
    return _userId==nil?@(0):_userId;
}

@end


