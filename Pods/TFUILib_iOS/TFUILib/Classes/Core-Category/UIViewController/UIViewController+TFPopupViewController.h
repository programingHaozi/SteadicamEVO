//
//  UIViewController+TFPopupViewController.h
//  TFPopupViewController
//
//  Created by xiayiyong on 15/3/4.
//  Copyright (c) 2015年 xiayiyong. All rights reserved.
//  from https://github.com/pljhonglu/LewPopupViewController
//

#import <UIKit/UIKit.h>

@interface TFPopupBackgroundView : UIView

@end

@protocol TFPopupAnimation <NSObject>

@required
- (void)showView:(UIView*)popupView overlayView:(UIView*)overlayView;

- (void)dismissView:(UIView*)popupView overlayView:(UIView*)overlayView completion:(void (^)(void))completion;

@end

@interface UIViewController (TFPopupViewController)

@property (nonatomic, retain, readonly) UIView *popupView;
@property (nonatomic, retain, readonly) UIView *overlayView;

- (void)presentPopupView:(UIView *)popupView animation:(id<TFPopupAnimation>)animation;

- (void)presentPopupView:(UIView *)popupView animation:(id<TFPopupAnimation>)animation dismissed:(void(^)(void))dismissed;

- (void)presentPopupView:(UIView *)popupView animation:(id<TFPopupAnimation>)animation backgroundClickable:(BOOL)clickable;

- (void)presentPopupView:(UIView *)popupView animation:(id<TFPopupAnimation>)animation backgroundClickable:(BOOL)clickable dismissed:(void(^)(void))dismissed;

- (void)dismissPopupView;

- (void)dismissPopupViewWithanimation:(id<TFPopupAnimation>)animation;

@end

#pragma mark - 
@interface UIView (TFPopupViewController)

@property (nonatomic, weak, readonly) UIViewController *popupViewController;

@end