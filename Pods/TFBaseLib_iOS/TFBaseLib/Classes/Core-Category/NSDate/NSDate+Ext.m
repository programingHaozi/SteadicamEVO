//
//  NSDate+CX.m
//  Treasure
//
//  Created by xiayiyong on 15/8/18.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "NSDate+Ext.h"

#define kDateFormat @"yyyy-MM-dd HH:mm:ss"
#define kDateFormatShort @"yyyy-MM-dd"

@implementation NSDate (Ext)

+ (NSString *)stringFromDate24:(NSDate *)date
{
    NSDateFormatter *dateFromatter=[[NSDateFormatter alloc] init];
    [dateFromatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFromatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFromatter stringFromDate:date];
    return strDate;
}

+ (NSDate *)dateFromString24:(NSString *)dateString
{
    NSDateFormatter *dateFromatter=[[NSDateFormatter alloc] init];
    [dateFromatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFromatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFromatter dateFromString:dateString];
    return date;
}

+ (NSString *)stringFromDate12:(NSDate *)date
{
    NSDateFormatter *dateFromatter=[[NSDateFormatter alloc] init];
    [dateFromatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFromatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *strDate = [dateFromatter stringFromDate:date];
    return strDate;
}

+ (NSDate *)dateFromString12:(NSString *)dateString
{
    NSDateFormatter *dateFromatter=[[NSDateFormatter alloc] init];
    [dateFromatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFromatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate *date = [dateFromatter dateFromString:dateString];
    return date;
}

+ (NSString *)stringFromDay:(NSDate *)date
{
    NSDateFormatter *dateFromatter=[[NSDateFormatter alloc] init];
    [dateFromatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFromatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFromatter stringFromDate:date];
    return strDate;
}

+ (NSDate *)dayFromString:(NSString *)dateString
{
    NSDateFormatter *dateFromatter=[[NSDateFormatter alloc] init];
    [dateFromatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFromatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFromatter dateFromString:dateString];
    return date;
}

+ (NSString *)stringFromTime24:(NSDate *)time
{
    NSDateFormatter *dateFromatter=[[NSDateFormatter alloc] init];
    [dateFromatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFromatter setDateFormat:@"HH:mm:ss"];
    NSString *strTime = [dateFromatter stringFromDate:time];
    return strTime;
}

+ (NSDate *)timeFromString24:(NSString *)timeString
{
    NSDateFormatter *dateFromatter=[[NSDateFormatter alloc] init];
    [dateFromatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFromatter setDateFormat:@"HH:mm:ss"];
    NSDate *time = [dateFromatter dateFromString:timeString];
    return time;
}

+ (NSString *)stringFromTime12:(NSDate *)time
{
    NSDateFormatter *dateFromatter=[[NSDateFormatter alloc] init];
    [dateFromatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFromatter setDateFormat:@"hh:mm:ss"];
    NSString *strTime = [dateFromatter stringFromDate:time];
    return strTime;
}

+ (NSDate *)timeFromString12:(NSString *)timeString
{
    NSDateFormatter *dateFromatter=[[NSDateFormatter alloc] init];
    [dateFromatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFromatter setDateFormat:@"hh:mm:ss"];
    NSDate *time = [dateFromatter dateFromString:timeString];
    return time;
}
+ (NSString *)stringFromTime:(NSDate *)time format:(NSString*)format
{
    NSDateFormatter *dateFromatter=[[NSDateFormatter alloc] init];
    [dateFromatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFromatter setDateFormat:format];
    NSString *strTime = [dateFromatter stringFromDate:time];
    return strTime;
}

+ (NSDate *)timeFromString:(NSString *)timeString format:(NSString*)format
{
    NSDateFormatter *dateFromatter=[[NSDateFormatter alloc] init];
    [dateFromatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFromatter setDateFormat:format];
    NSDate *time = [dateFromatter dateFromString:timeString];
    return time;
}

+(NSString *)dateWithSting:(NSString*)time{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];//格式化
    
    [df setDateFormat:@"yyyyMMddHHmmss"];
    
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] ];
    
    NSDate *date =[[NSDate alloc]init];
    
    date =[df dateFromString:time];
    
    NSDateFormatter * df2 = [[NSDateFormatter alloc] init];
    
    [df2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString * str1 = [df2 stringFromDate:date];
    return str1;
}

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
    return [self dateFromStringN:string ForDateFormatter:formatterString];
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

+ (NSString *)stringWithDate:(NSDate *)date format:(NSString *)format
{
    return [date stringWithFormat:format];
}

- (NSString *)stringWithFormat:(NSString *)format
{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:format];
    
    NSString *retStr = [outputFormatter stringFromDate:self];
    
    return retStr;
}

- (BOOL)isSameDay:(NSDate *)anotherDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components1 = [calendar components:(NSCalendarUnitYear
                                                          | NSCalendarUnitMonth
                                                          | NSCalendarUnitDay)
                                                fromDate:self];
    NSDateComponents *components2 = [calendar components:(NSCalendarUnitYear
                                                          | NSCalendarUnitMonth
                                                          | NSCalendarUnitDay)
                                                fromDate:anotherDate];
    return ([components1 year] == [components2 year]
            && [components1 month] == [components2 month]
            && [components1 day] == [components2 day]);
}

- (BOOL)isToday
{
    return [self isSameDay:[NSDate date]];
}

@end
