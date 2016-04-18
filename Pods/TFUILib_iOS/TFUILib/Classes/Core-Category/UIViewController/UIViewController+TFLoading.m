//
//  UIViewController+TFLoading.m
//  TFUILib
//
//  Created by xiayiyong on 16/3/21.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "UIViewController+TFLoading.h"
#import "TFLoadingView.h"

@implementation UIViewController (TFLoading)

#pragma mark loading

- (void)showLoading
{
    [TFLoadingView showWithText:@"加载中..." activityIndicatorViewStyle:UIActivityIndicatorViewStyleGray atView:self.view];
}

- (void)showLoadingWithText:(NSString*)text
{
    [TFLoadingView showWithText:text activityIndicatorViewStyle:UIActivityIndicatorViewStyleGray atView:self.view];
}

- (void)hideLoading
{
    [TFLoadingView hideAtView:self.view];
}

@end
