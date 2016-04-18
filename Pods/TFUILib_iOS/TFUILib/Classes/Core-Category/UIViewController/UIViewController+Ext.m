//
//  UIViewController+Ext.m
//  TFUILib
//
//  Created by xiayiyong on 16/4/8.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import <objc/runtime.h>
#import "UIViewController+Ext.h"

@implementation UIViewController (Ext)

- (UIWindow*)keyWindow
{
    return [UIApplication sharedApplication].keyWindow;
}

- (UIViewController *)topViewController
{
    if (self.presentedViewController)
    {
        return [self.presentedViewController topViewController];
    }
    if ([self isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tab = (UITabBarController *)self;
        return [[tab selectedViewController] topViewController];
    }
    if ([self isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *nav = (UINavigationController *)self;
        return [[nav visibleViewController] topViewController];
    }
    
    return self;
}

-(CGFloat)screenWidth
{
    return [UIScreen mainScreen].bounds.size.width;
}

-(CGFloat)screenHeight
{
    return [UIScreen mainScreen].bounds.size.height;
}

@end

