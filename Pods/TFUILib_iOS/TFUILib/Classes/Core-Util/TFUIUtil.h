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

/**
 push pop present到rootViewController;
 */
#pragma mark - push
void tf_pushViewController(UIViewController *vc);
void tf_pushViewControllerFromViewController(UIViewController *vc,UIViewController *fromVC);

#pragma mark - pop
void tf_popToViewController(UIViewController *vc);
void tf_popToViewControllerWithClassName(NSString *className);
void tf_popViewController();
void tf_popToRootViewController();

#pragma mark - present dismiss
void tf_presentViewController(UIViewController *vc);
void tf_dismissViewController(UIViewController *vc);

void tf_popModuleViewController();

void tf_back();

UIViewController *tf_getRootViewController();
@interface TFUIUtil : NSObject

+ (BOOL) pushActionViewController:(TFActionModel*)model;
+ (BOOL) pushActionViewController:(TFActionModel*)model from:(UIViewController *)fromVC;

+ (void)pushViewController:(UIViewController *)vc;
+ (void)pushViewController:(UIViewController *)vc from:(UIViewController *)fromVC;
+ (void)popToViewController:(UIViewController *)vc;
+ (void)popToViewControllerWithClassName:(NSString *)className;
+ (void)popViewController;
+ (void)popToRootViewController;
+ (void)popModuleViewController;

+ (void)presentViewController:(UIViewController *)vc;
+ (void)dismissViewController:(UIViewController *)vc;

+(void) back;

+(UIViewController *) getRootViewController;

@end
