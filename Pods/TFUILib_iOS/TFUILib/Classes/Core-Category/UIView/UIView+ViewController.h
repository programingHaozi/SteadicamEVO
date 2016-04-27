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
 *  获取最顶层vc
 */
- (UIViewController*)topViewController;

/**
 *  获取最顶层vc
 *
 *  @return
 */
- (UIViewController*)rootViewController;

/**
 *  获取UIView所在的视图控制器（ViewController）
 */
- (UIViewController *)viewController;


@end
