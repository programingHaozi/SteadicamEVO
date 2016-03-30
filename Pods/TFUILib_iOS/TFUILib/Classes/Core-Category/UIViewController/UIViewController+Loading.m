//
//  UIViewController+Loading.m
//  TFUILib
//
//  Created by xiayiyong on 16/3/21.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "UIViewController+Loading.h"
#import "UIView+TFLoading.h"

@implementation UIViewController (Loading)

#pragma mark loading

- (void)showLoading
{
    [self.view showLoadingWithText:@"加载中..." ];
}

- (void)showLoadingWithText:(NSString*)text
{
    [self.view showLoadingWithText:text];
}

- (void)hideLoading
{
    [self.view hideLoading];
}

@end
