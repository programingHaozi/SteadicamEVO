//
//  UIButton+Ext.h
//  Treasure
//
//  Created by xiayiyong on 15/7/1.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Ext)

/*!
 * 设置按钮正常状态下的图片
 */
- (void)setNormalImage:(id)image;
- (void)setNormalBackgroundImage:(id)image;

/*!
 * 设置按钮Hightlighted状态下的图片
 */
- (void)setHightlightedImage:(id)image;
- (void)setHightlightedBackgroundImage:(id)image;

/*!
 * 设置按钮Selected状态下的图片
 */
- (void)setSelectedImage:(id)image;
- (void)setSelectedBackgroundImage:(id)image;

/*!
 * 设置按钮禁用状态下的图片
 */
- (void)setDisabledImage:(id)image;
- (void)setDisabledBackgroundImage:(id)image;

/*!
 * 设置按钮状态下的图片
 */
- (void)setNormalImage:(id)normalImage hightlightedImage:(id)hightlightedImage disabledImage:(id)disabledImage;
- (void)setNormalBackgroundImage:(id)normalImage hightlightedImage:(id)hightlightedImage disabledImage:(id)disabledImage;

/*!
 * 设置标题
 */
- (void)setNormalTitle:(NSString *)title;
- (void)setHighlightedTitle:(NSString *)title;
- (void)setSelectedTitle:(NSString *)title;

/*!
 * 设置标题颜色
 */
- (void)setNormalTitleColor:(UIColor *)titleColor;
- (void)setHighlightedTitleColor:(UIColor *)titleColor;
- (void)setSelectedTitleColor:(UIColor *)titleColor;

- (void)setNormalTitle:(NSString *)title textColor:(UIColor *)color;
- (void)setHighlightedTitle:(NSString *)title textColor:(UIColor *)color;
- (void)setSelectedTitle:(NSString *)title textColor:(UIColor *)color;

/*!
 * 设置按钮状态下的字体大小
 */
- (void)setFontSize:(CGFloat)fontSize;
- (void)setBoldFontSize:(CGFloat)boldFontSize;

- (void)setNormalImageWithName:(NSString *)imageName title:(NSString *)title isImageLeft:(BOOL)isLeft;

@end
