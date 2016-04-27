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

#pragma mark - RootViewController
UIViewController *tf_getRootViewController();
UIView *tf_getRootView();

#pragma mark - toast
void tf_showToast(NSString *text);
void tf_showToastWithText(NSString *text);

@interface TFUIUtil : NSObject

@end
