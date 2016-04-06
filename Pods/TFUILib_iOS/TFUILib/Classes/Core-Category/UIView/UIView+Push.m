//
//  UIView+Push.m
//  TFUILib
//
//  Created by xiayiyong on 16/3/21.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "UIView+Push.h"
#import "UIView+ViewController.h"
#import "UIViewController+Push.h"

@implementation UIView (Push)

- (UIViewController *)getRootViewController
{
    UIViewController *xx=[self viewController];
    if (xx==nil)
    {
        return nil;
    }
    
    return [xx getRootViewController];
}

- (void)back
{
    UIViewController *xx=[self viewController];
    if (xx==nil)
    {
        return;
    }
    [xx back];
}

#pragma mark - push pop

- (void)pushViewController:(UIViewController *)vc
{
    UIViewController *xx=[self viewController];
    if (xx==nil)
    {
        return;
    }
    [xx pushViewController:vc];
}

- (void)popViewController
{
    UIViewController *xx=[self viewController];
    if (xx==nil)
    {
        return;
    }
    [xx popViewController];
}

-(void) popToViewController:(UIViewController *)vc
{
    UIViewController *xx=[self viewController];
    if (xx==nil)
    {
        return;
    }
    [xx popToViewController:vc];
}

-(void) popToViewControllerWithClassName:(NSString *)className
{
    UIViewController *xx=[self viewController];
    if (xx==nil)
    {
        return;
    }
    
    [xx popToViewControllerWithClassName:className];
}

-(void) popToRootViewController
{
    UIViewController *xx=[self viewController];
    if (xx==nil)
    {
        return;
    }
    
    [xx popToRootViewController];
}

#pragma mark - present dismiss

- (void)presentViewController:(UIViewController *)vc
{
    UIViewController *xx=[self viewController];
    if (xx==nil)
    {
        return;
    }
    
    [xx presentViewController:vc];
}

- (void)dismissViewController
{
    UIViewController *xx=[self viewController];
    if (xx==nil)
    {
        return;
    }
    
    [xx dismissViewController];
}

#pragma mark - module

- (void)popModuleViewController
{
    UIViewController *xx=[self viewController];
    if (xx==nil)
    {
        return;
    }
    
    [xx popModuleViewController];
}

@end
