//
//  NSString+Regular.h
//  TWApp
//
//  Created by xiayiyong on 15/7/1.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (STRegex)

/**
 *  验证英文字母
 *
 *  @return 是英文返回yes
 */
- (BOOL)isValidEnglish;
/**
 *  验证是否为汉字。
 *
 *  @return 是汉字返回yes
 */
- (BOOL)isValidChinese;

/**
 *  验证密码：6—20位，只能包含字符、数字和 下划线。
 *
 *  @return 符合要求返回yes
 */
- (BOOL)isValidPassword;

/**
 *  判断是否是合格的邮箱格式
 */
- (BOOL)isValidEmail;

/**
 *  判断是否是合格的邮箱格式
 */
+ (BOOL)isValidEmail:(NSString *)email;

/*!
 * 验证是否是正确的手机号码格式
 */
- (BOOL)isValidPhone;

/*!
 * 验证是否是正确的手机号码格式
 */
+ (BOOL)isValidPhone:(NSString *)phone;

/*!
 * 验证是否是正确的固定电话号码格式
 */
- (BOOL)isValidTelNumber;

/*!
 * 验证是否是正确的固定电话号码格式
 */
+ (BOOL)isValidTelNumber:(NSString *)telNumber;

/*!
 * 验证是否是正确的18位身份证号码格式
 */
- (BOOL)isValidPersonID;

/*!
 * 验证是否是正确的18位身份证号码格式
 */
+ (BOOL)isValidPersonID:(NSString *)PID;

/*!
 * 判断是否只包含字母和汉字、数字、字母和数字
 */
- (BOOL)isOnlyLetters;

/**
 *  判断是否只包含字母
 *
 */
- (BOOL)isOnlyAlpha;

/**
 *  判断是否只包含数字
 *
 */
- (BOOL)isOnlyNumbers;

/**
 *  判断数字字母汉字
 *
 */
- (BOOL)isLettersAndNum;

/**
 *  判断包含字母和数字
 *
 */
- (BOOL)isAlphaAndNum;

/** 
 工商税号 
 */
- (BOOL)isValidTaxNo;

/** 
 车牌号验证 
 */
- (BOOL)isValidCarNo;

/** 
 网址验证 
 */
- (BOOL)isValidUrl;

/** 
 邮政编码 
 */
- (BOOL)isValidPostalcode;

/**
是否符合IP格式，xxx.xxx.xxx.xxx
 */
- (BOOL)isValidIP;

@end
