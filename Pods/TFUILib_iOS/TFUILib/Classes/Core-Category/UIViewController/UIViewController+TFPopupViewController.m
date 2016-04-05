//
//  UIViewController+TFPopupViewController.m
//  TFPopupViewController
//
//  Created by xiayiyong on 15/3/4.
//  Copyright (c) 2015年 xiayiyong. All rights reserved.
//

#import "UIViewController+TFPopupViewController.h"
#import <objc/runtime.h>

#define kTFPopupView @"kTFPopupView"
#define kTFOverlayView @"kTFOverlayView"
#define kTFPopupViewDismissedBlock @"kTFPopupViewDismissedBlock"
#define KTFPopupAnimation @"KTFPopupAnimation"
#define kTFPopupViewController @"kTFPopupViewController"

#define kTFPopupViewTag 8002
#define kTFOverlayViewTag 8003

#pragma mark - TFPopupBackgroundView

@implementation TFPopupBackgroundView

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    size_t locationsCount = 2;
    CGFloat locations[2] = {0.0f, 1.0f};
    CGFloat colors[8] = {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.75f};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, locationsCount);
    CGColorSpaceRelease(colorSpace);
    
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    float radius = MIN(self.bounds.size.width , self.bounds.size.height) ;
    CGContextDrawRadialGradient (context, gradient, center, 0, center, radius, kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient);
}

@end

#pragma mark - UIViewController+TFPopupViewController

@implementation UIViewController (TFPopupViewController)

#pragma public method

- (void)presentPopupView:(UIView *)popupView animation:(id<TFPopupAnimation>)animation{
    [self _presentPopupView:popupView animation:animation backgroundClickable:YES dismissed:nil];
}

- (void)presentPopupView:(UIView *)popupView animation:(id<TFPopupAnimation>)animation dismissed:(void (^)(void))dismissed{
    [self _presentPopupView:popupView animation:animation backgroundClickable:YES dismissed:dismissed];
}

- (void)presentPopupView:(UIView *)popupView animation:(id<TFPopupAnimation>)animation backgroundClickable:(BOOL)clickable{
    [self _presentPopupView:popupView animation:animation backgroundClickable:clickable dismissed:nil];
}

- (void)presentPopupView:(UIView *)popupView animation:(id<TFPopupAnimation>)animation backgroundClickable:(BOOL)clickable dismissed:(void (^)(void))dismissed{
    [self _presentPopupView:popupView animation:animation backgroundClickable:clickable dismissed:dismissed];
}

- (void)dismissPopupViewWithanimation:(id<TFPopupAnimation>)animation
{
    [self _dismissPopupViewWithAnimation:animation];
}

- (void)dismissPopupView
{
    [self _dismissPopupViewWithAnimation:self.popupAnimation];
}

#pragma mark - geter setter
- (UIView *)popupView
{
    return objc_getAssociatedObject(self, kTFPopupView);
}

