//
//  NSArray+Ext.h
//  Treasure
//
//  Created by xiayiyong on 15/7/1.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Ext)

/**
 *  如果index索引值下有元素，返回该元素，否则返回nil
 *
 *  @param index 索引
 *  @return 获取到的元素或者nil
 */
- (id)safeObjectAtIndex:(NSUInteger)index;

/**
 *  返回逆序排序的数组
 *
 *  @return 逆序排序的数组
 */
- (NSArray *)reversedArray;

/**
 *  返回逆序排序的数组
 *
 *  @return 逆序排序的数组
 */
+ (NSArray *)reversedArray:(NSArray *)array;

/**
 *  将数组转换成JSON字符串
 *
 *  @return JSON字符串或者nil（转换失败）
 */
- (NSString *)toJson;

/**
 *  将数组转换成JSON字符串
 *
 *  @return JSON字符串或者nil（转换失败）
 */
+ (NSString *)toJson:(NSArray *)array;

/**
 *  判断数组中是否包含string
 *
 *  @param string string
 *
 *  @return 包含的返回YES否则NO
 */
- (BOOL)isContainsString:(NSString *)string;

/**
 *  追加数据
 *
 *  @param newArray 追加的array
 *
 *  @return 最后得到的array
 */
-(NSArray *)appendArray:(NSArray *)newArray;


@end
