//
//  TFBaseUtil+Valid.h
//  TFBaseLib
//
//  Created by xiayiyong on 16/2/25.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFBaseUtil.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 *  验证密码长度校验:6位以上,20位以内
 *
 *  @param passeord 要被校验的密码
 *
 *  @return 符合规范返回YES，否则返回NO
 */
BOOL tf_isValidPassword(NSString *passeord);

/**
 *  验证电话规则
 *
 *  @param phone 需要校验的手机号
 *
 *  @return 符合规范返回YES，否则返回NO
 */
BOOL tf_isValidPhone(NSString *phone);

/**
 *  校验车牌号
 *
 *  @param lp 车牌号
 *
 *  @return 符合规范返回YES，否则返回NO
 */
BOOL tf_isValidCarNo(NSString *lp);

/**
 *  校验全部车牌号带省
 *
 *  @param carNo 车牌号
 *
 *  @return 符合规范返回YES，否则返回NO
 */
BOOL tf_isValidAllCarNo(NSString *carNo);

/**
 *  校验别名
 *
 *  @param nickname 别名
 *
 *  @return 符合规范返回YES，否则返回NO
 */
BOOL tf_isValidNickname(NSString *nickname);//校验别名

/**
 * 校验姓名
 *
 *  @param realName 姓名
 *
 *  @return 符合规范返回YES，否则返回NO
 */
BOOL tf_isValidRealName(NSString *realName);

/**
 *  校验vin码
 *
 *  @param vinNo vin码
 *
 *  @return 符合规范返回YES，否则返回NO
 */
BOOL tf_isValidVinNo(NSString *vinNo);

/**
 *  校验发动机号
 *
 *  @param engineNo 发动机号
 *
 *  @return 符合规范返回YES，否则返回NO
 */
BOOL tf_isValidEngineNo(NSString *engineNo);

@interface TFBaseUtil (Valid)

/**
 *  验证密码长度校验:6位以上,20位以内
 *
 *  @param passeord 要被校验的密码
 *
 *  @return 符合规范返回YES，否则返回NO
 */
+(BOOL) isValidPassword:(NSString *)password;

/**
 *  验证电话规则
 *
 *  @param phone 电话号码
 *
 *  @return 符合规范返回YES，否则返回NO
 */
+(BOOL) isValidPhone:(NSString *)phone;

/**
 *  校验车牌号
 *
 *  @param lp 车牌号
 *
 *  @return 符合规范返回YES，否则返回NO
 */
+(BOOL) isValidCarNo:(NSString *)lp;

/**
 *  校验车牌带省
 *
 */
+(BOOL) isValidAllCarNo:(NSString *)carNo;

/**
 *  校验别名
 *
 *  @param nickname 别名
 *
 *  @return 符合规范返回YES，否则返回NO
 */
+(BOOL) isValidNickname:(NSString *)nickname;

/**
 * 校验姓名
 *
 *  @param realName 姓名
 *
 *  @return 符合规范返回YES，否则返回NO
 */
+(BOOL) isValidRealName:(NSString *)realName;

/**
 *  校验vin码
 *
 *  @param vinNo vin码
 *
 *  @return 符合规范返回YES，否则返回NO
 */
+(BOOL) isValidVinNo:(NSString *)vinNo;

/**
 *  校验发动机号
 *
 *  @param engineNo 发动机号
 *
 *  @return 符合规范返回YES，否则返回NO
 */
+(BOOL) isValidEngineNo:(NSString *)engineNo;

@end
