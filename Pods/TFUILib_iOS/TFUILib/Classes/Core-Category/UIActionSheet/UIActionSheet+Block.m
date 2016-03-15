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

@property (copy, nonatomic) void (^block)(UIActionSheet *actionSheet, NSInteger buttonIndex);

@end

@implementation UIActionSheet (Block)

+ (void) showWithTitle:(NSString *)title
     cancelButtonTitle:(NSString *)cancelButtonTitle
destructiveButtonTitle:(NSString *)destructiveButtonTitle
     otherButtonTitles:(NSArray *)otherButtonTitles
                 block:(void (^)(UIActionSheet *, NSInteger))block
{
    UIActionSheet *alert = [UIActionSheet sheetWithTitle:title
                                              cancelButtonTitle:cancelButtonTitle
                                         destructiveButtonTitle:destructiveButtonTitle
                                              otherButtonTitles:otherButtonTitles
                                                          block:block];
    
    [alert show];
}

+ (instancetype)sheetWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
                        block:(void (^)(UIActionSheet *, NSInteger))block
{
    UIActionSheet *alert = [[UIActionSheet alloc] initWithTitle:title
                                       delegate:nil
                              cancelButtonTitle:nil
                         destructiveButtonTitle:nil
                              otherButtonTitles:nil];
    if (alert)
    {
        NSInteger buttonIndex = 0;
        
        if (cancelButtonTitle != nil && cancelButtonTitle.length > 0)
        {
            [alert addButtonWithTitle:cancelButtonTitle];
            alert.cancelButtonIndex = buttonIndex++;
        }
        
        if (destructiveButtonTitle != nil && destructiveButtonTitle.length > 0)
        {
            [alert addButtonWithTitle:destructiveButtonTitle];
            alert.destructiveButtonIndex = buttonIndex++;
        }
        
        for (NSString *otherButtonTitle in otherButtonTitles)
        {
            [alert addButtonWithTitle:otherButtonTitle];
            ++buttonIndex;
        }
    }
    
    alert.block = block;
    
    return alert;
}

- (void)show
{
    self.delegate=self;
    [self showInView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark - delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.block)
    {
        self.block(actionSheet, buttonIndex);
    }
}

- (void)setBlock:(void (^)(UIActionSheet *, NSInteger))block
{
    objc_setAssociatedObject(self, @selector(block), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UIActionSheet *, NSInteger))block
{
    return objc_getAssociatedObject(self, @selector(block));
}

@end