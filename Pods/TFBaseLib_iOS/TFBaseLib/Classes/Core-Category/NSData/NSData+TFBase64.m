//
//  NSData+Base64.m
//  Treasure
//
//  Created by xiayiyong on 15/9/9.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "NSData+TFBase64.h"

@implementation NSData (TFBase64)

- (NSString *)base64Encoding
{
    NSString *result = nil;
    result = [self base64EncodedStringWithOptions:0];
    return result;
}

+ (NSString *)base64Encoding:(NSData*)data
{
    NSString *result = nil;
    result = [data base64EncodedStringWithOptions:0];
    return result;
}

@end
