//
//  TFBaseService+Device.m
//  Treasure
//
//  Created by xiayiyong on 15/8/20.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFBaseService.h"
#import "TFVenusHTTPRequestManager.h"

@implementation RegDeviceReq
@end

@implementation UnRegDeviceReq
@end

@implementation LoginReq
@end

@implementation LogoutReq
@end

@implementation RegUserReq
@end

@implementation ResetPwdReq
@end

@implementation UpdatePwdReq
@end

@implementation GetSmsCodeReq
@end

@implementation QuickLoginReq
@end

@implementation TFBaseService

+ (NSURLSessionDataTask *)regDeviceWithParameter:(RegDeviceReq*)req
                                         success:(void (^)(NSString *clientId))successBlock
                                         failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock
{
    NSString *clientId = tf_getClientId();
    if(clientId!=nil&&clientId.length>0)
    {
        if (successBlock)
        {
            successBlock(clientId);
        }
        return nil;
    }
    
    NSDictionary *requestDic = @{
                                 @"userId" : tf_getUserId(),
                                 @"deviceId" : tf_getDeviceId(),
                                 @"deviceInfo" : tf_getDeviceInfo(),
                                 @"appCode" : tf_getAppCode(),
                                 @"appVersion" : tf_getAPPVersion(),
                                 @"plateform" : tf_getPlateformType(),
                                 @"plateformVersion" : tf_getSystemVersion(),
                                 @"source" : tf_getSourceCode(),
                                 };
    
    NSURLSessionDataTask *operation =[TFVenusHTTPRequestManager
                                      doTaskWithURL:kTFURLManager.regDevice_url
                                      parameters:requestDic
                                      success:^(id data)
                                      {
                                          NSLog(@"regDevice success");
                                          
                                          kTFUserDefaults.clientId=data;
                                          
                                          if (successBlock)
                                          {
                                              successBlock(data);
                                          }
                                      }
                                      failure:^(int errorCode, NSString *errorMessage)
                                      {
                                          NSLog(@"regDevice failure");
                                          
                                          if (failureBlock)
                                          {
                                              failureBlock(errorCode, errorMessage);
                                          }
                                      }
                                      error:^(NSError *error)
                                      {
                                          
                                      }];
    
    return operation;
}

+ (NSURLSessionDataTask *)unregDeviceWithParameter:(RegDeviceReq*)req
                                           success:(void (^)(NSString *clientId))successBlock
                                           failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock
{
    NSDictionary *requestDic = @{
                                 @"userId" : tf_getUserId(),
                                 @"deviceId" : tf_getDeviceId(),
                                 @"deviceInfo" : tf_getDeviceInfo(),
                                 @"appCode" : tf_getAppCode(),
                                 @"appVersion" : tf_getAPPVersion(),
                                 @"plateform" : tf_getPlateformType(),
                                 @"plateformVersion" : tf_getSystemVersion(),
                                 @"source" : tf_getSourceCode(),
                                 };
    
    NSURLSessionDataTask *operation =[TFVenusHTTPRequestManager
                                      doTaskWithURL:kTFURLManager.unregDevice_url
                                      parameters:requestDic
                                      success:^(id data)
                                      {
                                          NSLog(@"unregDevice success");
                                          
                                          if (successBlock)
                                          {
                                              successBlock(data);
                                          }
                                      }
                                      failure:^(int errorCode, NSString *errorMessage)
                                      {
                                          if (failureBlock)
                                          {
                                              failureBlock(errorCode, errorMessage);
                                          }
                                      }
                                      error:^(NSError *error)
                                      {
                                          
                                      }];
    
    return operation;
}

+ (NSURLSessionDataTask *)regUserWithParameter:(RegUserReq*)req
                                       success:(void (^)(TFBaseUser *model))successBlock
                                       failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock
{
    NSDictionary *requestDic = @{
                                 @"clientId":tf_getClientId(),
                                 @"account" : req.account,
                                 @"password" : tf_md5(req.password),
                                 @"captcha" : req.SMSCode,        //验证码
                                 @"accountType"  : @"2",       //账号类型 1：用户名2：手机 3：邮箱
                                 @"userType"     : req.userType,      //注册来源的应用ID 1电商主站应用，默认传0
                                 @"createType"   : @"2",       // 注册来源：1：网站2：手机3:手机快速注册4:保养管家
                                 @"securityType" : tf_levelOfPassword(req.password),  //用户密码安全级别1：高2：中3：低
                                 @"authURL"      : @"" //authURL验证激活URL，用于邮箱注册，手机 和用户名注册不用填写
                                 };
    
    NSURLSessionDataTask *operation =[TFVenusHTTPRequestManager
                                      doTaskWithURL:kTFURLManager.regUser_url
                                      parameters:requestDic
                                      success:^(id data)
                                      {
                                          TFBaseUser *userInfo= [TFBaseUser mj_objectWithKeyValues:data];
                                          kTFUserDefaults.userInfo=userInfo;
                                          if (successBlock)
                                          {
                                              successBlock(userInfo);
                                          }
                                      }
                                      failure:^(int errorCode, NSString *errorMessage)
                                      {
                                          if (failureBlock)
                                          {
                                              failureBlock(errorCode, errorMessage);
                                          }
                                      }
                                      error:^(NSError *error)
                                      {
                                          
                                      }];
    
    return operation;
}

