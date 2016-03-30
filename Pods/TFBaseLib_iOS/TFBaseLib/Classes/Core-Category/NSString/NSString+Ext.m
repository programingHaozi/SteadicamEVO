//
//  NSString+Ext.m
//  Treasure
//
//  Created by xiayiyong on 15/7/1.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "NSString+Ext.h"
#import <CommonCrypto/CommonDigest.h>
#import <sys/sysctl.h>
#import <sys/socket.h>
#import <net/if.h>
#import <net/if_dl.h>

#import "NSData+Ext.h"
#import "NSString+Path.h"

@implementation NSString (Ext)

- (NSString *)trimLeft
{
    NSUInteger len = 0;
    NSString *resultString = @"";
    
    while (len < self.length)
    {
        if ([self characterAtIndex:len] == ' ')
        {
            if (len + 1 < self.length)
            {
                resultString = [self substringFromIndex:len + 1];
            }
        }
        else
        {
            return resultString;
        }
        len++;
    }
    return self;
        
}

- (NSString *)trimRight
{
    NSString *tempString = [self trimLeft];
    NSUInteger count = 0;
    while (count < tempString.length)
    {
        if ([tempString characterAtIndex:count] == ' ')
        {
            return [tempString substringToIndex:count];
        }
        count++;
    }
    return tempString;
}

- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)trimAll
{
    NSString *tempString = self.trim;
    return [tempString stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)trimLetters
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet letterCharacterSet]];
}

- (NSString *)trimCharacter:(unichar)character
{
    NSString *str = [NSString stringWithFormat:@"%c", character];
    return [self stringByReplacingOccurrencesOfString:str withString:@""];
}

- (NSString *)trimWhitespace
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSUInteger)numberOfLines
{
    return [self componentsSeparatedByString:@"\n"].count + 1;
}

- (BOOL)isEmpty
{
  return self == nil || self.length == 0;
}

- (BOOL)isTrimEmpty
{
    return self == nil || self.trim.length == 0;
}

- (BOOL)isValidWithMinLenth:(NSInteger)minLenth
                   maxLenth:(NSInteger)maxLenth
             containChinese:(BOOL)containChinese
        firstCannotBeDigtal:(BOOL)firstCannotBeDigtal;
{
    NSString *hanzi = containChinese ? @"\u4e00-\u9fa5" : @"";
    NSString *first = firstCannotBeDigtal ? @"^[a-zA-Z_]" : @"";
    
    NSString *regex = [NSString stringWithFormat:@"%@[%@A-Za-z0-9_]{%d,%d}", first, hanzi, (int)(minLenth-1), (int)(maxLenth-1)];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pre evaluateWithObject:self];
}

- (BOOL)isValidWithMinLenth:(NSInteger)minLenth
                   maxLenth:(NSInteger)maxLenth
             containChinese:(BOOL)containChinese
              containDigtal:(BOOL)containDigtal
              containLetter:(BOOL)containLetter
      containOtherCharacter:(NSString *)containOtherCharacter
        firstCannotBeDigtal:(BOOL)firstCannotBeDigtal;
{
    NSString *hanzi = containChinese ? @"\u4e00-\u9fa5" : @"";
    NSString *first = firstCannotBeDigtal ? @"^[a-zA-Z_]" : @"";
    NSString *lengthRegex = [NSString stringWithFormat:@"(?=^.{%@,%@}$)", @(minLenth), @(maxLenth)];
    NSString *digtalRegex = containDigtal ? @"(?=(.*\\d.*){1})" : @"";
    NSString *letterRegex = containLetter ? @"(?=(.*[a-zA-Z].*){1})" : @"";
    NSString *characterRegex = [NSString stringWithFormat:@"(?:%@[%@A-Za-z0-9%@]+)", first, hanzi, containOtherCharacter ? containOtherCharacter : @""];
    NSString *regex = [NSString stringWithFormat:@"%@%@%@%@", lengthRegex, digtalRegex, letterRegex, characterRegex];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pre evaluateWithObject:self];
}

- (NSString *)stringByTrimmingBlank
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)addPrefix:(NSString *)prefix
{
    if (prefix == nil || prefix.length == 0)
    {
        return self;
    }
    
    return [NSString stringWithFormat:@"%@%@", prefix, self];
}

- (NSString *)addSubfix:(NSString *)subfix
{
    if (subfix == nil || subfix.length == 0)
    {
        return self;
    }
    
    return [NSString stringWithFormat:@"%@%@", self, subfix];
}

+ (NSString *)contentsOfFile:(NSString *)fileName
{
    __autoreleasing NSError* error = nil;
    NSString *result = [[NSString alloc] initWithContentsOfFile:[NSString pathWithFileName:fileName]
                                                       encoding:NSUTF8StringEncoding
                                                          error:&error];
    if (error != nil)
    {
        return nil;
    }
    return result;
}

+ (id)jsonDataFromFileName:(NSString *)fileName
{
    NSString *jsonString = [NSString contentsOfFile:fileName];
    NSData* data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (data==nil)
    {
        return nil;
    }
    
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil)
    {
        return nil;
    }
    return result;
}

@end
