//
//  NSData+Ext.h
//  Treasure
//
//  Created by xiayiyong on 15/3/2.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>

@interface NSData (Ext)

/*
 *  将二进制转换成字符串
 *
 *  @return 字符串
 */
- (NSString *)toString;

/*
 *  将二进制转换成字符串
 *
 *  @return 字符串
 */
+ (NSString *)toString:(NSData *)data;



@end
