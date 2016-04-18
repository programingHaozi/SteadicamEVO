//
//  TFHubView.h
//  demo
//
//  Created by xiayiyong on 16/3/3.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFBaseLib.h"
#import "TFUILib.h"

@interface TFHubView : NSObject

@property (nonatomic)UIView *hubView;

/**
 *  显示的数字label字体
 */
@property (nonatomic, strong) UIFont *font;

/**
 *  显示的数字
 */
@property (nonatomic, assign) NSUInteger count;

/**
 *  初始化方法
 *
 *  @param view 把小圆点加到视图上
 *
 *  @return 
 */
- (id)initWithView:(UIView *)view;

/**
 *  把小圆点加到UIBarButtonItem上
 *
 *  @param barButtonItem
 *
 *  @return
 */
- (id)initWithBarButtonItem:(UIBarButtonItem *)barButtonItem;

/**
 *  设置圆点位置
 *
 *  @param frame 
 */
- (void)setCircleFrame:(CGRect)frame;

/**
 *  设置圆点背景色和字体颜色
 *
 *  @param circleColor 圆点背景
 *  @param labelColor  字体颜色
 */
- (void)setCircleColor:(UIColor*)circleColor textColor:(UIColor*)textColor;

/**
 *  移动小圆点位置
 *
 *  @param x x偏移量
 *  @param y y偏移量
 */
- (void)moveCircleByX:(CGFloat)x Y:(CGFloat)y;

/**
 *  小圆点按照缩放系数改变大小
 *
 *  @param scale 缩放系数
 */
- (void)scaleCircleBySize:(CGFloat)scale;

/**
 *  小圆点数值加1
 */
- (void)increment;

/**
 *  小圆点数值加
 *
 *  @param amount 增加的数
 */
- (void)incrementBy:(NSUInteger)amount;

/**
 *  小圆点数字减1
 */
- (void)decrement;

/**
 *  小圆点数值减
 *
 *  @param amount 减少的数
 */
- (void)decrementBy:(NSUInteger)amount;

/**
 *  隐藏数字
 */
- (void)hideCount;

/**
 *  显示数字
 */
- (void)showCount;

/**
 *  pop方式动画
 */
- (void)pop;
- (void)blink;
- (void)bump;

@end
