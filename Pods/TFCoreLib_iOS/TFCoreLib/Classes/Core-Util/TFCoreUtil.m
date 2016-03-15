//
//  TFVenusUtil.m
//  Treasure
//
//  Created by xiayiyong on 15/9/15.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFCoreUtil.h"

NSString* tf_getDeviceId()
{
    NSString *uuid = kTFUserDefaults.deviceId;
    if (!uuid||uuid.length==0)
    {
        CFUUIDRef puuid = CFUUIDCreate(nil);
        CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
        uuid = (NSString *)CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
        CFRelease(puuid);
        CFRelease(uuidString);
        kTFUserDefaults.deviceId=uuid;
    }
    return uuid;
}

NSString* tf_getAPPVersion()
{
    //获取app的版本号
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *versionCode = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return versionCode;
}

NSString* tf_getBundleIdentifier()
{
    //获取app的bundleId
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleIdentifier = [infoDictionary objectForKey:(NSString *)kCFBundleIdentifierKey];
    return bundleIdentifier;
}

NSString* tf_getDeviceManufacturer()
{
    //获取设备类型
    NSString *deviceManufacturer = [UIDevice currentDevice].model;
    return deviceManufacturer;
}

NSString* tf_getSystemVersion()
{
    //获取系统版本号
    NSString *systemVersion = [NSString stringWithFormat:@"%@ %@",[[UIDevice currentDevice] systemName],[[UIDevice currentDevice] systemVersion]];
    return systemVersion;
}

NSString* tf_getNowDate()
{
    return [[NSDate new] stringWithFormat:@"yyyyMMdd"];
}

NSString* tf_getAppCode()
{
    return @"MongoToC";
}

NSString* tf_getSourceCode()
{
    return @"APPStore";
}

NSString* tf_getPlateformType()
{
    return @"ios";
}

NSString* tf_getDeviceInfo()
{
    return @"Apple";
}

NSString* tf_getUserAccount()
{
    if(kTFUserDefaults.userInfo!=nil&&kTFUserDefaults.userInfo.mobile!=nil)
    {
        return kTFUserDefaults.userInfo.mobile;
    }
    else
    {
        return @"";
    }
}

NSString* tf_getUserToken()
{
    if(kTFUserDefaults.userInfo!=nil&&kTFUserDefaults.userInfo.token!=nil)
    {
        return kTFUserDefaults.userInfo.token;
    }
    else
    {
        return @"";
    }
}

NSNumber* tf_getUserId()
{
    if(kTFUserDefaults.userInfo!=nil&&kTFUserDefaults.userInfo.userId!=nil)
    {
        return kTFUserDefaults.userInfo.userId;
    }
    else
    {
        return @(0);
    }
}

NSString* tf_getUserName()
{
    if(kTFUserDefaults.userInfo!=nil&&kTFUserDefaults.userInfo.realName!=nil)
    {
        return kTFUserDefaults.userInfo.realName;
    }
    else
    {
        return @"";
    }
}

NSString* tf_getUserMobile()
{
    if(kTFUserDefaults.userInfo!=nil&&kTFUserDefaults.userInfo.mobile!=nil)
    {
        return kTFUserDefaults.userInfo.mobile;
    }
    else
    {
        return @"";
    }
}

NSString* tf_getClientId()
{
    if(kTFUserDefaults.clientId!=nil && [kTFUserDefaults.clientId length]>0)
    {
        return kTFUserDefaults.clientId;
    }
    else
    {
        return @"";
    }
}

int tf_checkSecurity(NSString *pwd)
{
    NSString *regexString       = @"^(?:([a-z])|([A-Z])|([0-9])|(.)){6,}|(.)+$" ;
    NSString *replaceWithString = @"$1$2$3$4$5" ;
    NSString *replacedString    = NULL;
    NSRegularExpression *reg=[[NSRegularExpression alloc]initWithPattern:regexString options:0 error:nil];
    replacedString=[reg stringByReplacingMatchesInString:pwd options:0 range:NSMakeRange(0, pwd.length) withTemplate:replaceWithString];
    return (int)replacedString.length;
}

NSString* tf_levelOfPassword(NSString *password)
{
    SCSecurityType securityType = SCSecurityHigh;
    if ((password.length > 6) &&
        (tf_checkSecurity(password) > 2))
    {
        securityType = SCSecurityHigh;
    }
    else if ((password.length > 8) &&
             (tf_checkSecurity(password) > 1))
    {
        securityType = SCSecurityMedium;
    }
    else
    {
        securityType = SCSecurityLow;
    }
    
    return [NSString stringWithFormat:@"%ld",(long)securityType];
}

@implementation TFCoreUtil

@end
