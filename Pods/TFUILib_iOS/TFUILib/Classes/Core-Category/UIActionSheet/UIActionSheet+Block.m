//
//  UIActionSheet+Block.m
//  UIActionSheet+Block
//
//  Created by xiayiyong on 16/1/28.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "UIActionSheet+Block.h"
#import <objc/runtime.h>

@interface UIActionSheet() <UIActionSheetDelegate>

@property (copy, nonatomic) void (^block)(NSInteger buttonIndex);

@end

@implementation UIActionSheet (Block)

+ (void) showWithTitle:(NSString *)title
     cancelButtonTitle:(NSString *)cancelButtonTitle
destructiveButtonTitle:(NSString *)destructiveButtonTitle
     otherButtonTitles:(NSArray *)otherButtonTitles
                 block:(void (^)(NSInteger))block
{
    UIActionSheet *alert = [[UIActionSheet alloc]initWithTitle:title
                                              cancelButtonTitle:cancelButtonTitle
                                         destructiveButtonTitle:destructiveButtonTitle
                                              otherButtonTitles:otherButtonTitles
                                                          block:block];
    
    [alert showInView:[[self class] getTopViewController].view usingBlock:block];
}

- (instancetype)initWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
                        block:(void (^)(NSInteger))block
{
    self = [self initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    if (self)
    {
        NSInteger buttonIndex = 0;
        
        if (cancelButtonTitle != nil && cancelButtonTitle.length > 0)
        {
            [self addButtonWithTitle:cancelButtonTitle];
            self.cancelButtonIndex = buttonIndex++;
        }
        
        if (destructiveButtonTitle != nil && destructiveButtonTitle.length > 0)
        {
            [self addButtonWithTitle:destructiveButtonTitle];
            self.destructiveButtonIndex = buttonIndex++;
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

- (void)show
{
    self.delegate=self;
    [self showInView:[[self class] getTopViewController].view];
}

- (void)showInView:(UIView *)view
        usingBlock:(void (^)(NSInteger buttonIndex))block
{
    self.delegate = self;
    self.block = block;
    
    [self showInView:view];
}

#pragma mark - delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.block)
    {
        self.block(buttonIndex);
    }
}

#pragma mark - set get

- (void)setBlock:(void (^)(NSInteger))block
{
    objc_setAssociatedObject(self, @selector(block), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(NSInteger))block
{
    return objc_getAssociatedObject(self, @selector(block));
}

+ (UIViewController*)getTopViewController
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
    {
        result = nextResponder;
    }
    else
    {
        result = window.rootViewController;
    }
    
    return result;
}


@end