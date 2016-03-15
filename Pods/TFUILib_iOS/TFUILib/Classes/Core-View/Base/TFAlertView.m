//
//  TFAlertView.m
//  TFUILib
//
//  Created by xiayiyong on 16/2/3.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFAlertView.h"

@interface TFAlertView () <UIAlertViewDelegate>

@property (copy, nonatomic) void (^block)(UIAlertView *UIAlertView, NSInteger buttonIndex);

@end


@implementation TFAlertView

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
    cancelButtonTitle:cancelButtonTitle
    otherButtonTitles:(NSArray *)otherButtonTitles
                block:(void (^)(UIAlertView *alertView, NSInteger buttonIndex))block
{
    TFAlertView *alert=[[TFAlertView alloc]initWithTitle:title
                                                 message:message
                                       cancelButtonTitle:cancelButtonTitle
                                       otherButtonTitles:otherButtonTitles
                                                   block:block];
    [alert show];
}

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
                        block:(void (^)(UIAlertView *alertView, NSInteger buttonIndex))block
{
    self = [[TFAlertView alloc] initWithTitle:title
                       message:message
                      delegate:nil
             cancelButtonTitle:nil
             otherButtonTitles:nil];
    
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
    }
    
    self.block = block;
    
    return self;
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
