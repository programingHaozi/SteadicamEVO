//
//  UIActionSheet+Block.h
//  UIActionSheet+Block
//
//  Created by Jonghwan Hyeon on 8/25/14.
//  Copyright (c) 2014 Jonghwan Hyeon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIActionSheet (Block)

+ (void)showWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
                        block:(void (^)(UIActionSheet *, NSInteger))block;

+ (void)showWithTitle:(NSString *)title
    cancelButtonTitle:(NSString *)cancelButtonTitle
    buttonTitles:(NSArray *)buttonTitles
                block:(void (^)(UIActionSheet *, NSInteger))block;

- (instancetype)initWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
                        block:(void (^)(UIActionSheet *, NSInteger))block;

- (instancetype)initWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles;

- (void)showUsingBlock:(void (^)(UIActionSheet *actionSheet, NSInteger buttonIndex))block;

- (void)showFromTabBar:(UITabBar *)view
            usingBlock:(void (^)(UIActionSheet *actionSheet, NSInteger buttonIndex))block;

- (void)showFromToolbar:(UIToolbar *)view
             usingBlock:(void (^)(UIActionSheet *actionSheet, NSInteger buttonIndex))block;

- (void)showInView:(UIView *)view
        usingBlock:(void (^)(UIActionSheet *actionSheet, NSInteger buttonIndex))block;

- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated
                   usingBlock:(void (^)(UIActionSheet *actionSheet, NSInteger buttonIndex))block;

- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated
          usingBlock:(void (^)(UIActionSheet *actionSheet, NSInteger buttonIndex))block;

@end
