//
//  UIAlertView+Block.m
//  UIAlertView+Block
//
//  Created by xiayiyong on 16/1/28.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "UIAlertView+Block.h"

@interface UIAlertView () <UIAlertViewDelegate>

@property (copy, nonatomic) void (^block)(UIAlertView *UIAlertView, NSInteger buttonIndex);

@end

@implementation UIAlertView (Block)

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
    cancelButtonTitle:cancelButtonTitle
    otherButtonTitles:(NSArray *)otherButtonTitles
                block:(void (^)(UIAlertView *alertView, NSInteger buttonIndex))block
{
    UIAlertView *alert=[UIAlertView alertWithTitle:title
                                                 message:message
                                       cancelButtonTitle:cancelButtonTitle
                                       otherButtonTitles:otherButtonTitles
                                                   block:block];
    [alert show];
}

+ (instancetype)alertWithTitle:(NSString *)title
                      message:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
                        block:(void (^)(UIAlertView *alertView, NSInteger buttonIndex))block
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                      message:message
                                     delegate:nil
                            cancelButtonTitle:nil
                            otherButtonTitles:nil];
    
    if (alert)
    {
        NSInteger buttonIndex = 0;
        
        if (cancelButtonTitle != nil && cancelButtonTitle.length > 0)
        {
            [alert addButtonWithTitle:cancelButtonTitle];
            alert.cancelButtonIndex = buttonIndex++;
        }
        
        for (NSString *otherButtonTitle in otherButtonTitles)
        {
            [alert addButtonWithTitle:otherButtonTitle];
            ++buttonIndex;
        }
    }
    
    alert.block = block;
    alert.delegate=alert;
    return alert;
}

#pragma mark - delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.block)
    {
        self.block(alertView, buttonIndex);
    }
}

@end