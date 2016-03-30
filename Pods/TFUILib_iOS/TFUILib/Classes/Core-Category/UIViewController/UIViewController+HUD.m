//
//  UIViewController+HUD.m
//  TFUILib
//
//  Created by xiayiyong on 16/3/21.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "UIViewController+HUD.h"
#import "TFProgressHud.h"

@implementation UIViewController (HUD)

#pragma mark HUD

- (void)showLoadingHud
{
    [self showLoadingHudWithText:@""];
}

- (void)showLoadingHudWithText:(NSString*)text
{
    if (text == nil || [text length] == 0)
    {
        text = NSLocalizedString(@"loading", @"正在请求中...");
    }
    
    [TFProgressHud showLoadingHud:[UIApplication sharedApplication].keyWindow
                         withText:text
                     textPosition:TextPositionTypeRight
                         animated:HudAnimatedTypeNone];
}

- (void)hideLoadingHud
{
    [TFProgressHud hideAllHudInView:[UIApplication sharedApplication].keyWindow
                           animated:HudAnimatedTypeNone];
}

@end
