//
//  TFVenusUtil.h
//  Treasure
//
//  Created by xiayiyong on 15/9/15.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "TFUserDefaults+Venus.h"
#import "TFKeyChain+Venus.h"
#import "TFBaseLib.h"

/**
 *  密码安全级别
 */
typedef NS_ENUM(NSUInteger, SCSecurityType)
{
    /**
     *  高
     */
    SCSecurityHigh = 1,
    
    /**
     *  中
     */
    SCSecurityMedium = 2,
    
    /**
     *  低
     */
    SCSecurityLow = 3
};

/**
 *  性别
 */
typedef NS_ENUM(NSUInteger, GenderType)
{
    /**
     *  男
     */
    GenderMale = 1,
    
    /**
     *  女
     */
    GenderFemale = 2,
    
    /**
     *  未知
     */
    GenderUnKnown = 3
};

/**
 *  验证码类型
 */
typedef NS_ENUM(NSInteger, SMSCodeType)
{
    /**
     *  注册验证码
     */
    SMSCodeTypeRegister = 1,
    
    /**
     *  重置密码验证码
     */
    SMSCodeTypeResetPwsd = 2,
    
    /**
     *  绑定手机验证码  || 快速登录验证码3.1
     */
    SMSCodeTypeBind = 3,
};

typedef NS_ENUM(NSInteger, SCAuthImageType)
{
    /**
     *  行驶证
     */
    SCAuthImageTypeVelpermit = 1,
    
    /**
     *  人车合影
     */
    SCAuthImageTypeCar2person = 2,
    
    /**
     *  压缩后的数据
     */
    SCAuthImageTypeZipped = 3
};

#pragma mark -
#pragma mark TFCoreUtil
/**
 *  生成DeviceId,使用UUID生成,存储在UserDefault中，如果外部不传递则内部生成。
 *
 *  @return
 */
NSString *tf_getDeviceId();

/**
 *  获取APP的版本号
 *
 *  @return
 */
NSString *tf_getAPPVersion();

/**
 *  获取APP的bundleId
 *
 *  @return
 */
NSString *tf_getBundleIdentifier();

/**
 *  获取设备类型
 *
 *  @return
 */
NSString *tf_getDeviceManufacturer();

/**
 *  获取系统版本号
 *
 *  @return
 */
NSString *tf_getSystemVersion();

/**
 *  获取系统当前时间
 *
 *  @return
 */
NSString *tf_getNowDate();

/**
 *  获取AppCode
 *
 *  @return
 */
NSString *tf_getAppCode();

/**
 *  获取SourceCode
 *
 *  @return
 */
NSString *tf_getSourceCode();

/**
 *  获取PlateformType
 *
 *  @return
 */
NSString *tf_getPlateformType();

/**
 *  获取DeviceInfo
 *
 *  @return
 */
NSString *tf_getDeviceInfo();

/**
 *  获取已登录用户的账号
 *
 *  @return
 */
NSString *tf_getUserAccount();

/**
 *  获取已登录用户的token
 *
 *  @return
 */
NSString *tf_getUserToken();

/**
 *  获取已登录用户的UserId
 *
 *  @return
 */
NSNumber *tf_getUserId();

/**
 *  获取已登录用户的clientid
 *
 *  @return
 */
NSString *tf_getClientId();

/**
 *  获取已登录用户的用户名
 *
 *  @return
 */
NSString *tf_getUserName();

/**
 *  获取已登录用户的手机号码
 *
 *  @return
 */
NSString *tf_getUserMobile();

/**
 *  监测密码强度
 密码字符包括：小写字母、大写字母、数字、符号等；
 这个正则会得到五个捕获组，前四个捕获组会告诉我们这个字符串包含有多少种组合（返回多少个匹配代表多少种组合）
 如果这个字符串小于6位的话,则会得到第五个捕获组,长度为1（即强度为1），如果没有输入，就连捕获组5都不会得到（强度为0)
 *
 *  @return
 */
int tf_checkSecurity(NSString *pwd);

/**
 *  获取密码强度
 （ 密码形态类型包含数字，符号，小写字母，大写字母）
 强：密码长度大于6位，并且包含三种或以上的形态；
 中：不满足“强”规则，长度大于8位，并且包含两种形态组合
 弱：不满足“中”规则，就为弱
 *
 *  @return
 */
NSString *tf_levelOfPassword(NSString *password);

@interface TFCoreUtil : NSObject

@end