+ (NSURLSessionDataTask *)loginWithParameter:(LoginReq*)req
                                     success:(void (^)(TFBaseUser *model))successBlock
                                     failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock
{
    NSURLSessionDataTask *operation =[TFVenusHTTPRequestManager
                                      doTaskWithURL:kTFURLManager.login_url
                                      parameters:@{
                                                   @"clientId":tf_getClientId(),
                                                   @"account":req.account,
                                                   @"password":tf_md5(req.password)
                                                   }
                                      success:^(id data)
                                      {
                                          TFBaseUser *userInfo= [TFBaseUser mj_objectWithKeyValues:data];
                                          kTFUserDefaults.userInfo=userInfo;
                                          
                                          if (successBlock)
                                          {
                                              successBlock(userInfo);
                                          }
                                      }
                                      failure:^(int errorCode, NSString *errorMessage)
                                      {
                                          if (failureBlock)
                                          {
                                              failureBlock(errorCode, errorMessage);
                                          }
                                      }
                                      error:^(NSError *error)
                                      {
                                          
                                      }];
    
    return operation;
}

+ (NSURLSessionDataTask *)logoutWithParameter:(LogoutReq*)req
                                      success:(void (^)(void))successBlock
                                      failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock
{
    
    NSURLSessionDataTask *operation =[TFVenusHTTPRequestManager
                                      doTaskWithURL:kTFURLManager.logout_url
                                      parameters:@{
                                                   @"clientId":tf_getClientId(),
                                                   @"token":tf_getUserToken(),
                                                   }
                                      success:^(id data)
                                      {
                                          if (successBlock)
                                          {
                                              successBlock();
                                          }
                                      }
                                      failure:^(int errorCode, NSString *errorMessage)
                                      {
                                          if (failureBlock)
                                          {
                                              failureBlock(errorCode, errorMessage);
                                          }
                                      }
                                      error:^(NSError *error)
                                      {
                                          
                                      }];
    
    return operation;
}

+ (NSURLSessionDataTask *)resetPwdWithParameter:(ResetPwdReq*)req
                                        success:(void (^)(void))successBlock
                                        failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock
{
    NSDictionary *requestDic = @{
                                 @"clientId":tf_getClientId(),
                                 @"account" : req.account,
                                 @"password" : tf_md5(req.password),
                                 @"captcha" : req.SMSCode,
                                 @"securityType" : tf_levelOfPassword(req.password),  //用户密码安全级别1：高2：中3：低
                                 @"token" : tf_getUserToken()
                                 };
    
    NSURLSessionDataTask *operation =[TFVenusHTTPRequestManager
                                      doTaskWithURL:kTFURLManager.resetPwd_url
                                      parameters:requestDic
                                      success:^(id data)
                                      {
                                          if (successBlock)
                                          {
                                              successBlock();
                                          }
                                      }
                                      failure:^(int errorCode, NSString *errorMessage)
                                      {
                                          if (failureBlock)
                                          {
                                              failureBlock(errorCode, errorMessage);
                                          }
                                      }
                                      error:^(NSError *error)
                                      {
                                          
                                      }];
    
    return operation;
}

/**
 *  修改密码
 *
 *  @param oldPwd
 *  @param newPwd
 *
 *  @return
 */