- (void)setPopupView:(UIView *)popupView
{
    objc_setAssociatedObject(self, kTFPopupView, popupView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)overlayView
{
    return objc_getAssociatedObject(self, kTFOverlayView);
}

- (void)setOverlayView:(UIView *)overlayView
{
    objc_setAssociatedObject(self, kTFOverlayView, overlayView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void(^)(void))dismissCallback
{
    return objc_getAssociatedObject(self, kTFPopupViewDismissedBlock);
}

- (void)setDismissCallback:(void (^)(void))dismissCallback
{
    objc_setAssociatedObject(self, kTFPopupViewDismissedBlock, dismissCallback, OBJC_ASSOCIATION_COPY);
}

- (id<TFPopupAnimation>)popupAnimation
{
    return objc_getAssociatedObject(self, KTFPopupAnimation);
}

- (void)setPopupAnimation:(id<TFPopupAnimation>)TFPopupAnimation
{
    objc_setAssociatedObject(self, KTFPopupAnimation, TFPopupAnimation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - view handle

- (void)_presentPopupView:(UIView*)popupView animation:(id<TFPopupAnimation>)animation backgroundClickable:(BOOL)clickable dismissed:(void(^)(void))dismissed{

    // check if source view controller is not in destination
    if ([self.overlayView.subviews containsObject:popupView]) return;
    
    // fix issue #2
    if (self.overlayView && self.overlayView.subviews.count > 1) {
        [self _dismissPopupViewWithAnimation:nil];
    }
    
    self.popupView = nil;
    self.popupView = popupView;
    self.popupAnimation = nil;
    self.popupAnimation = animation;
    
    UIView *sourceView = [self _lew_topView];

    // customize popupView
    popupView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    popupView.tag = kTFPopupViewTag;
    popupView.layer.shadowPath = [UIBezierPath bezierPathWithRect:popupView.bounds].CGPath;
    popupView.layer.masksToBounds = NO;
    popupView.layer.shadowOffset = CGSizeMake(5, 5);
    popupView.layer.shadowRadius = 5;
    popupView.layer.shadowOpacity = 0.5;
    popupView.layer.shouldRasterize = YES;
    popupView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    // Add overlay
    if (self.overlayView == nil)
    {
        UIView *overlayView = [[UIView alloc] initWithFrame:sourceView.bounds];
        overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        overlayView.tag = kTFOverlayViewTag;
        overlayView.backgroundColor = [UIColor clearColor];
        
        // BackgroundView
        UIView *backgroundView = [[TFPopupBackgroundView alloc] initWithFrame:sourceView.bounds];
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        backgroundView.backgroundColor = [UIColor clearColor];
        [overlayView addSubview:backgroundView];
        
        // Make the Background Clickable
        if (clickable)
        {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissPopupView)];
            [backgroundView addGestureRecognizer:tap];
        }
        self.overlayView = overlayView;
    }
    
    [self.overlayView addSubview:popupView];
    [sourceView addSubview:self.overlayView];

    self.overlayView.alpha = 1.0f;
    popupView.center = self.overlayView.center;
    if (animation)
    {
        [animation showView:popupView overlayView:self.overlayView];
    }
    
    [self setDismissCallback:dismissed];

}

- (void)_dismissPopupViewWithAnimation:(id<TFPopupAnimation>)animation
{
    if (animation)
    {
        [animation dismissView:self.popupView overlayView:self.overlayView completion:^(void) {
            [self.overlayView removeFromSuperview];
            [self.popupView removeFromSuperview];
            self.popupView = nil;
            self.popupAnimation = nil;
            
            id dismissed = [self dismissCallback];
            if (dismissed != nil)
            {
                ((void(^)(void))dismissed)();
                [self setDismissCallback:nil];
            }
        }];
    }
    else
    {
        [self.overlayView removeFromSuperview];
        [self.popupView removeFromSuperview];
        self.popupView = nil;
        self.popupAnimation = nil;
        
        id dismissed = [self dismissCallback];
        if (dismissed != nil)
        {
            ((void(^)(void))dismissed)();
            [self setDismissCallback:nil];
        }
    }
}

-(UIView*)_lew_topView
{
    UIViewController *recentView = self;
    
    while (recentView.parentViewController != nil)
    {
        recentView = recentView.parentViewController;
    }
    return recentView.view;
}

@end

#pragma mark - UIView+TFPopupViewController

@implementation UIView (TFPopupViewController)
- (UIViewController *)popupViewController
{
    return objc_getAssociatedObject(self, kTFPopupViewController);
}

- (void)setPopupViewController:(UIViewController * _Nullable)popupViewController
{
    objc_setAssociatedObject(self, kTFPopupViewController, popupViewController, OBJC_ASSOCIATION_ASSIGN);
}
@end


#pragma mark - UIView+TFPopupViewControllerPrivate

@interface UIView (TFPopupViewControllerPrivate)

@property (nonatomic, weak, readwrite) UIViewController *popupViewController;

@end

#pragma mark - UIViewController+TFPopupViewControllerPrivate

@interface UIViewController (TFPopupViewControllerPrivate)

@property (nonatomic, retain) UIView *popupView;
@property (nonatomic, retain) UIView *overlayView;
@property (nonatomic, copy) void(^dismissCallback)(void);
@property (nonatomic, retain) id<TFPopupAnimation> popupAnimation;

- (UIView*)topView;

@end