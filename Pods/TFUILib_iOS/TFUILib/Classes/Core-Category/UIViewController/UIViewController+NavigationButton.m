//
//  UIViewController+NavigationButton.m
//  TFUILib
//
//  Created by xiayiyong on 16/3/21.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import <objc/runtime.h>
#import "UIViewController+NavigationButton.h"
#import "UIViewController+Push.h"
#import "TFUIUtil.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@implementation UIViewController (NavigationButton)

@dynamic navigationBarHidden;

#pragma mark init button

- (void)initMiddleView:(UIView*)view
{
    self.navigationItem.titleView = view;
}

- (void)initLeftImage:(NSString *)strImage
{
    CGRect rect   = CGRectMake(0, -2*SCREEN_WIDTH/320, 60, 44);
    UIButton *btn = [[UIButton alloc] initWithFrame:rect];
    
    [btn addTarget:self action:@selector(leftButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateHighlighted];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)initLeftImage:(NSString *)strImage selector:(SEL)selector
{
    CGRect rect   = CGRectMake(0, -2*SCREEN_WIDTH/320, 60, 44);
    UIButton *btn = [[UIButton alloc] initWithFrame:rect];
    
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateHighlighted];
    btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    btn.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)initLeftTitle:(NSString *)strTitle
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
    
    [btn setTitle:strTitle forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [btn sizeToFit];
    [btn addTarget:self action:@selector(leftButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [btn setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
    
}

- (void)initLeftTitle:(NSString *)strTitle selector:(SEL)selector
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
    
    [btn setTitle:strTitle forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [btn sizeToFit];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)initLeftTitle:(NSString *)strTitle color:(UIColor *)color
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
    
    [btn setTitle:strTitle forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [btn sizeToFit];
    [btn addTarget:self action:@selector(leftButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [btn setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)initLeftTitle:(NSString *)strTitle
color:(UIColor *)color
selector:(SEL)selector
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
    
    [btn setTitle:strTitle forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [btn sizeToFit];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)initLeftImage:(NSString *)strImage
title:(NSString *)strTitle
color:(UIColor *)color
{
    CGRect rect = CGRectMake(0, -2*SCREEN_WIDTH/320, 60, 44);
    
    UIButton *btn = [[UIButton alloc] initWithFrame:rect];
    
    [btn addTarget:self action:@selector(leftButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateHighlighted];
    [btn setTitle:strTitle forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)initLeftImage:(NSString *)strImage
title:(NSString *)strTitle
color:(UIColor *)color
selector:(SEL)selector
{
    CGRect rect = CGRectMake(0, -2*SCREEN_WIDTH/320, 60, 44);
    
    UIButton *btn = [[UIButton alloc] initWithFrame:rect];
    
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateHighlighted];
    [btn setTitle:strTitle forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)initRightImage:(NSString *)strImage
{
    CGRect rect = CGRectMake(0, -2*SCREEN_WIDTH/320, 60, 44);
    
    UIButton *btn = [[UIButton alloc] initWithFrame:rect];
    
    [btn addTarget:self action:@selector(rightButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateHighlighted];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    btn.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)initRightImage:(NSString *)strImage selector:(SEL)selector
{
    CGRect rect = CGRectMake(0, -2*SCREEN_WIDTH/320, 60, 44);
    
    UIButton *btn = [[UIButton alloc] initWithFrame:rect];
    
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateHighlighted];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    btn.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)initRightTitle:(NSString *)strTitle
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
    
    [btn setTitle:strTitle forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [btn sizeToFit];
    [btn addTarget:self action:@selector(rightButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [btn setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)initRightTitle:(NSString *)strTitle selector:(SEL)selector
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
    
    [btn setTitle:strTitle forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [btn sizeToFit];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)initRightTitle:(NSString *)strTitle color:(UIColor *)color;
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
    
    [btn setTitle:strTitle forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [btn sizeToFit];
    [btn addTarget:self action:@selector(rightButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [btn setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)initRightTitle:(NSString *)strTitle
color:(UIColor *)color
selector:(SEL)selector
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
    
    [btn setTitle:strTitle forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [btn sizeToFit];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)initRightImage:(NSString *)strImage
title:(NSString *)strTitle
color:(UIColor *)color
{
    CGRect rect = CGRectMake(0, -2*SCREEN_WIDTH/320, 60, 44);
    
    UIButton *btn = [[UIButton alloc] initWithFrame:rect];
    
    [btn addTarget:self action:@selector(rightButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateHighlighted];
    [btn setTitle:strTitle forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    btn.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    
}

- (void)initRightImage:(NSString *)strImage
title:(NSString *)strTitle
color:(UIColor *)color
selector:(SEL)selector
{
    CGRect rect = CGRectMake(0, -2*SCREEN_WIDTH/320, 60, 44);
    
    UIButton *btn = [[UIButton alloc] initWithFrame:rect];
    
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateHighlighted];
    [btn setTitle:strTitle forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    btn.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)resetLeftTitle:(NSString*)str
{
    self.navigationItem.leftBarButtonItem.title = str;
}

- (void)resetRightTitle:(NSString*)str
{
    self.navigationItem.rightBarButtonItem.title = str;
}

- (void)initBackButton
{
    UIViewController *rootVC=[self getRootViewController];
    
    if (![rootVC isKindOfClass:[UINavigationController class]])
    {
        return;
    }
    
    UINavigationController *rootNav= (UINavigationController *)rootVC;
    if (rootNav.viewControllers.count>=1 && self!=rootNav.viewControllers.firstObject)
    {
        [self initLeftTitle:NSLocalizedString(@"back", @"返回")];
    }
}

#pragma mark event

- (void)leftButtonEvent
{
    if ([self respondsToSelector:@selector(back)])
    {
        [self back];
    }
}

- (void)rightButtonEvent
{
    
}

#pragma mark button event

- (void)hideLeftButton
{
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)hideRightButton
{
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)enableLeftButton
{
    if (self.navigationItem.leftBarButtonItem)
    {
        self.navigationItem.leftBarButtonItem.enabled = YES;
    }
}

- (void)enableRightButton
{
    if (self.navigationItem.rightBarButtonItem)
    {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

- (void)disableLeftButton
{
    if (self.navigationItem.leftBarButtonItem)
    {
        self.navigationItem.leftBarButtonItem.enabled = NO;
    }
}

- (void)disableRightButton
{
    if (self.navigationItem.rightBarButtonItem)
    {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

- (BOOL)isNavigationBar
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setNavigationBarHidden:(BOOL)navigationBarHidden
{
    objc_setAssociatedObject(self, @selector(isNavigationBar), @(navigationBarHidden), OBJC_ASSOCIATION_ASSIGN);
}

@end
