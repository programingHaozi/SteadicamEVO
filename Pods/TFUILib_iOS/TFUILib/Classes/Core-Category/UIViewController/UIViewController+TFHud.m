//
//  UIViewController+TFHud.m
//  TFUILib
//
//  Created by xiayiyong on 16/3/21.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "UIViewController+TFHud.h"
#import "TFHud.h"

@implementation UIViewController (TFHud)

#pragma mark HUD

- (void)showHUD
{
    [TFHud showLoadingWithText:@"加载中..."
                  textPosition:kTextPositionTypeRight
                        atView:[UIApplication sharedApplication].keyWindow];
}

- (void)showHUDWithText:(NSString*)text
{
    [TFHud showLoadingWithText:text
                     textPosition:kTextPositionTypeRight
                        atView:[UIApplication sharedApplication].keyWindow];
}

- (void)hideHUD
{
    [TFHud hideInView:[UIApplication sharedApplication].keyWindow];
}

@end
