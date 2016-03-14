//
//  NSString+Path.h
//  Treasure
//
//  Created by xiayiyong on 15/9/9.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Path)

/*!
 * @brief  根据文件名返回文件的路径
 * @param  fileName 文件名(使用type参数，就不能加后缀)
 * @param  type     文件后缀名
 * @return 如果文件路径存在，则返回该文件路径，否则返回nil
 */
+ (NSString *)pathWithFileName:(NSString *)fileName;

/**
 *  根据文件名和类型返回文件的路径
 *
 *  @param fileName 文件名
 *  @param type     文件后缀名
 *
 *  @return 如果文件路径存在，则返回该文件路径，否则返回nil
 */
+ (NSString *)pathWithFileName:(NSString *)fileName ofType:(NSString *)type;

/*!
 * @brief 获取Documents/tmp/Cache路径
 */
+ (NSString *)documentPath;

/**
 *  获取tmp路径
 *
 *  @return 路径地址
 */
+ (NSString *)tmpPath;

/**
 *  获取cache路径
 *
 *  @return 路径
 */
+ (NSString *)cachePath;

@end
