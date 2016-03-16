//
//  LBLoading.m
//  LightBundle
//
//  Created by Hu Dan 胡丹 on 15/11/3.
//  Copyright © 2015年 Ren Wenchao 任文超. All rights reserved.
//

#import "LBLoading.h"

static UIActivityIndicatorView *loadingActivityIndicatorView;

@interface LBLoading()

@property (nonatomic,retain)NSString *isOpen;

@end

@implementation LBLoading

/**
 *  停止展示
 */
- (void)stopShowing
{
    [LBLoading stopLoading];
}

/**
 *  loading
 */
- (void)jsCallFunction
{
    self.isOpen = [self.paramers objectForKey:LB_RET_OPEN];
    if ([self.isOpen isEqualToString:@"true"])
    {
        [LBLoading startLoading:self.lb.webView];
        [self callbackJsSdk:@"" errorCode:LBErrorCodeSuccess msg:kLBMsgLoadingOpenSuccess];
    }
    else {
        [LBLoading stopLoading];
        [self callbackJsSdk:@"" errorCode:LBErrorCodeSuccess msg:kLBMsgLoadingCloseSuccess];
    }
}

/**
 *  开始loading
 */
+ (void)startLoading:(UIView*)view
{
    if (!loadingActivityIndicatorView)
    {
        loadingActivityIndicatorView = [[UIActivityIndicatorView alloc]
                                             initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    
    // 缩小loading尺寸 (测试状态生效)
    if (!LB_DEBUG_APP) {
        loadingActivityIndicatorView.frame = view.frame;
    }
    [LBLoading setActivityIndicatorViewStyleDefault:view];
    
    if (![view.subviews containsObject:loadingActivityIndicatorView])
    {
        [view addSubview:loadingActivityIndicatorView];
    }
    
    if ([loadingActivityIndicatorView isAnimating])
    {
        [loadingActivityIndicatorView stopAnimating];
    }
    [loadingActivityIndicatorView startAnimating];
}

/**
 *  设置loading样式
 */
+ (void)setActivityIndicatorViewStyle:(UIColor*)bgColor
                              bgAlpha:(float)alpha
                           viewCenter:(CGPoint)centerPoint
{
    loadingActivityIndicatorView.backgroundColor = bgColor;
    loadingActivityIndicatorView.alpha = alpha;
    loadingActivityIndicatorView.center = centerPoint;
}

/**
 *  默认样式
 *
 *  @param view
 */
+ (void)setActivityIndicatorViewStyleDefault:(UIView*)view
{
    loadingActivityIndicatorView.backgroundColor = [UIColor darkGrayColor];
    loadingActivityIndicatorView.alpha = 0.3;
    loadingActivityIndicatorView.center = CGPointMake(view.frame.size.width/2,view.frame.size.height/2);
}

/**
 *  结束loading
 */
+ (void)stopLoading
{
    if (loadingActivityIndicatorView &&
        [loadingActivityIndicatorView isAnimating])
    {
        [loadingActivityIndicatorView stopAnimating];
        [loadingActivityIndicatorView removeFromSuperview];
    }
}

@end
