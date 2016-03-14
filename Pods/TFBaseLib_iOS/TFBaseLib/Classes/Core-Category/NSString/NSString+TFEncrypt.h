//
//  NSString+TFEncrypt.h
//  UIDeviceAddition
//
//  Created by xiayiyong on 15/7/1.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(TFEncrypt)

/**
 *  md5加密
 *
 */
- (NSString *)md5;

/**
 *  SHA1加密
 *
 */
- (NSString *)SHA1;

/**
 *  SHA256加密
 *
 */
- (NSString *)SHA256;

/**
 *  SHA512加密
 *
 */
- (NSString *)SHA512;

@end
