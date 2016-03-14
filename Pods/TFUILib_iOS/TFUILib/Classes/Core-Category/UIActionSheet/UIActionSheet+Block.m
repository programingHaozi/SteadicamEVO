//
//  UIActionSheet+Block.m
//  UIActionSheet+Block
//
//  Created by Jonghwan Hyeon on 8/25/14.
//  Copyright (c) 2014 Jonghwan Hyeon. All rights reserved.
//

#import "UIActionSheet+Block.h"
#import <objc/runtime.h>

@interface UIActionSheet () <UIActionSheetDelegate>

@property (copy, nonatomic) void (^block)(UIActionSheet *actionSheet, NSInteger buttonIndex);

@end

@implementation UIActionSheet (Block)

+ (void)showWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
                        block:(void (^)(UIActionSheet *, NSInteger))block
{
    UIActionSheet *alert=[[UIActionSheet alloc]initWithTitle:title
                                           cancelButtonTitle:cancelButtonTitle
                                      destructiveButtonTitle:destructiveButtonTitle
                                           otherButtonTitles:otherButtonTitles
                                                       block:nil];
    [alert showUsingBlock:block];
}

+ (void)showWithTitle:(NSString *)title
    cancelButtonTitle:(NSString *)cancelButtonTitle
         buttonTitles:(NSArray *)buttonTitles
                block:(void (^)(UIActionSheet *, NSInteger))block
{
    UIActionSheet *alert=[[UIActionSheet alloc]initWithTitle:title
                                           cancelButtonTitle:cancelButtonTitle
                                      destructiveButtonTitle:nil
                                           otherButtonTitles:buttonTitles
                                                       block:nil];
    [alert showUsingBlock:block];
}

- (instancetype)initWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
                        block:(void (^)(UIActionSheet *, NSInteger))block
{
    self = [self initWithTitle:title
                      delegate:self
             cancelButtonTitle:nil
        destructiveButtonTitle:nil
             otherButtonTitles:nil];
    if (self) {
        NSInteger buttonIndex = 0;
        
        if (cancelButtonTitle!=nil&&cancelButtonTitle.length>0)
        {
            [self addButtonWithTitle:cancelButtonTitle];
            self.cancelButtonIndex = buttonIndex++;
        }

        if (destructiveButtonTitle!=nil&&destructiveButtonTitle.length>0)
        {
            [self addButtonWithTitle:destructiveButtonTitle];
            self.destructiveButtonIndex = buttonIndex++;
        }

        for (NSString *otherButtonTitle in otherButtonTitles)
        {
            [self addButtonWithTitle:otherButtonTitle];
            ++buttonIndex;
        }
    }

    self.block=block;
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
{
    self = [self initWithTitle:title
             cancelButtonTitle:cancelButtonTitle
        destructiveButtonTitle:destructiveButtonTitle
             otherButtonTitles:otherButtonTitles
                         block:nil];
    return self;
}

- (void)setBlock:(void (^)(UIActionSheet *, NSInteger))block
{
    objc_setAssociatedObject(self, @selector(block), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UIActionSheet *, NSInteger))block
{
    return objc_getAssociatedObject(self, @selector(block));
}

- (void)showUsingBlock:(void (^)(UIActionSheet *actionSheet, NSInteger buttonIndex))block
{
    [self showInView:[UIApplication sharedApplication].keyWindow usingBlock:block];
}

- (void)showFromTabBar:(UITabBar *)view
            usingBlock:(void (^)(UIActionSheet *actionSheet, NSInteger buttonIndex))block
{
    self.delegate = self;
    self.block = block;

    [self showFromTabBar:view];
}

- (void)showFromToolbar:(UIToolbar *)view
             usingBlock:(void (^)(UIActionSheet *actionSheet, NSInteger buttonIndex))block
{
    self.delegate = self;
    self.block = block;

    [self showFromToolbar:view];
}

- (void)showInView:(UIView *)view
        usingBlock:(void (^)(UIActionSheet *actionSheet, NSInteger buttonIndex))block
{
    self.delegate = self;
    self.block = block;

    [self showInView:view];
}

- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated
                   usingBlock:(void (^)(UIActionSheet *actionSheet, NSInteger buttonIndex))block
{
    self.delegate = self;
    self.block = block;

    [self showFromBarButtonItem:item animated:animated];
}

- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated
          usingBlock:(void (^)(UIActionSheet *actionSheet, NSInteger buttonIndex))block
{
    self.delegate = self;
    self.block = block;

    [self showFromRect:rect inView:view animated:animated];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.block)
    {
        self.block(actionSheet, buttonIndex);
    }
}

@end