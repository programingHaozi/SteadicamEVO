//
//  UIView+Toast.m
//  Grape-ToC-Iphone
//
//  Created by Xuehan Gong on 14-5-30.
//  Copyright (c) 2014年 Chexiang. All rights reserved.
//

#import "LBUIView+Toast.h"

static const CGFloat MessageToastHorizontalPadding      = 10.0f;
static const CGFloat MessageToastVerticalPadding        = 7.0f;
static const CGFloat MessageToastFadeDuration           = 0.2;
static const CGFloat MessageToastAutoDismissDuration    = 1.5f;
static const CGFloat MessagToastCornerRadius            = 8;
static const NSInteger  MessageToastContentTag          = 10087;

#define TOAST_Font         [UIFont systemFontOfSize:12]

@implementation UIView (Toast)

- (UIView *)toastForMessage:(NSString *)message
                   oldToast:(UIView *)oldToast
{
    UIView *toast = oldToast;
    if (!toast)
    {
        toast = [self viewForMessage:message];
        toast.tag = LBGrapeToastTag;
    } else
    {
        [self refreshOldToast:oldToast withMessage:message];
    }
    return toast;
}

- (void)showToast:(UIView *)view
{
    [self showToast:view duration:MessageToastAutoDismissDuration position:@"center"];
}

- (void)showToast:(UIView *)toast duration:(CGFloat)interval position:(id)point
{
    toast.center = [self centerPointForPosition:point withToast:toast];
    toast.alpha = 0.0;

    [UIView animateWithDuration:MessageToastFadeDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         toast.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         [self hideToast:toast interval:interval];
                     }];
}

- (void)hideToast:(UIView *)toast animation:(BOOL)animation
{
    if (animation)
    {
        [self hideToast:toast interval:MessageToastAutoDismissDuration];
    } else {
        toast.alpha = 0;
    }
}

- (void)hideToast:(UIView *)toast interval:(CGFloat)interval
{
    [UIView animateWithDuration:MessageToastFadeDuration
                          delay:interval
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         toast.alpha = 0.0;
                     } completion:^(BOOL finished){
                         //[toast removeFromSuperview];
                     }];
}

- (CGPoint)centerPointForPosition:(id)point withToast:(UIView *)toast
{
    if([point isKindOfClass:[NSString class]])
    {
        if([point caseInsensitiveCompare:@"top"] == NSOrderedSame)
        {
            return CGPointMake(self.bounds.size.width/2, (toast.frame.size.height / 2) + 44/*+ 64 + MessageToastVerticalPadding*/);
        } else if([point caseInsensitiveCompare:@"bottom"] == NSOrderedSame)
        {
            return CGPointMake(self.bounds.size.width/2, ([[[UIApplication sharedApplication] delegate] window].frame.size.height - (toast.frame.size.height / 2)) - MessageToastVerticalPadding);
        } else if([point caseInsensitiveCompare:@"center"] == NSOrderedSame)
        {
            return CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        } else if ([point caseInsensitiveCompare:@"navigation"] == NSOrderedSame)
        {
            return CGPointMake(self.bounds.size.width/2, (toast.frame.size.height / 2) + 70);
        }
    } else if ([point isKindOfClass:[NSValue class]])
    {
        return [point CGPointValue];
    }
    
    return [self centerPointForPosition:@"bottom" withToast:toast];
}

- (UIView *)viewForMessage:(NSString *)message
{
    UIView *contentView = [[UIView alloc] init];
    contentView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                    UIViewAutoresizingFlexibleRightMargin |
                                    UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleBottomMargin);
    contentView.layer.cornerRadius = MessagToastCornerRadius;
    contentView.layer.shadowColor = [UIColor blackColor].CGColor;
    contentView.layer.shadowOpacity = 0.8;
    contentView.layer.shadowRadius = MessagToastCornerRadius;
    contentView.layer.shadowOffset = CGSizeMake(0, 0);
    contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    
    UILabel *messageLabel = nil;
    
    if (message != nil)
    {
        messageLabel = [[UILabel alloc] init];
        messageLabel.numberOfLines = 0;
        messageLabel.font = TOAST_Font;
        messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.alpha = 1.0;
        messageLabel.text = message;
        messageLabel.tag = MessageToastContentTag;
        
        NSDictionary *attribute = @{NSFontAttributeName: TOAST_Font};
        CGSize size = [message boundingRectWithSize:CGSizeMake(self.bounds.size.width * 0.8, self.bounds.size.height * 0.8)
                                            options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        messageLabel.frame = CGRectMake(0.0, 0.0, size.width, size.height);
    }
    
    CGFloat contentWidth =  (messageLabel.frame.size.width + MessageToastHorizontalPadding * 2);
    CGFloat contentHeight = (messageLabel.frame.size.height + MessageToastVerticalPadding * 2);
    
    contentView.frame = CGRectMake(0, 0, contentWidth, contentHeight);
    
    if(messageLabel != nil)
    {
        messageLabel.frame = CGRectMake(MessageToastHorizontalPadding, MessageToastVerticalPadding, messageLabel.frame.size.width, messageLabel.frame.size.height);
        [contentView addSubview:messageLabel];
    }
    
    return contentView;
}

- (void)refreshOldToast:(UIView *)oldToast withMessage:(NSString *)message
{
    UILabel *messageLabel = (UILabel *)[oldToast viewWithTag:MessageToastContentTag];
    NSDictionary *attribute = @{NSFontAttributeName: TOAST_Font};
    CGSize size = [message boundingRectWithSize:CGSizeMake(self.bounds.size.width * 0.8, self.bounds.size.height * 0.8)
                                        options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    messageLabel.frame = CGRectMake(0.0, 0.0, size.width, size.height);
    CGFloat contentWidth =  (messageLabel.frame.size.width + MessageToastHorizontalPadding * 2);
    CGFloat contentHeight = (messageLabel.frame.size.height + MessageToastVerticalPadding * 2);
    oldToast.frame = CGRectMake(0, 0, contentWidth, contentHeight);
    messageLabel.text = message;
    
    if(messageLabel != nil)
    {
        messageLabel.frame = CGRectMake(MessageToastHorizontalPadding, MessageToastVerticalPadding, messageLabel.frame.size.width, messageLabel.frame.size.height);
        [oldToast addSubview:messageLabel];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
