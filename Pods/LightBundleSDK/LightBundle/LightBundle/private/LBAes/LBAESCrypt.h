//
//  NSData+AES256.h
//  AES
//
//  Created by Henry Yu on 2009/06/03.
//  Copyright 2010 Sevensoft Technology Co., Ltd.(http://www.sevenuc.com)
//  All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonKeyDerivation.h>
@interface LBAESCrypt : NSObject


+ (NSData *)aesKeyForPassword:(NSString *)password;

+ (NSString *)aes256Encrypt:(NSString *)message password:(NSString *)password;              /*加密方法,参数需要加密的内容*/
+ (NSString *)aes256Decrypt:(NSString *)base64EncodedString password:(NSString *)password;  /*解密方法，参数数密文*/


+ (NSString *)aes256Encrypt:(NSString *)message keyByte:(const void *)keyByte;              /*加密方法,参数需要加密的内容*/
+ (NSString *)aes256Decrypt:(NSString *)base64EncodedString keyByte:(const void *)keyByte;  /*解密方法，参数数密文*/


//默认采用 自带的key
+ (NSString *)aes256Encrypt:(NSString *)message;
+ (NSString *)aes256Decrypt:(NSString *)base64EncodedString;



@end
