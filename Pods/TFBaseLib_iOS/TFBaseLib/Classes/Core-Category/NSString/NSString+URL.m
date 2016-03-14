//
//  NSString+URL.m
//  Treasure
//
//  Created by xiayiyong on 15/9/9.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "NSString+URL.h"
#import "NSString+Category.h"

@implementation NSString (URL)

- (NSURL *)toURL
{
    return [NSURL URLWithString:[self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

- (NSString *)URLEncode
{
    NSString *result =
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)self,
                                                              NULL,
                                                              CFSTR("!*'();:@&;=+$,/?%#[] "),
                                                              kCFStringEncodingUTF8));
    return [result trim];
}

@end
