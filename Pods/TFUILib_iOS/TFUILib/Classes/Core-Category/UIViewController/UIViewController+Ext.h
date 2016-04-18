//
//  UIViewController+Ext.h
//  TFUILib
//
//  Created by xiayiyong on 16/4/8.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Ext)

/**
 *  获取keywindow
 */
@property (nonatomic, strong, readonly) UIWindow* keyWindow;

/**
 *  获取最顶层vc
 *
 *  @return
 */
@property (nonatomic, strong, readonly) UIViewController* topViewController;

/**
 *  屏幕宽度
 */
@property(nonatomic,readonly) CGFloat screenWidth;

/**
 *  屏幕高度
 */
@property(nonatomic,readonly) CGFloat screenHeight;

@end
