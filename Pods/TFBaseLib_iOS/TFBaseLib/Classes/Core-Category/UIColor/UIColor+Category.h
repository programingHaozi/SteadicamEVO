//
//  UIColor+Category.h
//
//  Created by xiayy on 12-9-3.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Category)

/**
 *  ColorSpaceModel
 */
@property (nonatomic, readonly) CGColorSpaceModel colorSpaceModel;

/**
 *  使用RGB
 */
@property (nonatomic, readonly) BOOL canProvideRGBComponents;

/**
 *  红色
 */
@property (nonatomic, readonly) CGFloat red;

/**
 *  绿色
 */
@property (nonatomic, readonly) CGFloat green;

/**
 *  蓝色
 */
@property (nonatomic, readonly) CGFloat blue;

/**
 *  白色
 */
@property (nonatomic, readonly) CGFloat white;

/**
 *  透明度
 */
@property (nonatomic, readonly) CGFloat alpha;

/**
 *  根据十六进制设置颜色
 *
 *  @param hex 十六进制
 *
 *  @return 颜色
 */
+ (UIColor *)colorWithHex:(unsigned int)hex;

/**
 *  根据十六进制设置颜色和透明度
 *
 *  @param hex   十六进制
 *  @param alpha 透明度
 *
 *  @return 颜色
 */
+ (UIColor *)colorWithHex:(unsigned int)hex alpha:(CGFloat)alpha;

/**
 *  根据十六进制设置颜色
 *
 *  @param hex 十六进制
 *
 *  @return 颜色
 */
+ (UIColor*)colorWithHexString:(NSString*)hex;

/**
 *  根据十六进制设置颜色和透明度
 *
 *  @param hex   十六进制
 *  @param alpha 透明度
 *
 *  @return 颜色
 */
+ (UIColor*)colorWithHexString:(NSString*)hex alpha:(CGFloat)alpha;

/**
 *  获取随机颜色
 *
 *  @return 颜色
 */
+ (UIColor *)randomColor;

/**
 *  设置颜色的透明度
 *
 *  @param color 颜色值
 *  @param alpha 透明度
 *
 *  @return 返回的颜色
 */
+ (UIColor *)colorWithColor:(UIColor *)color alpha:(float)alpha;


@end
