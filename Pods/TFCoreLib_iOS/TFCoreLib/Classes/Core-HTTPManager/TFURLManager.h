//
//  TFURLManager.h
//  Treasure
//
//  Created by xiayiyong on 15/9/6.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark -
#pragma mark TFURLManager

#define kTFURLManager  ([TFURLManager sharedManager])

@interface TFURLManager : NSObject

/**
 *  APP环境 DEV、SIT、PRE、PRD
 */
@property (nonatomic, strong) NSString *appEnvironment;

/**
 *  服务端url
 */
@property (nonatomic, strong, readonly) NSString *serverUrl;

/**
 *  OBD url
 */
@property (nonatomic, strong, readonly) NSString *obdServerUrl;
@property (nonatomic, strong, readonly) NSString *fileServerUrl;
@property (nonatomic, strong, readonly) NSString *pushServerUrl;
@property (nonatomic, strong, readonly) NSString *bygjServerUrl;

/**
 *  VENUS url
 */
@property (nonatomic, strong, readonly) NSString *venusUrl;
@property (nonatomic, strong, readonly) NSString *trackingId;

/**
 *  车享拍url
 */
@property (nonatomic, strong, readonly) NSString *cxpaiUrl;

/**
 *  整车商城url
 */
@property (nonatomic, strong, readonly) NSString *finshCarUrl;

/**
 *  车知道url
 */
@property (nonatomic, strong, readonly) NSString *velKnowWebURL;
@property (nonatomic, strong, readonly) NSString *gcddWebURL;

/**
 *  车享付url
 */
@property (nonatomic, strong, readonly) NSString *cxPayURL;

/**
 * 注册设备URL
 */
@property (nonatomic, strong, readonly) NSString *regDevice_url;

/**
 * 注销设备URL
 */
@property (nonatomic, strong, readonly) NSString *unregDevice_url;

/**
 * 用户注册URL
 */
@property (nonatomic, strong, readonly) NSString *regUser_url;

/**
 * 用户登陆URL
 */
@property (nonatomic, strong, readonly) NSString *login_url;

/**
 * 用户注销URL
 */
@property (nonatomic, strong, readonly) NSString *logout_url;

/**
 * 获取验证码URL
 */
@property (nonatomic, strong, readonly) NSString *getSMSCode_url;

/**
 * 重设密码URL
 */
@property (nonatomic, strong, readonly) NSString *resetPwd_url;

/**
 * 修改密码URL
 */
@property (nonatomic, strong, readonly) NSString *updateUserPwd_url;

/**
 *  快速登录URL
 */
@property (nonatomic, strong, readonly) NSString *quickLogin_url;
/**
 *  快速登录验证码URL
 */
@property (nonatomic, strong, readonly) NSString *getQuickSMSCode_url;

+ (instancetype)sharedManager;

/**
 *  获取venus接口地址
 *
 *  @param key MongoServiceDefine 中接口对应的key
 *
 *  @return
 */
+ (NSString*)venusUrlForKey:(NSString*)key;

@end
