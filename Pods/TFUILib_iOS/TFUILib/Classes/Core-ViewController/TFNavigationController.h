//
//  TFNavigationController.h
//  Treasure
//
//  Created by xiayiyong on 15/7/2.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFViewController.h"
#import "TFUICategory.h"

@interface TFNavigationController : UINavigationController

/**
 *  根视图
 */
@property (nonatomic, strong) TFViewController *rootViewController;

/**
 *  返回前一个viewController
 *
 */
@property (nonatomic, strong, readonly) UIViewController *previousViewController;

/**
 *  设置背景颜色和透明度
 *
 *  @param color 背景颜色
 *  @param alph  透明度
 */
- (void)setNavigationBarBackgroundColor:(UIColor *)color alph:(NSInteger)alph;

@end
