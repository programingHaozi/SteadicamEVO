//
//  TFActionSheet.m
//  TFUILib
//
//  Created by xiayiyong on 16/2/3.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFActionSheet.h"

@interface TFActionSheet() <UIActionSheetDelegate>

@property (copy, nonatomic) void (^block)(UIActionSheet *actionSheet, NSInteger buttonIndex);

@end

@implementation TFActionSheet

+ (void) showWithTitle:(NSString *)title
     cancelButtonTitle:(NSString *)cancelButtonTitle
destructiveButtonTitle:(NSString *)destructiveButtonTitle
     otherButtonTitles:(NSArray *)otherButtonTitles
                 block:(void (^)(UIActionSheet *, NSInteger))block
{
    TFActionSheet *alert = [[TFActionSheet alloc] initWithTitle:title
                                              cancelButtonTitle:cancelButtonTitle
                                         destructiveButtonTitle:destructiveButtonTitle
                                              otherButtonTitles:otherButtonTitles
                                                          block:block];
    
    [alert show];
}

- (instancetype)initWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
                        block:(void (^)(UIActionSheet *, NSInteger))block
{
    self = [[TFActionSheet alloc] initWithTitle:title
                      delegate:nil
             cancelButtonTitle:nil
        destructiveButtonTitle:nil
             otherButtonTitles:nil];
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
    }
    
    self.block = block;
    
    return self;
}

- (void)show
{
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

@end
