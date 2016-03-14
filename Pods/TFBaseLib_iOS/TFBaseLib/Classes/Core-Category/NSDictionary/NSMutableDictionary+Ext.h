//
//  NSMutableDictionary+Ext.h
//  Treasure
//
//  Created by xiayiyong on 15/2/13.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Ext)

/**
 *  数组的深拷贝
 *
 *  @return 拷贝后的数组
 */
- (NSMutableDictionary *)mutableDeepCopy;

/**
 *  保存值时防止崩溃
 *
 *  @param anObject 保存的对象
 *  @param aKey     键值
 */
- (void)setSafeObject:(id)anObject forKey:(id<NSCopying>)aKey;

/**
 *  保存int值时防止崩溃
 *
 *  @param intValue int值
 *  @param aKey     键值
 */
- (void)setInt:(int)intValue forKey:(id<NSCopying>)aKey;

/**
 *  保存double值时防止崩溃
 *
 *  @param doubleValue doubleValue
 *  @param aKey        aKey
 */
- (void)setDouble:(double)doubleValue forKey:(id<NSCopying>)aKey;

/**
 *  保存float值时防止崩溃
 *
 *  @param floatValue floatValue
 *  @param aKey       aKey 
 */
- (void)setFloat:(float)floatValue forKey:(id<NSCopying>)aKey;

@end
