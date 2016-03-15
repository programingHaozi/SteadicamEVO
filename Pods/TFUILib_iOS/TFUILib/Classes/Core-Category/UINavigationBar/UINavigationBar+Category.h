//
//  UINavigationBar+Category.h
//  TFUILib
//
//  Created by 张国平 on 16/3/14.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (Category)

/**
 *  设置背景颜色
 *
 *  @param backgroundColor 背景颜色值
 */
- (void)setBgColor:(UIColor *)backgroundColor;

/**
 *  设置透明度
 *
 *  @param alpha 透明度
 */
- (void)setElementsAlpha:(CGFloat)alpha;

/**
 *  设置translationY
 *
 *  @param translationY translationY
 */
- (void)setTranslationY:(CGFloat)translationY;

/**
 *  回复默认
 */
- (void)reset;

@end
