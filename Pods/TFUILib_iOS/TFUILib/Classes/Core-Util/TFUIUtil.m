//
//  MasonyUtil.m
//  Treasure
//
//  Created by xiayiyong on 15/8/5.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//
//
#define MODLUE_VIEW_CONTROLLER_TAG  888

#import "TFUIUtil.h"
#import "TFNavigationController.h"
#import "TFViewController.h"

#pragma mark - push

void tf_pushViewController(UIViewController *vc)
{
    [TFUIUtil pushViewController:vc];
}

#pragma mark - pop
void tf_popToViewController(UIViewController *vc)
{
    [TFUIUtil popToViewController:vc];
}

void tf_popToViewControllerWithClassName(NSString *className)
{
    [TFUIUtil popToViewControllerWithClassName:className];
}

void tf_popViewController()
{
    [TFUIUtil popViewController];
}

void tf_popToRootViewController()
{
    [TFUIUtil popToRootViewController];
}

#pragma mark - present dismiss
void tf_presentViewController(UIViewController *vc)
{
    [TFUIUtil presentViewController:vc];
}

void tf_dismissViewController(UIViewController *vc)
{
    [TFUIUtil dismissViewController:vc];
}

UIViewController *tf_getRootViewController()
{
    return [TFUIUtil getRootViewController];
}


@implementation TFUIUtil

/*
 push pop
 */
+ (void)pushViewController:(UIViewController *)vc
{
    UIViewController *rootVC = [TFUIUtil getRootViewController];
    [rootVC pushViewController:vc];
}

+ (void)popToViewController:(UIViewController *)vc
{
    UIViewController *rootVC = [TFUIUtil getRootViewController];
    [rootVC popToViewController:vc];
}

+ (void)popToViewControllerWithClassName:(NSString *)className
{
    UIViewController *rootVC = [TFUIUtil getRootViewController];
    [rootVC popToViewControllerWithClassName:className];
}

+ (void)popViewController
{
    UIViewController *rootVC = [TFUIUtil getRootViewController];
    [rootVC popViewController];
}

+ (void)popToRootViewController
{
    UIViewController *rootVC = [TFUIUtil getRootViewController];
    [rootVC popToRootViewController];
}

/*
 present dismiss
 */
+ (void)presentViewController:(UIViewController *)vc
{
    UIViewController *rootVC = [TFUIUtil getRootViewController];
    [rootVC presentViewController:vc];
}

+ (void)dismissViewController:(UIViewController *)vc
{
    [vc dismissViewControllerAnimated:YES completion:^{
        
    }];
}

+ (UIViewController *)getRootViewController
{
    UIViewController *rootVC=[[UIApplication sharedApplication].delegate window].rootViewController;
    return rootVC;
}

@end

