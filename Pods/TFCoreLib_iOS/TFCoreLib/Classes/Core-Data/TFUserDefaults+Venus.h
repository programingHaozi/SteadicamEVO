//
//  TFUserDefaults+Venus.h
//  TFCoreLib
//
//  Created by xiayiyong on 15/10/14.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFUserDefaults.h"
#import "TFBaseUser.h"

@interface TFUserDefaults (Venus)

/**
 *  用户id
 */
@property (nonatomic, strong) NSString *clientId;

/**
 *  用户信息
 */
@property (nonatomic, strong) TFBaseUser *userInfo;

@end
