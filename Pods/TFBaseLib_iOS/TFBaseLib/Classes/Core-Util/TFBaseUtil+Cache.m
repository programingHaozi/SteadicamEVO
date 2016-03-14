//
//  TFBaseUtil+Cache.m
//  TFBaseLib
//
//  Created by xiayiyong on 15/10/14.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFBaseUtil+Cache.h"

void tf_saveValue(id value, NSString *key)
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:value forKey:key];
    [userDefaults synchronize];
}

id tf_getValueWithKey(NSString *key)
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults valueForKey:key];
}

void tf_saveObject(id obj, NSString *key)
{
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:obj];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:myEncodedObject forKey:key];
    [defaults synchronize];
}

id tf_getObjectWithKey(NSString *key)
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id myEncodedObject = [defaults objectForKey:key];
    if ([myEncodedObject isKindOfClass:[NSData class]])
    {
        return [NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    }
    else
    {
        return myEncodedObject;
    }
}

void tf_removeObjectWithKey(NSString *key)
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:key];
}

@implementation TFBaseUtil (Cache)
+ (void) saveValue:(id)value key:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:value forKey:key];
    [userDefaults synchronize];
}

+ (id) getValueWithKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults valueForKey:key];
}

+ (void)saveObject:(id)obj key:(NSString *)key
{
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:obj];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:myEncodedObject forKey:key];
    [defaults synchronize];
}

+ (id)getObjectWithKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id myEncodedObject = [defaults objectForKey:key];
    if ([myEncodedObject isKindOfClass:[NSData class]])
    {
        return [NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    }
    else
    {
        return myEncodedObject;
    }
}

+ (void) removeObjectWithKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:key];
}

@end
