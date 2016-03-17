//
//  TFNavigationController.m
//  Treasure
//
//  Created by xiayiyong on 15/7/2.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFNavigationController.h"

@interface TFNavigationController ()

@end

@implementation TFNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)setNavigationBarBackgroundColor:(UIColor *)color alph:(NSInteger)alph
{
    [self.navigationBar setBgColor:color];
    [self.navigationBar setElementsAlpha:alph];
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
    if (self.viewControllers.count != 0) {
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