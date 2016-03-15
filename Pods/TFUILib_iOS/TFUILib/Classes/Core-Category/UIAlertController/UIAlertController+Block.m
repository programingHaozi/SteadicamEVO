//
//  UIAlertController+Block.m
//  TFUILib
//
//  Created by xiayiyong on 16/1/28.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "UIAlertController+Block.h"
#import <objc/runtime.h>

@implementation UIAlertController (Block)

#pragma mark - alertview

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
    cancelButtonTitle:(NSString *)cancelButtonTitle
    otherButtonTitles:(NSArray *)otherButtonTitles
                block:(void (^)(UIAlertController *alertView, NSInteger buttonIndex))block
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    if (cancelButtonTitle != nil && cancelButtonTitle.length > 0)
    {
        int start=0;
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:cancelButtonTitle
                                                              style:UIAlertActionStyleCancel
                                                            handler:^(UIAlertAction *action) {
                                                                if (block!=nil)
                                                                {
                                                                    block(alert,start);
                                                                }
                                                            }];
        
        [alert addAction:alertAction];
    }
    
    if (otherButtonTitles != nil)
    {
        int start=0;
        
        if (cancelButtonTitle != nil && cancelButtonTitle.length > 0)
        {
            start++;
        }
        
        for (int i=0; i<otherButtonTitles.count; i++)
        {
            NSString *item=otherButtonTitles[i];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:item
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction *action) {
                                                                    if (block!=nil)
                                                                    {
                                                                        block(alert,i+start);
                                                                    }
                                                                    
                                                                }];
            
            [alert addAction:alertAction];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        
        [alert show];
    });
}

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
          buttonTitle:(NSArray *)buttonTitle
                block:(void (^)(UIAlertController *alertView, NSInteger buttonIndex))block
{
    [[self class]showWithTitle:title
                       message:message
             cancelButtonTitle:nil
             otherButtonTitles:buttonTitle
                         block:block];
}

#pragma mark - actionsheet

+ (void) showWithTitle:(NSString *)title
     cancelButtonTitle:(NSString *)cancelButtonTitle
destructiveButtonTitle:(NSString *)destructiveButtonTitle
     otherButtonTitles:(NSArray *)otherButtonTitles
                 block:(void (^)(UIAlertController *, NSInteger))block
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    if (cancelButtonTitle != nil && cancelButtonTitle.length > 0)
    {
        int start=0;
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:cancelButtonTitle
                                                              style:UIAlertActionStyleCancel
                                                            handler:^(UIAlertAction *action) {
                                                                if (block!=nil)
                                                                {
                                                                    block(alert,start);
                                                                }
                                                            }];
        
        [alert addAction:alertAction];
    }
    
    if (destructiveButtonTitle != nil && destructiveButtonTitle.length > 0)
    {
        int start=0;
        
        if (cancelButtonTitle!=nil&&cancelButtonTitle.length>0)
        {
            start++;
        }
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:destructiveButtonTitle
                                                              style:UIAlertActionStyleDestructive
                                                            handler:^(UIAlertAction *action) {
                                                                if (block!=nil)
                                                                {
                                                                    block(alert,start);
                                                                }
                                                            }];
        
        [alert addAction:alertAction];
    }
    
    if (otherButtonTitles != nil)
    {
        int start=0;
        
        if (cancelButtonTitle!=nil&&cancelButtonTitle.length>0)
        {
            start++;
        }
        if (destructiveButtonTitle!=nil&&destructiveButtonTitle.length>0)
        {
            start++;
        }
        
        for (int i = 0; i < otherButtonTitles.count; i++)
        {
            NSString *item = otherButtonTitles[i];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:item
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction *action) {
                                                                    if (block!=nil)
                                                                    {
                                                                        block(alert,i+start);
                                                                    }
                                                                    
                                                                }];
            
            [alert addAction:alertAction];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        
        [alert show];
    });
}

+ (void)showWithTitle:(NSString *)title
    cancelButtonTitle:(NSString *)cancelButtonTitle
         buttonTitles:(NSArray *)buttonTitles
                block:(void (^)(UIAlertController *, NSInteger))block
{
    [[self class]showWithTitle:title
             cancelButtonTitle:cancelButtonTitle
        destructiveButtonTitle:nil
             otherButtonTitles:buttonTitles
                         block:block];
}

- (void)show
{
    [[self topShowViewController] presentViewController:self
                                               animated:YES
                                             completion:nil];
}

#pragma --mark t

- (UIViewController*)topShowViewController
{
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]])
    {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    }
    else if ([rootViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    }
    else if (rootViewController.presentedViewController)
    {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        
        return [self topViewControllerWithRootViewController:presentedViewController];
    }
    else
    {
        return rootViewController;
    }
}

+ (BOOL)isIosVersion8AndAfter
{
    return [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ;
}

@end
