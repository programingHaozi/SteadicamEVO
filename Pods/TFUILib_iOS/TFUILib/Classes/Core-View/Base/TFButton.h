//
//  TFButton.h
//  TFUILib
//
//  Created by xiayiyong on 16/1/12.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TFAlignmentStatus)
{
   
    /**
     *  正常
     */
    TFAlignmentStatusNormal,
    
    /**
     *  图标在右，文本在左(左对齐)
     */
    TFAlignmentStatusLeft,
    
    /**
     *  图标在右，文本在左(居中对齐)
     */
    TFAlignmentStatusCenter,
    
    /**
     *  图标在右，文本在左(右对齐)
     */
    TFAlignmentStatusRight,
    
    /**
     *  图标在上，文本在下(居中)
     */
    TFAlignmentStatusTop,
    
    /**
     *  图标在下，文本在上(居中)
     */
    TFAlignmentStatusBottom,
};

@interface TFButton : UIButton

/**
 *  外界通过设置按钮的status属性，创建不同类型的按钮
 */
@property (nonatomic,assign)TFAlignmentStatus status;

/**
 *  文字和图片间距
 */
@property (nonatomic,assign)CGFloat gapBetween;

/**
 *  只在path形状内响应按钮的点击事件，可以随便自定义
 */
@property(nonatomic, strong) UIBezierPath *path;

/**
 *  初始化按钮设置图文排列方式
 *
 *  @param status 图文排列方式
 *
 *  @return TFButton
 */
- (instancetype)initWithAlignmentStatus:(TFAlignmentStatus)status;

- (instancetype)initWithFrame:(CGRect)frame alignmentStatus:(TFAlignmentStatus)status;

/**
 *  绑定点击事件
 *
 *  @param actionBlock 点击事件block
 */
- (void)touchAction:(void(^)())actionBlock;

/**
 *  设置title字体大小
 *
 *  @param fontSize 字体大小
 */
- (void)setFontSize:(CGFloat)fontSize;

/**
 *  设置按钮不同状态下的图片
 *
 *  @param normalImage       正常状态图片
 *  @param hightlightedImage 高亮状态图片
 *  @param disabledImage     禁用状态图片
 */
- (void)setNormalImage:(id)normalImage
     hightlightedImage:(id)hightlightedImage
         disabledImage:(id)disabledImage;

/**
 *  设置按钮不同状态下的图片
 *
 *  @param normalImage       正常状态背景图片
 *  @param hightlightedImage 高亮状态背景图片
 *  @param disabledImage     禁用状态背景图片
 */
- (void)setNormalBackgroundImage:(id)normalImage
     hightlightedBackgroundImage:(id)hightlightedImage
         disabledBackgroundImage:(id)disabledImage;

/**
 *  设置正常状态标题以及颜色
 *
 *  @param title 标题
 *  @param color 颜色
 */
- (void)setNormalTitle:(NSString *)title textFont:(UIFont *)font textColor:(UIColor *)color;

/**
 *  设置高亮状态标题以及颜色
 *
 *  @param title 标题
 *  @param color 颜色
 */
- (void)setHighlightedTitle:(NSString *)title textFont:(UIFont *)font textColor:(UIColor *)color;

/**
 *  设置选择状态标题以及颜色
 *
 *  @param title 标题
 *  @param color 颜色
 */
- (void)setSelectedTitle:(NSString *)title textFont:(UIFont *)font textColor:(UIColor *)color;

@end
