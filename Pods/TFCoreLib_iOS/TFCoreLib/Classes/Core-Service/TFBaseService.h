//
//  TFBaseService+Device.h
//  Treasure
//
//  Created by xiayiyong on 15/8/20.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFBaseService.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TFURLManager.h"
#import "TFCoreUtil.h"
#import "TFBaseLib.h"

@interface RegDeviceReq : NSObject
@end

@interface UnRegDeviceReq : NSObject
@end

@interface LoginReq : NSObject
/**
 *  账号(手机号码)
 */
@property (strong, nonatomic) NSString* account;

/**
 *  密码
 */
@property (strong, nonatomic) NSString* password;

@end

@interface LogoutReq : NSObject
@end

@interface RegUserReq : NSObject
/**
 *  账号(手机号码)
 */
@property (strong, nonatomic) NSString* account;

/**
 *  密码
 */
@property (strong, nonatomic) NSString* password;

/**
 *  短信验证码
 */
@property (strong, nonatomic) NSString* SMSCode;

/**
 *  注册来源的应用ID 1电商主站应用，默认传0
 */
@property (strong, nonatomic) NSString* userType;

@end

@interface ResetPwdReq : NSObject
/**
 *  账号(手机号码)
 */
@property (strong, nonatomic) NSString* account;

/**
 *  密码
 */
@property (strong, nonatomic) NSString* password;

/**
 *  短信验证码
 */
@property (strong, nonatomic) NSString* SMSCode;

@end

@interface UpdatePwdReq : NSObject
/**
 *  旧密码
 */
@property (strong, nonatomic) NSString* oldPwd;

/**
 *  新密码
 */
@property (strong, nonatomic) NSString* tnewPwd;

@end

@interface GetSmsCodeReq : NSObject
/**
 *  账号(手机号码)
 */
@property (strong, nonatomic) NSString* account;

/**
 *  验证码类型
 */
@property (assign, nonatomic) SMSCodeType type;
@end


@interface QuickLoginReq : NSObject
/**
 *  账号(手机号码)
 */
@property (strong, nonatomic) NSString* account;

/**
 *  验证码
 */
@property (strong, nonatomic) NSString* SMSCode;
@end


@interface TFBaseService: NSObject

/**
 *
 *
 *  @param req
 *  @param successBlock
 *  @param failureBlock
 *
 *  @return
 参数:
 userId - 用户ID
 deviceId - 硬件编码
 deviceInfo - 硬件信息
 appCode - 应用编码
 appVersion - 应用版本号
 plateform - 平台
 plateformVersion - 平台版本号
 source - 软件来源渠道，表示客户是从什么地方下载的软件
 返回:
 clientId
 */
+ (NSURLSessionDataTask *)regDeviceWithParameter:(RegDeviceReq*)req
                                         success:(void (^)(NSString *clientId))successBlock
                                         failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock;

/**
 *
 *
 *  @param req
 *  @param successBlock
 *  @param failureBlock
 *
 *  @return
 参数:
 userId - 用户ID
 deviceId - 硬件编码
 deviceInfo - 硬件信息
 appCode - 应用编码
 appVersion - 应用版本号
 plateform - 平台
 plateformVersion - 平台版本号
 source - 软件来源渠道，表示客户是从什么地方下载的软件
 返回:
 clientId
 
 */
+ (NSURLSessionDataTask *)unregDeviceWithParameter:(UnRegDeviceReq*)req
                                           success:(void (^)(NSString *clientId))successBlock
                                           failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock;

/**
 *  用户注册
 *
 *  @param req
 *  @param successBlock
 *  @param failureBlock
 *
 *  @return
 clientId -
 account用户名 -
 password密码 -
 captcha验证码 -
 accountType账号类型 - ，1：用户名2：手机 3：邮箱
 userType - 注册来源的应用ID 1电商主站应用，默认传0
 createType - 注册来源：1：网站2：手机3:手机快速注册 4:保养管家
 securityType用户密码安全级别 - 1：高2：中3：低
 authURL验证激活URL - ，用于邮箱注册，手机 和用户名注册不用填写
 */
