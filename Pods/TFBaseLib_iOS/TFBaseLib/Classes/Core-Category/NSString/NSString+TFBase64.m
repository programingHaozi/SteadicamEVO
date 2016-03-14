//
//  NSString+TFBase64.m
//  Treasure
//
//  Created by xiayiyong on 15/9/9.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "NSString+TFBase64.h"

@implementation NSString (TFBase64)

- (NSString *)base64Encoding
{
    return [NSString base64Encoding:self];
}

+ (NSString *)base64Encoding:(NSString *)text
{
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    NSString *result = nil;
    
    result = [data base64EncodedStringWithOptions:0];
    
    return result;
}

@end
