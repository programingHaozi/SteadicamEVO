//
//  LBLoading.h
//  LightBundle
//
//  Created by Hu Dan 胡丹 on 15/11/3.
//  Copyright © 2015年 Ren Wenchao 任文超. All rights reserved.
//

#import "LBBasePlugin.h"

@interface LBLoading : LBBasePlugin

/**
 *  开始loading
 */
+ (void)startLoading:(UIView*)view;

/**
 *  结束loading
 */
+ (void)stopLoading;

/**
 *  设置loading样式
 */
+ (void)setActivityIndicatorViewStyle:(UIColor*)bgColor bgAlpha:(float)alpha viewCenter:(CGPoint)centerPoint;

/**
 *  默认样式
 *
 *  @param view
 */
+ (void)setActivityIndicatorViewStyleDefault:(UIView*)view;

@end
