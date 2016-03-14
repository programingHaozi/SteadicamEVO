//
//  TFHotfixPlistManager.m
//  TFHotfixLib
//
//  Created by Chen Hao 陈浩 on 15/10/22.
//  Copyright © 2015年 Chen Hao 陈浩. All rights reserved.
//

#import "TFHotfixPlistManager.h"

@implementation TFHotfixPlistManager
/**
 *  初始化HotfixPlistManager
 *
 *  @return HotfixPlistManager实例
 */
+ (TFHotfixPlistManager *)sharedManager
{
    static TFHotfixPlistManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TFHotfixPlistManager alloc] init];
    });
    
    return instance;
}

#pragma mark - 获取app配置文件 -

/**
 *  获取app的环境配置文件
 *
 *  @return 环境配置文件的字典
 */
-(NSDictionary*)EnvironmentConfig
{
    NSString *configPath = [[NSBundle mainBundle] pathForResource:@"EnvironmentConfig" ofType:@"plist"];
    NSDictionary *config = [NSDictionary dictionaryWithContentsOfFile:configPath];
    return config;
}

/**
 *  获取app的第三方配置文件
 *
 *  @return 第三方配置文件的字典
 */
-(NSDictionary*)ThirdConfig
{
    NSString *configPath = [[NSBundle mainBundle] pathForResource:@"ThirdConfig" ofType:@"plist"];
    NSDictionary *config = [NSDictionary dictionaryWithContentsOfFile:configPath];
    return config;
}


#pragma mark - 服务地址配置 -

/**
 *  获取当前环境
 *
 *  @return 当前环境
 */
-(NSString*)appEnv
{
    return [[self EnvironmentConfig] objectForKey:@"Environment"];
}

/**
 *  获取serverUrl地址
 *
 *  @return serverUrl地址
 */
-(NSString*)serverUrl
{
    return [[[self EnvironmentConfig] objectForKey:@"ServerURL"] objectForKey:self.appEnv];
}

#pragma mark -第三方配置 -

/**
 *  获取当前app编号
 *
 *  @return 当前app编号
 */
- (NSString *)appId
{
    return [[[self ThirdConfig] objectForKey:@"JSPatch"] objectForKey:@"APP_ID"];
}

@end
