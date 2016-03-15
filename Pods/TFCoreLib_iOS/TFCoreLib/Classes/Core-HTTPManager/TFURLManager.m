//
//  TFURLManager.m
//  Treasure
//
//  Created by xiayiyong on 15/9/6.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFURLManager.h"

#pragma mark -
#pragma mark 用户注册模块

#define OPENAPI_REGISTER_DEVICE                   @"/RigidaDeviceService20/init"           //注册设备
#define OPENAPI_UNREGISTER_DEVICE                 @"/RigidaDeviceService20/remove"         //注销设备

#define OPENAPI_LOGIN                             @"/RigidaUserService20/doLogin"          //用户登录
#define OPENAPI_REGISTER                          @"/RigidaUserService20/doRegister"       //用户注册
#define OPENAPI_RESETPSWD                         @"/RigidaUserService20/resetPwd"         //重置密码
#define OPENAPI_CHANGEPSWD                        @"/RigidaUserService20/updateUserPwd"    //修改密码
#define OPENAPI_GETSMSCODE                        @"/RigidaUserService20/getSmsCode"       //短信验证码
#define OPENAPI_LOGOUT                            @"/RigidaUserService20/doLogOut"         //用户注销
#define OPENAPI_QUICKLOGIN                        @"/RigidaUserService30/doQuickLogin"      //用户快速登录
#define OPENAPI_GETQUICKSMSCODE                   @"/RigidaUserService30/getSmsCode"        //用户快速登录验证码

@implementation TFURLManager

+ (instancetype)sharedManager
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (NSString*)venusUrlForKey:(NSString*)key
{
    return [NSString stringWithFormat:@"%@%@",kTFURLManager.venusUrl,key];
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark -
#pragma mark 服务地址配置

-(NSString*)appEnvironment
{
    return [[self _config] objectForKey:@"Environment"];
}

-(NSString*)serverUrl
{
    return [[[self _config] objectForKey:@"ServerURL"] objectForKey:self.appEnvironment];
}

-(NSString*)obdServerUrl
{
    return [[[self _config] objectForKey:@"OBDSeveralUrl"] objectForKey:self.appEnvironment];
}

-(NSString*)fileServerUrl
{
    return [[[self _config] objectForKey:@"FileServerURL"] objectForKey:self.appEnvironment];
}

-(NSString*)pushServerUrl
{
    return [[[self _config] objectForKey:@"MessageRouteURL"] objectForKey:self.appEnvironment];
}

-(NSString*)bygjServerUrl
{
    return [[[self _config] objectForKey:@"BYGJServerURL"] objectForKey:self.appEnvironment];
}

-(NSString*)venusUrl
{
    return [[[[self _config] objectForKey:@"VenusURL"] objectForKey:self.appEnvironment] stringByAppendingString:@"/services"];
}

-(NSString*)trackingId
{
    return [[[self _config] objectForKey:@"TrackingId"] objectForKey:self.appEnvironment];
}

-(NSString *)cxpaiUrl
{
    return [[[self _config] objectForKey:@"CXPaiRoutrURL"] objectForKey:self.appEnvironment];
}

-(NSString *)finshCarUrl
{
    return [[[self _config] objectForKey:@"FinshCarURL"] objectForKey:self.appEnvironment];
}

-(NSString *)velKnowWebURL
{
    return [[[self _config] objectForKey:@"VelKnowWebURL"] objectForKey:self.appEnvironment];
}

-(NSString *)gcddWebURL
{
    return [[[self _config] objectForKey:@"GcddWebURL"] objectForKey:self.appEnvironment];
}

-(NSString *)cxPayURL
{
    return [[[self _config] objectForKey:@"CxPayURL"] objectForKey:self.appEnvironment];
}

#pragma mark -
#pragma mark venusUrl

/**
 下面这几个接口是venusUrl地址  其他是srverURL地址
 */
-(NSString*)regDevice_url
{
    return [[self class] venusUrlForKey:OPENAPI_REGISTER_DEVICE];
}

-(NSString*)unregDevice_url
{
    return [[self class] venusUrlForKey:OPENAPI_UNREGISTER_DEVICE];
}

-(NSString*)login_url
{
    return [[self class] venusUrlForKey:OPENAPI_LOGIN];
}

-(NSString*)logout_url
{
    return [[self class] venusUrlForKey:OPENAPI_LOGOUT];
}

-(NSString *)getSMSCode_url
{
    return [[self class] venusUrlForKey:OPENAPI_GETSMSCODE];
}

-(NSString *)resetPwd_url
{
    return [[self class] venusUrlForKey:OPENAPI_RESETPSWD];
}

-(NSString *)updateUserPwd_url
{
    return [[self class] venusUrlForKey:OPENAPI_CHANGEPSWD];
}

-(NSString *)regUser_url
{
    return [[self class] venusUrlForKey:OPENAPI_REGISTER];
}

-(NSString *)quickLogin_url
{
    return [[self class] venusUrlForKey:OPENAPI_QUICKLOGIN];
}

-(NSString *)getQuickSMSCode_url
{
    return [[self class] venusUrlForKey:OPENAPI_GETQUICKSMSCODE];
}

#pragma mark -
#pragma mark 私有方法
-(NSDictionary*)_config
{
    NSString *configPath = [[NSBundle mainBundle] pathForResource:@"EnvironmentConfig" ofType:@"plist"];
    NSDictionary *config = [NSDictionary dictionaryWithContentsOfFile:configPath];
    return config;
}

@end
