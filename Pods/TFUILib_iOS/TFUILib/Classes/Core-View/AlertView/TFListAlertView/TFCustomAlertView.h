//
//  TFCustomAlertView.h
//  babyincar-toc-iphone
//
//  Created by Xuehan Gong on 14-10-9.
//  Copyright (c) 2014年 Chexiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFView.h"

/**
 *  TFCustomAlertView位置
 */
typedef NS_ENUM(NSUInteger,  TFCustomAlertViewPosition) {
    /**
     *  顶部
     */
    TFCustomAlertViewPositionTop = 0,
    /**
     *  中部
     */
    TFCustomAlertViewPositionMiddle,
    /**
     *  底部
     */
    TFCustomAlertViewPositionBottom,
    /**
     *  任意
     */
    TFCustomAlertViewPositionFree,
};

/**
 *  TFCustomAlertView
 */
@interface TFCustomAlertView : TFView <UIGestureRecognizerDelegate>

/**
 *  阴影的背景透明度
 */
@property (nonatomic, assign) CGFloat shadowOpacity;

/**
 *  阴影的背景色
 */
@property (nonatomic, strong) UIColor *shadowColor;

/**
 *  展示内容
 */
@property (nonatomic, strong) UIView *contentView;

/**
 *  容器是否需要背景色(毛玻璃背景)，kShowAlertPositionMiddle默认值为NO, 其余为YES
 */
@property (nonatomic, assign) BOOL needBackground;

/**
 *  AlertView的类型，决定了弹出方式动画和位置。
 */
@property (nonatomic, assign) TFCustomAlertViewPosition showPosition;

/**
 *  根据传入的showPosition类型，有一组预设的坐标，但是也可以手动修改。在show或者showInView:之前，否则无效。
 */
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint targetPoint;

/**
 *  创建一个AlertView容器，包含弹出的动画效果和预设的一组坐标值。
 *
 *  @param frame    容器的frame。
 *  @param position AlertView的展示类型，不同类型的弹出动画效果不同。
 *
 *  @return 返回一个TFCustomAlertView容器对象。
 */
- (id)initWithContentFrame:(CGRect)frame position:(TFCustomAlertViewPosition)position;

/**
 *  创建一个AlertView容器，包含弹出的动画效果和预设的一组坐标值。
 *
 *  @param contentView 内容视图
 *  @param position    位置
 *
 *  @return 返回一个TFCustomAlertView容器对象。
 */
- (id)initWithContentView:(UIView *)contentView position:(TFCustomAlertViewPosition)position;

/**
 *  在某视图上显示
 *
 *  @param view 视图
 */
- (void)showInView:(UIView *)view;

/**
 *  如果 superView为空的话，会addSubView到window上。
 */
- (void)show;

/**
 *  隐藏
 */
- (void)hide;

@end
