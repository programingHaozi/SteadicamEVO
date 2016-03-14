//
//  NSDictionary+Ext.h
//  Treasure
//
//  Created by xiayiyong on 15/7/1.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Ext)

/*!
 * 把格式化的JSON格式的字符串转换成字典
 *
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/*!
 * 获取JSON字符串
 *
 * @return 把字典转换成JSON串
 */
- (NSString *)jsonString;

/*!
 * 根据key获取值
 *
 * @return 如果存在，返回value，否则返回nil，表示不存在或者是空
 */
- (id)safeObjectForKey:(id<NSCopying>)aKey;

/**
 *  根据key取int值
 *
 *  @param key key
 *
 *  @return 返回int值
 */
- (int)intValueForKey:(id)key;

/**
 *  根据key取double值
 *
 *  @param key key
 *
 *  @return 返回double值
 */
- (double)doubleValueForKey:(id)key;

/**
 *  根据key取float值
 *
 *  @param key key
 *
 *  @return 返回float值
 */
- (float)floatValueForKey:(id)key;

/**
 *  根据key取NSInteger值
 *
 *  @param key key
 *
 *  @return 返回NSInteger值
 */
- (NSInteger)integerValueForKey:(id)key;

/**
 *  根据key取NSString值
 *
 *  @param key key
 *
 *  @return 返回NSString值
 */
- (NSString *)stringValueForKey:(id)key;

/**
 *  根据key取NSDictionary值
 *
 *  @param key key
 *
 *  @return 返回NSDictionary值
 */
- (NSDictionary *)dictionaryValueForKey:(id)key;

/**
 *  根据key取NSArray值
 *
 *  @param key key
 *
 *  @return 返回NSArray值
 */
- (NSArray *)arrayValueForKey:(id)key;

/**
 *  根据key取NSNumber值
 *
 *  @param key key
 *
 *  @return 返回NSNumber值
 */
- (NSNumber *)numberValueForKey:(id)key;

@end
