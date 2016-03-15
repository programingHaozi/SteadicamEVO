//
//  UserInfoModel.h
//  TFMVVMLib
//
//  Created by xiayiyong on 15/9/16.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark -
#pragma mark - TFBaseUser

/**
 *  用户信息
 */
@interface TFBaseUser : NSObject

/**
 *  用户昵称
 */
@property (nonatomic,strong) NSString *nickName;

/**
 *  手机号码
 */
@property (nonatomic,strong) NSString *mobile;

/**
 * 用户姓名
 */
@property (nonatomic,strong) NSString *realName;

/**
 *  用户性别
 */
@property (nonatomic,strong) NSString *gender;

/**
 *  用户生日
 */
@property (nonatomic,strong) NSString *birthday;

/**
 *  用户id
 */
@property (nonatomic,strong) NSNumber *userId;

/**
 *  用户token
 */
@property (nonatomic,strong) NSString *token;

/**
 *  用户头像
 */
@property (nonatomic,strong) NSString *pttUrl;
/**
 *  邮箱
 */
@property (nonatomic,strong) NSString *email;

/**
 *  创建时间
 */
@property (nonatomic,strong) NSString *createdTime;

/**
 *  更新时间
 */
@property (nonatomic,strong) NSString *updatedTime;

/**
 *  年龄
 */
@property (nonatomic,strong) NSString *age;

/**
 *  称呼
 */
@property (nonatomic,strong) NSString *title;

/**
 *  用户类型
 */
@property (nonatomic,strong) NSString *userType;

@end

