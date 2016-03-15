//
//  NSString+Base64.h
//  TorqueSDK
//
//  Created by huxianchen on 15/3/4.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Base64)


+ (NSString *)base64Decode:(NSString *)code;

+(NSString *) jsonStringWithString:(NSString *) string;
+(NSString *) jsonStringWithArray:(NSArray *)array;
+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary;
+(NSString *) jsonStringWithObject:(id) object;


+ (NSString *)bytesToNSString:(NSData *)aData;
+(NSData *)stringToByte:(NSString *)hexString;

-(NSData*) hexToBytes;




// 十六进制转换为普通字符串的。
+ (NSString *)stringFromHexString:(NSString *)hexString;

//普通字符串转换为十六进制的。

+ (NSString *)hexStringFromString:(NSString *)string;
@end
