//
//  TFBaseUtil+Other.m
//  TFBaseLib
//
//  Created by xiayiyong on 16/2/4.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFBaseUtil+Other.h"

void tf_idleTimerDisabled(BOOL enable)
{
    [TFBaseUtil idleTimerDisabled:enable];
}


UIView* tf_getViewFromNib(NSString *className)
{
    return [TFBaseUtil getViewFromNib:className];
}

id tf_getVCFromNib(NSString *className)
{
    return [TFBaseUtil getVCFromNib:className];
}


BOOL tf_isEmpty(NSString *string)
{
    return [TFBaseUtil isEmpty:string];
}

NSString *tf_disableEmoji(NSString *string)
{
    return [TFBaseUtil disableEmoji:string];;
}

BOOL tf_isContainsEmoji(NSString *string)
{
    return [TFBaseUtil isContainsEmoji:string];
}

@implementation TFBaseUtil (Other)

+(void)idleTimerDisabled:(BOOL)enable
{
    [UIApplication sharedApplication].idleTimerDisabled = enable;
}


+ (UIView *)getViewFromNib:(NSString *)className
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:className owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

+ (id)getVCFromNib:(NSString *)className
{
    return [[NSClassFromString(className) alloc] initWithNibName:className bundle:nil];
}

+(BOOL) isEmpty:(NSString *)string
{
    if (!string || [string isEqual:[NSNull null]])
    {
        return YES;
    }
    else
    {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [string stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0 || [trimedString isEqualToString:@"(null)"])
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
}

+(NSString *) disableEmoji:(NSString *)string
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:string
                                                               options:0
                                                                 range:NSMakeRange(0, [string length])
                                                          withTemplate:@""];
    return modifiedString;
}

+(BOOL) isContainsEmoji:(NSString *)string
{
    __block BOOL isEomji = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     isEomji = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 isEomji = YES;
             }
         } else {
             //non surrogate
             if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                 isEomji = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 isEomji = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 isEomji = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 isEomji = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                 isEomji = YES;
             }
         }
     }];
    return isEomji;
}

@end
