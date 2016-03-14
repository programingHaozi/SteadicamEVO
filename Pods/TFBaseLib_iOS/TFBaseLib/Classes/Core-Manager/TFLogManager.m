//
//  TFLogManager.m
//  TFBaseLib
//
//  Created by xiayiyong on 15/11/4.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFLogManager.h"
#import "DDTTYLogger.h"
#import "DDASLLogger.h"

@interface TFLogFormatter : NSObject <DDLogFormatter>
@end

@implementation TFLogFormatter

static NSDateFormatter *dateFormatter;

- (id)init
{
    self = [super init];
    
    if (self) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
            dateFormatter = [threadDictionary objectForKey:@"cachedDateFormatter"];
            if (dateFormatter == nil) {
                dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setLocale:[NSLocale currentLocale]];
                [dateFormatter setDateFormat: @"YYYY-MM-dd HH:mm:ss:SSS"];
                [threadDictionary setObject:dateFormatter forKey:@"cachedDateFormatter"];
            }
            
        });
    }
    
    return self;
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
    NSString *dateString = [dateFormatter stringFromDate:(logMessage.timestamp)];
    
    // Output:
    return [NSString stringWithFormat:@"[%@ %@ %@ line=%d]\nmessage:%@",
            dateString,
            logMessage.fileName,
            logMessage.function,
            logMessage.line,
            logMessage.message];
}

@end

@implementation TFLogManager

+ (void)load
{
    [super load];
    
    // required, setup DDLog
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    [[DDTTYLogger sharedInstance] setLogFormatter:[TFLogFormatter new]];
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
}

+ (instancetype) sharedManager
{
    static TFLogManager *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TFLogManager alloc] init];
    });
    
    return sharedInstance;
}

@end
