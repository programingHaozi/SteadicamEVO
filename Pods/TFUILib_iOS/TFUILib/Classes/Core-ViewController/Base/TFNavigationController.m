//
//  TFNavigationController.m
//  Treasure
//
//  Created by xiayiyong on 15/7/2.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFNavigationController.h"
#import "TFTabBarController.h"

@interface TFNavigationController ()

@end

@implementation TFNavigationController

-(instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    return [super initWithRootViewController:rootViewController];
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isKindOfClass:[TFTabBarController class]])
    {
        ((TFViewController*)viewController).customNavigationBarHidden=YES;
    }
    else if ([viewController isKindOfClass:[TFViewController class]])
    {
        ((TFViewController*)viewController).customNavigationBarHidden=NO;
    }
    
    [super pushViewController:viewController animated:animated];
}

-(UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    return [super popViewControllerAnimated:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.interactivePopGestureRecognizer.delegate = nil;
    
    self.navigationBarHidden=YES;
    
    [self initViews];
    [self autolayoutViews];
    [self bindData];
}

- (void)setNavigationBarBackgroundColor:(UIColor *)color alpha:(NSInteger)alpha
{
    [self.navigationBar setBgColor:color];
    [self.navigationBar setElementsAlpha:alpha];
}

#pragma mark- init autolayout bind

- (void)initViews
{
    
}

- (void)autolayoutViews
{
    
}

- (void)bindData
{
    
}

#pragma mark - Setter Getter -

- (UIViewController *)previousViewController
{
    UIViewController *previousVC = nil;
    if (self.viewControllers.count != 0)
    {
        previousVC = self.viewControllers[self.viewControllers.count-1];
    }
    
    return previousVC;
}

-(void)setRootViewController:(TFViewController *)rootViewController
{
    
}

-(TFViewController *)rootViewController
{
    return self.viewControllers.firstObject;
}

@end
