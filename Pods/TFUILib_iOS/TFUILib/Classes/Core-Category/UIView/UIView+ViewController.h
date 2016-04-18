//
//  UIView+ViewController.h
//  TFUILib
//
//  Created by xiayiyong on 16/3/21.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ViewController)

/**
 *  获取keywindow
 */
@property (nonatomic, strong, readonly) UIWindow *keyWindow;

/**
 *  获取最顶层vc
 */
@property (nonatomic, strong, readonly) UIViewController *topViewController;

/**
 *  获取UIView所在的视图控制器（ViewController）
 */
@property (nonatomic, strong, readonly) UIViewController *viewController;

@end
