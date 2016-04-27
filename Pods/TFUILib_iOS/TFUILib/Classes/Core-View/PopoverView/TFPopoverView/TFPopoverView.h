//
//  TFPopoverView.h
//  TFUILib
//
//  Created by xiayiyong on 16/4/7.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//
//  https://github.com/xiekw2010/DXPopover

#import "TFView.h"

/**
 *  箭头的位置
 */
typedef NS_ENUM(NSUInteger, TFPopoverViewPosition)
{
    /**
     *  在上边
     */
    kPopoverViewPositionUp = 1,
    /**
     *  在下边
     */
    kPopoverViewPositionDown,
};

/**
 *  背景遮层的颜色
 */
typedef NS_ENUM(NSUInteger, TFPopoverViewMaskType)
{
    /**
     *  黑色
     */
    kPopoverViewrMaskTypeBlack,
    /**
     *  没有颜色
     */
    kPopoverViewMaskTypeNone,
};


@interface TFPopoverView : TFView

/**
 *  显示内容view的位置，默认是0
 */
@property (nonatomic, assign) UIEdgeInsets contentInset;

/**
 *  箭头的位置
 */
@property (nonatomic, assign, readonly) TFPopoverViewPosition popoverPosition;

/**
 *  箭头的大小, 默认 {10.0, 10.0};
 */
@property (nonatomic, assign) CGSize arrowSize;

/**
 *  设置圆角 默认 7.0;
 */
@property (nonatomic, assign) CGFloat cornerRadius;

/**
 *  显示动画时间 默认0.4;
 */
@property (nonatomic, assign) CGFloat animationIn;

/**
 *  消失动画 默认 0.3;
 */
@property (nonatomic, assign) CGFloat animationOut;

/**
 *  是否有弹跳动画 默认YES;
 */
@property (nonatomic, assign) BOOL animationSpring;

/**
 *  背景遮层的样式 默认KPopoverViewrMaskTypeBlack;
 */
@property (nonatomic, assign) TFPopoverViewMaskType maskType;

/**
 *  背景遮层的Control可以自定义事件
 */
@property (nonatomic, strong, readonly) UIControl *blackOverlay;

/**
 *  是否显示阴影
 */
@property (nonatomic, assign) BOOL applyShadow;

/**
 *  显示的block
 */
@property (nonatomic, copy) dispatch_block_t didShowHandler;

/**
 *  消失的block
 */
@property (nonatomic, copy) dispatch_block_t didDismissHandler;

#pragma mark- atpoint

/**
 *  显示
 *
 *  @param point         开始的位置.
 *  @param position      箭头的位置
 *  @param contentView   呈现的view
 *  @param containerView 显示内容的view
 */
- (void)showAtPoint:(CGPoint)point
             inView:(UIView *)containerView
withContentView:(UIView *)contentView
     popoverPostion:(TFPopoverViewPosition)position;

/**
 *  显示
 *
 *  @param point         开始的位置.
 *  @param position      箭头的位置
 *  @param contentView   呈现的view
 *  @param containerView 显示内容的view
 */
- (void)showAtPoint:(CGPoint)point
             inView:(UIView *)containerView
withText:(NSAttributedString *)text
     popoverPostion:(TFPopoverViewPosition)position;

- (void)showAtPoint:(CGPoint)point
             inView:(UIView *)containerView
    withContentView:(UIView *)contentView;

- (void)showAtPoint:(CGPoint)point
             inView:(UIView *)containerView
           withText:(NSAttributedString *)text;

#pragma mark- atview

- (void)showAtView:(UIView *)atView
             inView:(UIView *)containerView
    withContentView:(UIView *)contentView
     popoverPostion:(TFPopoverViewPosition)position;

- (void)showAtView:(UIView *)atView
            inView:(UIView *)containerView
   withText:(NSAttributedString *)text
    popoverPostion:(TFPopoverViewPosition)position;

- (void)showAtView:(UIView *)atView
            inView:(UIView *)containerView
          withContentView:(UIView *)contentView;

- (void)showAtView:(UIView *)atView
            inView:(UIView *)containerView
          withText:(NSAttributedString *)text;

/**
 *  消失
 */
- (void)dismiss;


@end
