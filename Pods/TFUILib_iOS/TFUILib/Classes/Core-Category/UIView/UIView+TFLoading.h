//
//  UIView+Loading.h
//  loading
//
//  Created by xiayiyong on 15/9/9.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFLoadingView.h"

@interface UIView (TFLoading)

/**
 *  显示Loading视图
 */
-(void)showLoading;

/**
 *  显示Loading视图
 *
 *  @param alertText 提示信息
 */
-(void)showLoadingWithText:(NSString *)text;

/**
 *  隐藏Loading视图
 */
-(void)hideLoading;

@end