+ (NSURLSessionDataTask *)regUserWithParameter:(RegUserReq*)req
                                       success:(void (^)(TFBaseUser *model))successBlock
                                       failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock;

/**
 *  登陆
 *
 *  @param req
 *  @param successBlock
 *  @param failureBlock
 *
 clientId -
 account用户名 -
 password密码 -
 captcha验证码 -
 accountType账号类型 - ，1：用户名2：手机 3：邮箱
 userType - 注册来源的应用ID 1电商主站应用，默认传0
 createType - 注册来源：1：网站2：手机3:手机快速注册 4:保养管家
 securityType用户密码安全级别 - 1：高2：中3：低
 authURL验证激活URL - ，用于邮箱注册，手机 和用户名注册不用填写
 */
+ (NSURLSessionDataTask *)loginWithParameter:(LoginReq*)req
                                     success:(void (^)(TFBaseUser *model))successBlock
                                     failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock;

/**
 *  注销
 *
 *  @param req
 *  @param successBlock
 *  @param failureBlock
 *
 *  @return
 clientId -
 token -
 */
+ (NSURLSessionDataTask *)logoutWithParameter:(LogoutReq*)req
                                      success:(void (^)(void))successBlock
                                      failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock;


/**
 *  重设密码
 *
 *  @param req
 *  @param successBlock
 *  @param failureBlock
 *
 clientId -
 account - 手机号码
 password新密码 -
 captcha验证码 -
 securityType密码安全级别 -
 token - 登陆时返回的令牌信息
 */
+ (NSURLSessionDataTask *)resetPwdWithParameter:(ResetPwdReq*)req
                                        success:(void (^)(void))successBlock
                                        failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock;

/**
 *  修改密码
 *
 *  @param req
 *  @param successBlock
 *  @param failureBlock
 *
 *  @return
 clientId -
 userId - 用户ID
 userType - 注册来源的应用ID 1电商主站应用，默认传0
 oldPwd旧密码 -
 newPwd新密码 -
 securityType用户密码安全级别 - 1：高2：中3：低
 token - 登陆时返回的令牌信息
 */
+ (NSURLSessionDataTask *)updatePwdWithParameter:(UpdatePwdReq*)req
                                         success:(void (^)(void))successBlock
                                         failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock;

/**
 *  获取验证码
 *
 *  @param req
 *  @param successBlock
 *  @param failureBlock
 *
 *  @return
 account - 账户名
 type - 操作类型
 appCode - 应用Id
 accountType - 账号类型。1为用户名2：手机3邮箱
 */
+ (NSURLSessionDataTask *)getSmsCodeWithParameter:(GetSmsCodeReq*)req
                                          success:(void (^)(void))successBlock
                                          failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock;

/**
 *  用户快速登录
 *
 *  @param req
 *  @param successBlock
 *  @param failureBlock
 *
 *  @return
 clientId -
 account用户名 -
 password密码 -
 captcha验证码 -
 accountType账号类型 - ，1：用户名2：手机 3：邮箱
 userType - 注册来源的应用ID 1电商主站应用，默认传0
 createType - 注册来源：1：网站2：手机3:手机快速注册 4:保养管家
 securityType用户密码安全级别 - 1：高2：中3：低
 authURL验证激活URL - ，用于邮箱注册，手机 和用户名注册不用填写
 */
+ (NSURLSessionDataTask *)quickLoginWithParameter:(QuickLoginReq*)req
                                          success:(void (^)(TFBaseUser *model))successBlock
                                          failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock;


/**
 *  获取快捷登录验证码
 *
 *  @param req
 *  @param successBlock
 *  @param failureBlock
 *
 *  @return
 account - 账户名
 type - 操作类型
 appCode - 应用Id
 accountType - 账号类型。1为用户名 2：手机 3邮箱
 */
+ (NSURLSessionDataTask *)getQuickSmsCodeWithParameter:(GetSmsCodeReq*)req
                                               success:(void (^)(void))successBlock
                                               failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock;



@end
