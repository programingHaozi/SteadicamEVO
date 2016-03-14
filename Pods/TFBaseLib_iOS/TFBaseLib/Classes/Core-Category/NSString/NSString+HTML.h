//
//  NSString+HTML.h
//  Treasure
//
//  Created by xiayiyong on 15/9/9.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HTML)

/*!
 * 过滤掉HTML标签
 *
 * @param html HTML内容
 * @param 返回喜欢去掉所有HTML标签后的字符串
 */
- (NSString *)filteredHtml;
/*!
 * 过滤掉HTML标签
 *
 * @param html HTML内容
 * @param 返回喜欢去掉所有HTML标签后的字符串
 */
+ (NSString *)filterHTML:(NSString *)html;

/**
 *  去掉html格式
 *
 *  @return 处理完后的数据
 */
- (NSString *)removeHtmlFormat;

@end
