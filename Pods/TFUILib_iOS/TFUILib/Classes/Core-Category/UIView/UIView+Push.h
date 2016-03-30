//
//  UIView+Push.h
//  TFUILib
//
//  Created by xiayiyong on 16/3/21.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Push)

/**
 *  获取APP根ViewController
 *
 *  @return
 */
- (UIViewController *)getRootViewController;

/**
 *  返回方法
 */
- (void)back;

#pragma mark - push pop

/**
 *  push方法
 *
 *  @param vc 控制器
 */
- (void)pushViewController:(UIViewController *)vc;

/**
 *  pop view所在的VC方法
 */
- (void)popViewController;

/**
 *  pop方法
 *
 *  @param vc 控制器
 */
-(void) popToViewController:(UIViewController *)vc;

/**
 *  pop方法
 *
 *  @param className to控制器
 */
-(void) popToViewControllerWithClassName:(NSString *)className;

#pragma mark - present dismiss

/**
 *  pop模态视图
 */
- (void)presentViewController:(UIViewController *)vc;

/**
 *  dismiss view所在的VC方法
 */
- (void)dismissViewController;

#pragma mark - module

/**
 *  pop方法退出模块
 */
- (void)popModuleViewController;

@end
