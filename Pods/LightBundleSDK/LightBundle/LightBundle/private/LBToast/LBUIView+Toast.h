//
//  UIView+Toast.h
//  Grape-ToC-Iphone
//
//  Created by Xuehan Gong on 14-5-30.
//  Copyright (c) 2014年 Chexiang. All rights reserved.
//

#import <UIKit/UIKit.h>

static const NSInteger  LBGrapeToastTag              = 10086;

@interface UIView (Toast)

/**
 *  根据内容创建一个提示框
 */
- (UIView *)toastForMessage:(NSString *)message oldToast:(UIView *)oldToast;

/**
 *  显示提示框的动画效果
 */
- (void)showToast:(UIView *)view;

/**
 *  隐藏
 */
- (void)hideToast:(UIView *)toast animation:(BOOL)animation;

- (void)showToast:(UIView *)toast duration:(CGFloat)interval position:(id)point;

@end
