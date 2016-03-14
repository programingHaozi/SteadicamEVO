//
//  UIAlertController+Block.h
//  TFUILib
//
//  Created by xiayiyong on 16/1/28.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Block)

#pragma mark - alertview

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
    cancelButtonTitle:(NSString *)cancelButtonTitle
    otherButtonTitles:(NSArray *)otherButtonTitles
                block:(void (^)(UIAlertController *alertView, NSInteger buttonIndex))block;

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
    buttonTitle:(NSArray *)buttonTitle
                block:(void (^)(UIAlertController *alertView, NSInteger buttonIndex))block;

#pragma mark - alertview

+ (void)showWithTitle:(NSString *)title
    cancelButtonTitle:(NSString *)cancelButtonTitle
destructiveButtonTitle:(NSString *)destructiveButtonTitle
    otherButtonTitles:(NSArray *)otherButtonTitles
                block:(void (^)(UIAlertController *, NSInteger))block;

+ (void)showWithTitle:(NSString *)title
    cancelButtonTitle:(NSString *)cancelButtonTitle
         buttonTitles:(NSArray *)buttonTitles
                block:(void (^)(UIAlertController *, NSInteger))block;

#pragma mark - show
- (void)show;

@end
