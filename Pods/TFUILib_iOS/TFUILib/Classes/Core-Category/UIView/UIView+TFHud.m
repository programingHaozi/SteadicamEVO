//
//  UIView+TFHud.m
//  TFUILib
//
//  Created by xiayiyong on 16/4/18.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "UIView+TFHud.h"
#import "TFHud.h"

@implementation UIView (TFHud)

#pragma mark HUD

- (void)showHud
{
    [TFHud showLoadingWithText:@"加载中..."
                  textPosition:kTextPositionTypeRight
                        atView:self];
}

- (void)showHudWithText:(NSString*)text
{
    [TFHud showLoadingWithText:text
                  textPosition:kTextPositionTypeRight
                        atView:self];
}

- (void)hideHud
{
    [TFHud hideInView:self];
}

@end
