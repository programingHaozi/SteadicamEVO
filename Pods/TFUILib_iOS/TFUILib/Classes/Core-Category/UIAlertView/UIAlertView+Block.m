//
//  UIAlertView+Block.m
//  UIAlertView+Block
//
//  Created by xiayiyong on 16/1/28.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "UIAlertView+Block.h"
#import <objc/runtime.h>

@interface UIAlertView () <UIAlertViewDelegate>

@property (copy, nonatomic) void (^block)(UIAlertView *UIAlertView, NSInteger buttonIndex);

@end


@implementation UIAlertView (Block)

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
    cancelButtonTitle:(NSString *)cancelButtonTitle
    otherButtonTitles:(NSArray *)otherButtonTitles
                block:(void (^)(UIAlertView *alertView, NSInteger buttonIndex))block
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:title
                                                 message:message
                                       cancelButtonTitle:cancelButtonTitle
                                       otherButtonTitles:otherButtonTitles
                                                   block:block];
    [alert showUsingBlock:block];
}

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
                        block:(void (^)(UIAlertView *alertView, NSInteger buttonIndex))block
{
    self = [self initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    if (self)
    {
        NSInteger buttonIndex = 0;
        
        if (cancelButtonTitle != nil && cancelButtonTitle.length > 0)
        {
            [self addButtonWithTitle:cancelButtonTitle];
            self.cancelButtonIndex = buttonIndex++;
        }
        
        for (NSString *otherButtonTitle in otherButtonTitles)
        {
            [self addButtonWithTitle:otherButtonTitle];
            ++buttonIndex;
        }
        
        self.block = block;
    }
    
    return self;
}

- (void)showUsingBlock:(void (^)(UIAlertView *, NSInteger))block
{
    self.delegate = self;
    self.block = block;
    
    [self show];
}

#pragma mark - delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.block)
    {
        self.block(alertView, buttonIndex);
    }
}

#pragma mark - set get

- (void)setBlock:(void (^)(UIAlertView *, NSInteger))block
{
    objc_setAssociatedObject(self, @selector(block), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UIAlertView *, NSInteger))block
{
    return objc_getAssociatedObject(self, @selector(block));
}

@end