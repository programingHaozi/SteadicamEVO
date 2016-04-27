//
//  UIViewController+TFNavigationBarTransition.h
//
//  Copyright (c) 2016 Zhouqi Mo (https://github.com/MoZhouqi)
//

#import <UIKit/UIKit.h>

@interface UIViewController (TFNavigationBarTransition)

@property (nonatomic, strong) UINavigationBar *TF_transitionNavigationBar;
@property (nonatomic, assign) BOOL TF_prefersNavigationBarBackgroundViewHidden;

- (void)TF_addTransitionNavigationBarIfNeeded;

@end
