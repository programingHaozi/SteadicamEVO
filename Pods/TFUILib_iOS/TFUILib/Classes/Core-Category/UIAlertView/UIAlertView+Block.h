//
//  UIAlertView+Block.h
//  UIAlertView+Block
//
//  Created by Jonghwan Hyeon on 8/14/14.
//  Copyright (c) 2014 Jonghwan Hyeon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Block)

+ (void)showWithTitle:(NSString *)title
                      message:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
                        block:(void (^)(UIAlertView *alertView, NSInteger buttonIndex))block;

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
    buttonTitles:(NSArray *)buttonTitles
                block:(void (^)(UIAlertView *alertView, NSInteger buttonIndex))block;

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
                        block:(void (^)(UIAlertView *alertView, NSInteger buttonIndex))block;

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles;

- (void)showUsingBlock:(void (^)(UIAlertView *alertView, NSInteger buttonIndex))block;

@end
