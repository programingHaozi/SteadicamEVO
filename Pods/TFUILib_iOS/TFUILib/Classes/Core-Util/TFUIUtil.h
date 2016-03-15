//
//  MasonyUtil.h
//  Treasure
//
//  Created by xiayiyong on 15/8/5.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "TFActionModel.h"
#import "Masonry.h"

void tf_handleData(id data);

/**
 push pop present到rootViewController;
 */
#pragma mark - push

/**
 *  push方法
 *
 *  @param vc to控制器
 */
void tf_pushViewController(UIViewController *vc);

/**
 *  push方法
 *
 *  @param vc     to控制器
 *  @param fromVC from控制器
 */
void tf_pushViewControllerFromViewController(UIViewController *vc,UIViewController *fromVC);

#pragma mark - pop

/**
 *  pop方法
 *
 *  @param vc 控制器
 */
void tf_popToViewController(UIViewController *vc);

/**
 *  pop方法
 *
 *  @param className to控制器
 */
void tf_popToViewControllerWithClassName(NSString *className);

/**
 *  pop方法
 */
void tf_popViewController();

/**
 *  pop到根控制器
 */
void tf_popToRootViewController();

#pragma mark - present dismiss

/**
 *  弹出模态视图
 *
 *  @param vc 控制器
 */
void tf_presentViewController(UIViewController *vc);

/**
 *  隐藏模态视图
 *
 *  @param vc 控制器
 */
void tf_dismissViewController(UIViewController *vc);

/**
 *  pop方法退出模块
 */
void tf_popModuleViewController();

/**
 *  返回方法
 */
void tf_back();

/**
 *  获取根控制器
 *
 *  @return 根控制器
 */
UIViewController *tf_getRootViewController();

@interface TFUIUtil : NSObject

+(void) handleData:(id)data;

/**
 *  Action push方法
 *
 *  @param model TFActionModel
 *
 *  @return push是否成功
 */
+(BOOL) pushActionViewController:(TFActionModel*)model;

/**
 *  Action push方法
 *
 *  @param model  TFActionModel
 *  @param fromVC from 控制器
 *
 *  @return push是否成功
 */
+(BOOL) pushActionViewController:(TFActionModel*)model from:(UIViewController *)fromVC;

/**
 *  push方法
 *
 *  @param vc to控制器
 */
+(void) pushViewController:(UIViewController *)vc;

/**
 *  push方法
 *
 *  @param vc     to控制器
 *  @param fromVC from控制器
 */
+(void) pushViewController:(UIViewController *)vc from:(UIViewController *)fromVC;

/**
 *  pop方法
 *
 *  @param vc 控制器
 */
+(void) popToViewController:(UIViewController *)vc;

/**
 *  pop方法
 *
 *  @param className to控制器
 */
+(void) popToViewControllerWithClassName:(NSString *)className;

/**
 *  pop方法
 */
+(void) popViewController;

/**
 *  pop到根控制器
 */
+(void) popToRootViewController;

/**
 *  pop方法退出模块
 */
+(void) popModuleViewController;

/**
 *  弹出模态视图
 *
 *  @param vc 控制器
 */
+(void) presentViewController:(UIViewController *)vc;

/**
 *  隐藏模态视图
 *
 *  @param vc 控制器
 */
+(void) dismissViewController:(UIViewController *)vc;

/**
 *  返回方法
 */
+(void) back;

/**
 *  获取根控制器
 *
 *  @return 根控制器
 */
+(UIViewController *) getRootViewController;

@end
