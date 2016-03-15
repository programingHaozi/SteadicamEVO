//
//  NSString+Date.h
//  TorqueSDK
//
//  Created by zhangjipeng on 2/10/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#define kDateFormat @"yyyy-MM-dd HH:mm:ss"

#define kDateFormatShort @"yyyy-MM-dd"

#import <Foundation/Foundation.h>

@interface NSString (Date)

+ (NSDate *)dateFromString:(NSString *)string ForDateFormatter:(NSString *)formatterString;
+ (NSString *)stringFromDate:(NSDate *)date ForDateFormatter:(NSString *)formatterString;

////add by gsy 获取系统当前时间
//+ (NSString *)stringFromDateN:(NSDate *)date ForDateFormatter:(NSString *)formatterString;
//
////Donot touch me  very correct
//+ (NSDate *)dateFromStringN:(NSString *)string ForDateFormatter:(NSString *)formatterString;

//获取当前系统时间
+ (NSDate *)currentDate;

@end
