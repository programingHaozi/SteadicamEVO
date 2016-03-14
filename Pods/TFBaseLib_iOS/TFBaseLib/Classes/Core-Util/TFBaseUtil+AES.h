//
//  TFBaseUtil+AES.h
//  TFBaseLib
//
//  Created by xiayiyong on 15/10/13.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFBaseUtil.h"

/**
 *  aes加密
 *
 *  @param password 要加密的密码
 *
 *  @return 加密后的密码
 */
NSData *tf_aesKeyForPassword(NSString *password);

/**
 *  aes256加密方法,参数需要加密的内容
 *
 *  @param message  加密内容
 *  @param password 加密的参数
 *
 *  @return 加密后的
 */
NSString *tf_aes256Encrypt(NSString *message, NSString *password);

/**
 *  aes256解密方法，参数数密文
 *
 *  @param base64EncodedString 需要解密的内容
 *  @param password            参数
 *
 *  @return 解密后的
 */
NSString *tf_aes256Decrypt(NSString *base64EncodedString, NSString *password);

/**
 *  aes256加密
 *
 *  @param string 要加密的字符串
 *  @param key    键值
 *
 *  @return 加密后的字符串
 */
NSString* tf_aes256EncryptByKey(NSString* string, const void *key);

/**
 *  aes256解密
 *
 *  @param base64EncodedString 加密的字符串
 *  @param key                 键值
 *
 *  @return 解密后的字符串
 */
NSString* tf_aes256DecryptByKey(NSString* base64EncodedString, const void *key);



@interface TFBaseUtil (AES)

/**
 *  aes加密
 *
 *  @param password 要加密的密码
 *
 *  @return 加密后的密码
 */
+ (NSData *)aesKeyForPassword:(NSString *)password;

/**
 *  aes256加密方法,参数需要加密的内容
 *
 *  @param message  加密内容
 *  @param password 加密的参数
 *
 *  @return 加密后的
 */
+ (NSString *)aes256Encrypt:(NSString *)message password:(NSString *)password;

/**
 *  aes256解密方法，参数数密文
 *
 *  @param base64EncodedString 需要解密的内容
 *  @param password            参数
 *
 *  @return 解密后的
 */
+ (NSString *)aes256Decrypt:(NSString *)base64EncodedString password:(NSString *)password;

/**
 *  加密方法,参数需要加密的内容
 *
 *  @param message 加密的内容
 *  @param keyByte keyByte
 *
 *  @return 返回的值
 */
+ (NSString *)aes256Encrypt:(NSString *)message keyByte:(const void *)keyByte;

/**
 *  解密方法，参数数密文
 *
 *  @param base64EncodedString 需要解密的内容
 *  @param keyByte             keyByte
 *
 *  @return 返回的值
 */
+ (NSString *)aes256Decrypt:(NSString *)base64EncodedString keyByte:(const void *)keyByte;

@end
