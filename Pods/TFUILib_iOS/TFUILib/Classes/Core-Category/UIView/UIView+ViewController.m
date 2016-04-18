//
//  UIView+ViewController.m
//  TFUILib
//
//  Created by xiayiyong on 16/3/21.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "UIView+ViewController.h"
#import "UIViewController+Ext.h"
#import "TFUIUtil.h"

@implementation UIView (ViewController)

- (UIWindow*)keyWindow
{
    return [UIApplication sharedApplication].keyWindow;
}

- (UIViewController *)topViewController
{
    return [[UIApplication sharedApplication].keyWindow.rootViewController topViewController];
}

- (UIViewController *)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview)
    {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
