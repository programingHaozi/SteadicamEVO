//
//  NSDictionary+Ext.m
//  Treasure
//
//  Created by xiayiyong on 15/7/1.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "NSDictionary+Ext.h"

@implementation NSDictionary (Ext)

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
  if (jsonString == nil)
  {
    return nil;
  }
  
  NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
  NSError *err;
  NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                      options:NSJSONReadingMutableContainers
                                                        error:&err];
  if(err)
  {
    NSLog(@"json解析失败：%@",err);
    return nil;
  }
  
  return dic;
}

- (NSString *)jsonString
{
  NSData *infoJsonData = [NSJSONSerialization dataWithJSONObject:self
                                                         options:NSJSONWritingPrettyPrinted
                                                           error:nil];
  NSString *json = [[NSString alloc] initWithData:infoJsonData encoding:NSUTF8StringEncoding];
  
  return json;
}

- (id)safeObjectForKey:(id<NSCopying>)aKey
{
  if (aKey == nil)
  {
    return nil;
  }
  
  return [self objectForKey:aKey];
}

- (int)intValueForKey:(id)key
{
  id obj = [self safeObjectForKey:key];
  
  if ([obj respondsToSelector:@selector(intValue)])
  {
    return [obj intValue];
  }
  
  return 0;
}

- (double)doubleValueForKey:(id)key
{
  id obj = [self safeObjectForKey:key];
  
  if ([obj respondsToSelector:@selector(doubleValue)])
  {
    return [obj doubleValue];
  }
  
  return 0.0;
}

- (float)floatValueForKey:(id)key
{
  id obj = [self safeObjectForKey:key];
  
  if ([obj respondsToSelector:@selector(floatValue)])
  {
    return [obj floatValue];
  }
  
  return 0.0f;
}

- (NSInteger)integerValueForKey:(id)key
{
  id obj = [self safeObjectForKey:key];
  
  if ([obj respondsToSelector:@selector(integerValue)])
  {
    return [obj integerValue];
  }
  
  return 0;
}

- (NSString *)stringValueForKey:(id)key
{
  id obj = [self safeObjectForKey:key];
  
  if ([obj respondsToSelector:@selector(stringValue)])
  {
    return [obj stringValue];
  }
  
  return nil;
}

- (NSDictionary *)dictionaryValueForKey:(id)key
{
  id obj = [self safeObjectForKey:key];
  
  if ([obj isKindOfClass:[NSDictionary class]])
  {
    return (NSDictionary *)obj;
  }
  
  return nil;
}

- (NSArray *)arrayValueForKey:(id)key
{
  id obj = [self safeObjectForKey:key];
  
  if ([obj isKindOfClass:[NSArray class]])
  {
    return (NSArray *)obj;
  }
  
  return nil;
}

- (NSNumber *)numberValueForKey:(id)key
{
  id obj = [self safeObjectForKey:key];
  
  if ([obj isKindOfClass:[NSNumber class]])
  {
    return (NSNumber *)obj;
  }
  
  return nil;
}

@end
