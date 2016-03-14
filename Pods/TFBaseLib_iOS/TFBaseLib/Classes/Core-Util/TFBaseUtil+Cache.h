//
//  TFBaseUtil+Cache.h
//  TFBaseLib
//
//  Created by xiayiyong on 15/10/14.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFBaseUtil.h"

/**
 *  信息本地化,存对象
 *
 *  @param value 要存的值
 *  @param key   key
 */
void tf_saveValue(id value, NSString *key);

/**
 *  信息本地化 获取对象
 *
 *  @param key key
 *
 *  @return 获取到的对象
 */
id tf_getValueWithKey(NSString *key);

/**
 *  保存对象 需要实现方法 - (void)encodeWithCoder:(NSCoder *)encoder  (id)initWithCoder:(NSCoder *)decoder
 *
 *  @param obj 要保存的对象
 *  @param key key
 */
void tf_saveObject(id obj, NSString *key);

/**
 *  获取本地化的对象
 *
 *  @param key key
 *
 *  @return 获取到的对象
 */
id tf_getObjectWithKey(NSString *key);

/**
 *  按照key值删除
 *
 *  @param key key值
 */
void tf_removeObjectWithKey(NSString *key);

@interface TFBaseUtil (Cache)

/**
 *  信息本地化,存数据
 *
 *  @param value 要存的数据
 *  @param key   key
 */
+ (void) saveValue:(id)value key:(NSString *)key;

/**
 *  信息本地化,获取数据
 *
 *  @param key key值
 *
 *  @return 获取到的数据
 */
+ (id) getValueWithKey:(NSString *)key;

/**
 *  保存对象 需要实现方法 - (void)encodeWithCoder:(NSCoder *)encoder  (id)initWithCoder:(NSCoder *)decoder
 *
 *  @param obj 要保存的对象
 *  @param key key
 */
+ (void)saveObject:(id)obj key:(NSString *)key;

/**
 *  获取本地化的对象
 *
 *  @param key key
 *
 *  @return 获取到的对象
 */
+ (id)getObjectWithKey:(NSString *)key;

/**
 *  按照key值删除
 *
 *  @param key key
 */
+ (void) removeObjectWithKey:(NSString *)key;


@end
