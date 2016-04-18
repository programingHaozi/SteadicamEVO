//
//  UIView+TFLoading.m
//  loading
//
//  Created by xiayiyong on 15/9/9.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "UIView+TFLoading.h"

#define DISAPEAR_DURATION 0.f

@implementation UIView (TFLoading)

- (void)showLoading
{
    [TFLoadingView showWithText:@"加载中..." activityIndicatorViewStyle:UIActivityIndicatorViewStyleGray atView:self];
}

- (void)showLoadingWithText:(NSString*)text
{
    [TFLoadingView showWithText:text activityIndicatorViewStyle:UIActivityIndicatorViewStyleGray atView:self];
}

- (void)hideLoading
{
    [TFLoadingView hideAtView:self];
}

@end
