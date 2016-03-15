//
//  NSString+Date.m
//  TorqueSDK
//
//  Created by zhangjipeng on 2/10/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import "NSString+Date.h"

@implementation NSString (Date)

+ (NSDate *)dateFromString:(NSString *)string ForDateFormatter:(NSString *)formatterString {
#if 0
    NSString *formatter = formatterString;
    if (!formatter) {
        formatter = kDateFormat;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter dateFromString:string];
#else
    return  [self dateFromStringN:string ForDateFormatter:formatterString];
#endif
}

+ (NSString *)stringFromDate:(NSDate *)date ForDateFormatter:(NSString *)formatterString {
#if 0
    return [self stringFromDateN:date ForDateFormatter:formatterString];
#else
    NSString *formatter = formatterString;
    if (!formatter) {
        formatter = kDateFormat;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter stringFromDate:date];
#endif
}

//CXBH-497   当使用[NSDate date]时，会有误差8个小时 用这个可以转化为正确时间
+ (NSString *)stringFromDateN:(NSDate *)date ForDateFormatter:(NSString *)formatterString {
    NSString *formatter = formatterString;
    if (!formatter) {
        formatter = kDateFormat;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setLocale:[NSLocale systemLocale]];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter stringFromDate:date];
}

//Donot touch me  very correct
+ (NSDate *)dateFromStringN:(NSString *)string ForDateFormatter:(NSString *)formatterString {
    NSString *formatter = formatterString;
    if (!formatter) {
        formatter = kDateFormat;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale systemLocale]];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter dateFromString:string];
}

//获取当前时间   纠正系统时间为当前时间
+ (NSDate *)currentDate
{
    NSDate *date = [NSDate date];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: date];
    
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    
    return localeDate;
}

@end