+ (NSURLSessionDataTask *)updatePwdWithParameter:(UpdatePwdReq*)req
                                         success:(void (^)(void))successBlock
                                         failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock
{
    NSDictionary *parameters = @{
                                 @"clientId":tf_getClientId(),
                                 @"userId":tf_getUserId(),
                                 @"userType"  : @"0",       //注册来源的应用ID 1电商主站应用，默认传0
                                 @"oldPwd":tf_md5(req.oldPwd),
                                 @"newPwd":tf_md5(req.tnewPwd),
                                 @"securityType" : tf_levelOfPassword(req.tnewPwd),  //用户密码安全级别1：高2：中3：低
                                 @"token":tf_getUserToken(),
                                 };
    
    NSURLSessionDataTask *operation = [TFVenusHTTPRequestManager
                                       doTaskWithURL:kTFURLManager.updateUserPwd_url
                                       parameters:parameters
                                       success:^(id data)
                                       {
                                           if (successBlock)
                                           {
                                               successBlock();
                                           }
                                       }
                                       failure:^(int errorCode, NSString *errorMessage)
                                       {
                                           if (failureBlock)
                                           {
                                               failureBlock(errorCode, errorMessage);
                                           }
                                       }
                                       error:^(NSError *error)
                                       {
                                           
                                       }];
    
    return operation;
}

+ (NSURLSessionDataTask *)getSmsCodeWithParameter:(GetSmsCodeReq*)req
                                          success:(void (^)(void))successBlock
                                          failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock
{
    NSDictionary *parameters = @{
                                 @"account" : req.account,
                                 @"type" : [NSString stringWithFormat:@"%ld",(long)req.type],
                                 @"appCode" : tf_getAppCode(),
                                 @"accountType" : @"2"  //账号类型 1：用户名2：手机 3：邮箱
                                 };
    
    NSURLSessionDataTask *operation = [TFVenusHTTPRequestManager
                                       doTaskWithURL:kTFURLManager.getSMSCode_url
                                       parameters:parameters
                                       success:^(id data)
                                       {
                                           if (successBlock)
                                           {
                                               successBlock();
                                           }
                                       }
                                       failure:^(int errorCode, NSString *errorMessage)
                                       {
                                           if (failureBlock)
                                           {
                                               failureBlock(errorCode, errorMessage);
                                           }
                                       }
                                       error:^(NSError *error)
                                       {
                                           
                                       }];
    
    return operation;
}


+ (NSURLSessionDataTask *)quickLoginWithParameter:(QuickLoginReq *)req success:(void (^)(TFBaseUser *))successBlock failure:(void (^)(int, NSString *))failureBlock
{
    NSDictionary *requestDic = @{
                                 @"clientId":tf_getClientId(),
                                 @"account" : req.account,
                                 @"captcha" : req.SMSCode,    //验证码
                                 @"userType":@"0"        ,    //车享宝(0)
                                 @"createType":@"3"      ,    //1：网站 2：手机 3:手机快速注册 4：保养管家
                                 @"securityType":@"3"    ,    //1：高2：中3：低
                                 @"accountType": @"2"    ,    //1：用户名2：手机 3：网站
                                 @"appCode":@(2)   //车享宝 = 2
                                 };
    
    NSURLSessionDataTask *operation =[TFVenusHTTPRequestManager
                                      doTaskWithURL:kTFURLManager.quickLogin_url
                                      parameters:requestDic
                                      success:^(id data)
                                      {
                                          TFBaseUser *userInfo= [TFBaseUser mj_objectWithKeyValues:data];
                                          kTFUserDefaults.userInfo=userInfo;
                                          if (successBlock)
                                          {
                                              successBlock(userInfo);
                                          }
                                      }
                                      failure:^(int errorCode, NSString *errorMessage)
                                      {
                                          if (failureBlock)
                                          {
                                              failureBlock(errorCode, errorMessage);
                                          }
                                      }
                                      error:^(NSError *error)
                                      {
                                          
                                      }];
    
    return operation;
}

+ (NSURLSessionDataTask *)getQuickSmsCodeWithParameter:(GetSmsCodeReq*)req
                                          success:(void (^)(void))successBlock
                                          failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock
{
    NSDictionary *parameters = @{
                                 @"account" : req.account,
                                 @"type" : @"3",
                                 @"appCode" : tf_getAppCode(),
                                 @"accountType" : @"2"  //账号类型 1：用户名2：手机 3：邮箱
                                 };
    
    NSURLSessionDataTask *operation = [TFVenusHTTPRequestManager
                                       doTaskWithURL:kTFURLManager.getQuickSMSCode_url
                                       parameters:parameters
                                       success:^(id data)
                                       {
                                           if (successBlock)
                                           {
                                               successBlock();
                                           }
                                       }
                                       failure:^(int errorCode, NSString *errorMessage)
                                       {
                                           if (failureBlock)
                                           {
                                               failureBlock(errorCode, errorMessage);
                                           }
                                       }
                                       error:^(NSError *error)
                                       {
                                           
                                       }];
    
    return operation;
}


@end
