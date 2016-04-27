//
//  UIViewController+TFNavigationBarTransition.m
//
//  Copyright (c) 2016 Zhouqi Mo (https://github.com/MoZhouqi)
//

#import "UIViewController+TFNavigationBarTransition.h"
#import <objc/runtime.h>
#import "TFSwizzle.h"
#import "UINavigationController+TFNavigationBarTransition.h"

@implementation UIViewController (TFNavigationBarTransition)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        TFSwizzleMethod([self class],
                        @selector(viewWillLayoutSubviews),
                        @selector(TF_viewWillLayoutSubviews));
        
        TFSwizzleMethod([self class],
                        @selector(viewDidAppear:),
                        @selector(TF_viewDidAppear:));
    });
}

- (void)TF_viewDidAppear:(BOOL)animated {
    if (self.TF_transitionNavigationBar) {
        self.navigationController.navigationBar.barTintColor = self.TF_transitionNavigationBar.barTintColor;
        [self.navigationController.navigationBar setBackgroundImage:[self.TF_transitionNavigationBar backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:self.TF_transitionNavigationBar.shadowImage];
        
        [self.TF_transitionNavigationBar removeFromSuperview];
        self.TF_transitionNavigationBar = nil;
    }
    self.TF_prefersNavigationBarBackgroundViewHidden = NO;
    [self TF_viewDidAppear:animated];
}

- (void)TF_viewWillLayoutSubviews {
    id<UIViewControllerTransitionCoordinator> tc = self.transitionCoordinator;
    UIViewController *fromViewController = [tc viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [tc viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if ([self isEqual:self.navigationController.viewControllers.lastObject] && [toViewController isEqual:self]) {
        if (self.navigationController.navigationBar.translucent) {
            [tc containerView].backgroundColor = [self.navigationController TF_containerViewBackgroundColor];
        } else {
            fromViewController.view.clipsToBounds = NO;
            toViewController.view.clipsToBounds = NO;
        }
        if (!self.TF_transitionNavigationBar) {
            [self TF_addTransitionNavigationBarIfNeeded];
            
            self.TF_prefersNavigationBarBackgroundViewHidden = YES;
        }
        [self TF_resizeTransitionNavigationBarFrame];
    }
    [self TF_viewWillLayoutSubviews];
}

- (void)TF_resizeTransitionNavigationBarFrame {
    if (!self.view.window) {
        return;
    }
    UIView *backgroundView = [self.navigationController.navigationBar valueForKey:@"_backgroundView"];
    CGRect rect = [backgroundView.superview convertRect:backgroundView.frame toView:self.view];
    self.TF_transitionNavigationBar.frame = rect;
}

- (void)TF_addTransitionNavigationBarIfNeeded {
    if (!self.view.window) {
        return;
    }
    if (!self.navigationController.navigationBar) {
        return;
    }
    UINavigationBar *bar = [[UINavigationBar alloc] init];
    bar.barStyle = self.navigationController.navigationBar.barStyle;
    if (bar.translucent != self.navigationController.navigationBar.translucent) {
        bar.translucent = self.navigationController.navigationBar.translucent;
    }
    bar.barTintColor = self.navigationController.navigationBar.barTintColor;
    [bar setBackgroundImage:[self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
    bar.shadowImage = self.navigationController.navigationBar.shadowImage;
    [self.TF_transitionNavigationBar removeFromSuperview];
    self.TF_transitionNavigationBar = bar;
    [self TF_resizeTransitionNavigationBarFrame];
    if (!self.navigationController.navigationBarHidden && !self.navigationController.navigationBar.hidden) {
        [self.view addSubview:self.TF_transitionNavigationBar];
    }
}

- (UINavigationBar *)TF_transitionNavigationBar {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTF_transitionNavigationBar:(UINavigationBar *)navigationBar {
    objc_setAssociatedObject(self, @selector(TF_transitionNavigationBar), navigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)TF_prefersNavigationBarBackgroundViewHidden {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setTF_prefersNavigationBarBackgroundViewHidden:(BOOL)hidden {
    [[self.navigationController.navigationBar valueForKey:@"_backgroundView"]
     setHidden:hidden];
    objc_setAssociatedObject(self, @selector(TF_prefersNavigationBarBackgroundViewHidden), @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
