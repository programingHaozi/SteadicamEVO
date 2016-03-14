//
//  NSString+TFEncrypt.m
//  UIDeviceAddition
//
//  Created by xiayiyong on 15/7/1.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "NSString+TFEncrypt.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString(TFEncrypt)


- (NSString *)md5 {
    if (self == nil || [self length] == 0)
    {
        return nil;
    }
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
    CC_MD5([self UTF8String], (int)[self lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [ms appendFormat:@"%02x", (int)(digest[i])];
    }
    
    return [ms copy];
}

- (NSString *)SHA1 {
    if (self == nil || [self length] == 0)
    {
        return nil;
    }
    
    unsigned char digest[CC_SHA1_DIGEST_LENGTH], i;
    CC_SHA1([self UTF8String], (int)[self lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    
    for ( i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [ms appendFormat:@"%02x", (int)(digest[i])];
    }
    
    return [ms copy];
}

- (NSString *)SHA256 {
    if (self == nil || [self length] == 0)
    {
        return nil;
    }
    
    unsigned char digest[CC_SHA256_DIGEST_LENGTH], i;
    CC_SHA256([self UTF8String], (int)[self lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    
    for (i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
    {
        [ms appendFormat: @"%02x", (int)(digest[i])];
    }
    
    return [ms copy];
}

- (NSString *)SHA512 {
    if (self == nil || [self length] == 0)
    {
        return nil;
    }
    
    unsigned char digest[CC_SHA512_DIGEST_LENGTH], i;
    CC_SHA512([self UTF8String], (int)[self lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    
    for (i = 0; i < CC_SHA512_DIGEST_LENGTH; i++)
    {
        [ms appendFormat: @"%02x", (int)(digest[i])];
    }
    
    return [ms copy];
}

@end
