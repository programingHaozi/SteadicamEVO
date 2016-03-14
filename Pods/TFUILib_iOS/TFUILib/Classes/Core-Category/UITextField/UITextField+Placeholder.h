//
//  UITextField+Placeholder.h
//  Treasure
//
//  Created by xiayiyong on 15/7/1.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Placeholder)

/**
 * 设置占位符的文字颜色
 *
 * @param placeholderColor 新颜色
 */
- (void)setPlaceholderColor:(UIColor *)placeholderColor;

/**
 * 设置占位符的文字字体
 *
 * @param placeholderFont 新字体
 */
- (void)setPlaceholderFont:(UIFont *)placeholderFont;

@end
