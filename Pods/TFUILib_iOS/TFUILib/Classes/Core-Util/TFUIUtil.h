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

#pragma mark - pop
void tf_popToViewController(UIViewController *vc);
void tf_popToViewControllerWithClassName(NSString *className);
void tf_popViewController();
void tf_popToRootViewController();

#pragma mark - present dismiss
void tf_presentViewController(UIViewController *vc);
void tf_dismissViewController(UIViewController *vc);

UIViewController *tf_getRootViewController();

@interface TFUIUtil : NSObject

+ (void)pushViewController:(UIViewController *)vc;
+ (void)popToViewController:(UIViewController *)vc;
+ (void)popToViewControllerWithClassName:(NSString *)className;
+ (void)popViewController;
+ (void)popToRootViewController;

+ (void)presentViewController:(UIViewController *)vc;
+ (void)dismissViewController:(UIViewController *)vc;

+(UIViewController *) getRootViewController;


@end
