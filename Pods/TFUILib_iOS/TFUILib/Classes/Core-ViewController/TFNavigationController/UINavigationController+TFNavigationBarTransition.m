//
//  UINavigationController+TFNavigationBarTransition.m
//
//  Copyright (c) 2016 Zhouqi Mo (https://github.com/MoZhouqi)
//

#import "UINavigationController+TFNavigationBarTransition.h"
#import "UIViewController+TFNavigationBarTransition.h"
#import <objc/runtime.h>
#import "TFSwizzle.h"

@implementation UINavigationController (TFNavigationBarTransition)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        TFSwizzleMethod([self class],
                        @selector(pushViewController:animated:),
                        @selector(TF_pushViewController:animated:));
        
        TFSwizzleMethod([self class],
                        @selector(popViewControllerAnimated:),
                        @selector(TF_popViewControllerAnimated:));
        
        TFSwizzleMethod([self class],
                        @selector(popToViewController:animated:),
                        @selector(TF_popToViewController:animated:));
        
        TFSwizzleMethod([self class],
                        @selector(popToRootViewControllerAnimated:),
                        @selector(TF_popToRootViewControllerAnimated:));
    });
}

- (UIColor *)TF_containerViewBackgroundColor {
    return [UIColor whiteColor];
}

- (void)TF_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UIViewController *disappearingViewController = self.viewControllers.lastObject;
    if (!disappearingViewController) {
        return [self TF_pushViewController:viewController animated:animated];
    }
    [disappearingViewController TF_addTransitionNavigationBarIfNeeded];
    if (animated) {
        disappearingViewController.TF_prefersNavigationBarBackgroundViewHidden = YES;
    }
    return [self TF_pushViewController:viewController animated:animated];
}

- (UIViewController *)TF_popViewControllerAnimated:(BOOL)animated {
    if (self.viewControllers.count < 2) {
        return [self TF_popViewControllerAnimated:animated];
    }
    UIViewController *disappearingViewController = self.viewControllers.lastObject;
    [disappearingViewController TF_addTransitionNavigationBarIfNeeded];
    UIViewController *appearingViewController = self.viewControllers[self.viewControllers.count - 2];
    if (appearingViewController.TF_transitionNavigationBar) {
        UINavigationBar *appearingNavigationBar = appearingViewController.TF_transitionNavigationBar;
        self.navigationBar.barTintColor = appearingNavigationBar.barTintColor;
        [self.navigationBar setBackgroundImage:[appearingNavigationBar backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
        self.navigationBar.shadowImage = appearingNavigationBar.shadowImage;
    }
    if (animated) {
        disappearingViewController.TF_prefersNavigationBarBackgroundViewHidden = YES;
    }
    return [self TF_popViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)TF_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (![self.viewControllers containsObject:viewController] || self.viewControllers.count < 2) {
        return [self TF_popToViewController:viewController animated:animated];
    }
    UIViewController *disappearingViewController = self.viewControllers.lastObject;
    [disappearingViewController TF_addTransitionNavigationBarIfNeeded];
    if (viewController.TF_transitionNavigationBar) {
        UINavigationBar *appearingNavigationBar = viewController.TF_transitionNavigationBar;
        self.navigationBar.barTintColor = appearingNavigationBar.barTintColor;
        [self.navigationBar setBackgroundImage:[appearingNavigationBar backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
        self.navigationBar.shadowImage = appearingNavigationBar.shadowImage;
    }
    if (animated) {
        disappearingViewController.TF_prefersNavigationBarBackgroundViewHidden = YES;
    }
    return [self TF_popToViewController:viewController animated:animated];
}

- (NSArray<UIViewController *> *)TF_popToRootViewControllerAnimated:(BOOL)animated {
    if (self.viewControllers.count < 2) {
        return [self TF_popToRootViewControllerAnimated:animated];
    }
    UIViewController *disappearingViewController = self.viewControllers.lastObject;
    [disappearingViewController TF_addTransitionNavigationBarIfNeeded];
    UIViewController *rootViewController = self.viewControllers.firstObject;
    if (rootViewController.TF_transitionNavigationBar) {
        UINavigationBar *appearingNavigationBar = rootViewController.TF_transitionNavigationBar;
        self.navigationBar.barTintColor = appearingNavigationBar.barTintColor;
        [self.navigationBar setBackgroundImage:[appearingNavigationBar backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
        self.navigationBar.shadowImage = appearingNavigationBar.shadowImage;
    }
    if (animated) {
        disappearingViewController.TF_prefersNavigationBarBackgroundViewHidden = YES;
    }
    return [self TF_popToRootViewControllerAnimated:animated];
}

@end
