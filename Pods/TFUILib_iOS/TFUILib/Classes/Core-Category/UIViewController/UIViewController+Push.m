//
//  UIViewController+Push.m
//  TFUILib
//
//  Created by xiayiyong on 16/3/21.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "UIViewController+Push.h"
#import "TFNavigationController.h"
#import "TFUIUtil.h"

@implementation UIViewController (Push)

- (UIViewController *)getRootViewController
{
    UIViewController *rootVC=[[UIApplication sharedApplication].delegate window].rootViewController;
    return rootVC;
}

- (void)back
{
    if (self.presentingViewController != nil)
    {
        if (self.navigationController == nil)
        {
            [self dismissViewControllerAnimated:YES completion:nil];
            
            return;
        }
        
        NSArray *arr = self.navigationController.viewControllers;
        if ([arr count] > 0)
        {
            if (self==self.navigationController.viewControllers[0])
            {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    else
    {
        if (self.navigationController == nil)
        {
            return;
        }
        
        UIViewController *rootVC=[self getRootViewController];
        if ([rootVC isKindOfClass:[UINavigationController class]])
        {
            UINavigationController *rootNav= (UINavigationController *)rootVC;
            [rootNav popViewControllerAnimated:YES];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


#pragma mark- push pop
- (void)pushViewController:(UIViewController *)vc
{
    if (self.presentingViewController!=nil)
    {
        if (self.navigationController != nil)
        {
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else
    {
        UIViewController *rootVC=[self getRootViewController];
        if (![rootVC isKindOfClass:[UINavigationController class]])
        {
            return;
        }
        
        UINavigationController *rootNav= (UINavigationController *)rootVC;
        [rootNav pushViewController:vc animated:YES];
    }
}

- (void)popViewController
{
    [self back];
}

-(void) popToViewController:(UIViewController *)vc
{
    if (vc == nil)
    {
        return;
    }
    
    [self popToViewControllerWithClassName:NSStringFromClass([vc class])];
}

-(void) popToViewControllerWithClassName:(NSString *)className
{
    if (className == nil || className.length == 0)
    {
        return;
    }
    
    UIViewController *rootVC = [self getRootViewController];
    
    if (![rootVC isKindOfClass:[UINavigationController class]])
    {
        return;
    }
    
    UINavigationController *rootNav= (UINavigationController *)rootVC;
    NSMutableArray *vcs = [NSMutableArray arrayWithArray:rootNav.viewControllers];
    
    for (NSInteger i=vcs.count-1; i<vcs.count; i--)
    {
        UIViewController *vc = vcs[i];
        if ([vc isKindOfClass:NSClassFromString(className)])
        {
            [rootNav popToViewController:vc animated:YES];
            
            return;
        }
    }
}

-(void) popToRootViewController
{
    UIViewController *rootVC = [self getRootViewController];
    
    if (![rootVC isKindOfClass:[UINavigationController class]])
    {
        return;
    }
    
    UINavigationController *rootNav= (UINavigationController *)rootVC;
    [rootNav popToRootViewControllerAnimated:YES];
}

#pragma mark- present dismissView
- (void)presentViewController:(UIViewController *)vc
{
    UIViewController *rootVC=[self getRootViewController];
    TFNavigationController *nav=[[TFNavigationController alloc]initWithRootViewController:vc];
    [rootVC presentViewController:nav animated:YES completion:^{
        
    }];
}

- (void)dismissViewController
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark- module
- (void)popModuleViewController
{
    UIViewController *rootVC=[self getRootViewController];
    if (![rootVC isKindOfClass:[UINavigationController class]])
    {
        return;
    }
    
    UINavigationController *rootNav= (UINavigationController *)rootVC;
    NSMutableArray *vcs = [NSMutableArray arrayWithArray:rootNav.viewControllers];
    for (NSInteger i=vcs.count-1; i>=0; i--)
    {
        UIViewController *vc = (UIViewController *)vcs[i];
        if ([self isModuleViewController:vc])
        {
            if (i>0)
            {
                [rootNav popToViewController:vcs[i-1] animated:YES];
            }
            
            return;
        }
    }
}

-(BOOL) isModuleViewController:(UIViewController *)vc
{
    UIViewController *rootVC=[self getRootViewController];
    
    if (![rootVC isKindOfClass:[UINavigationController class]])
    {
        return NO;
    }
    
    NSString *fielPath = [[NSBundle mainBundle] pathForResource:@"ModuleConfig" ofType:@"plist"];
    if (fielPath==nil)
    {
        return NO;
    }
    
    NSArray *arr = [NSArray arrayWithContentsOfFile:fielPath];
    
    //1 模块跳转方式
    if (arr!=nil && [arr containsObject:NSStringFromClass([vc class])])
    {
        return YES;
    }
    //2 普通跳转方式
    else
    {
        return NO;
    };
}

@end
