//
//  TFToast.m
//  TFUILib
//
//  Created by xiayiyong on 16/4/15.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFToast.h"

#import "TFToast.h"

#define KS_TOAST_VIEW_ANIMATION_DURATION  0.5f

static const CGFloat MessageToastHorizontalPadding      = 10.0f;
static const CGFloat MessageToastVerticalPadding        = 7.0f;
static const CGFloat MessageToastFadeDuration           = 0.2;
static const CGFloat MessageToastAutoDismissDuration    = 3.5f;
static const CGFloat MessageToastCornerRadius            = 8;
static const NSInteger  MessageToastContentTag          = 10087;

#define MESSAGE_FONT FONT(18)

@interface TFToast ()

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic,assign) TFToastType toastType;

@end

@implementation TFToast

+ (void)showWithText:(NSString *)text
{
    [[self class]showWithText:text duration:MessageToastAutoDismissDuration];
}

+ (void)showWithText:(NSString *)text duration:(NSTimeInterval)duration
{
    [[self class]showWithText:text duration:duration atView:[[UIApplication sharedApplication].delegate window]];
}

+ (void)showWithText:(NSString *)text duration:(NSTimeInterval)duration atView:(UIView*)atView
{
    [[self class]showWithText:text duration:duration type:kToastTypeTop atView:atView completion:nil];
}

+ (void)showWithText:(NSString *)text duration:(NSTimeInterval)duration type:(TFToastType)type atView:(UIView*)atView
{
    [[self class]showWithText:text duration:duration type:type atView:atView completion:nil];
}

+ (void)showWithText:(NSString *)text duration:(NSTimeInterval)duration type:(TFToastType)type atView:(UIView*)atView completion:(TFToastBlock)completion
{
    if (text == nil || text.length==0)
    {
        return;
    }
    
    for (UIView *subview in atView.subviews)
    {
        if ([subview isKindOfClass:[TFToast class]])
        {
            TFToast* toast=(TFToast*)subview;
            if ([toast.text isEqualToString:text])
            {
                return;
            }
        }
    }
    
    TFToast *toast=[[TFToast alloc]initWithText:text];
    [atView addSubview:toast];
    toast.centerX=atView.centerX;
    toast.centerX=atView.centerX;
    
    if (type==kToastTypeTop)
    {
        toast.top=[atView isKindOfClass:[UIWindow class]]?64:0;
    }
    else if (type==kToastTypeBottom)
    {
        toast.bottom=49;
    }
    else if (type==kToastTypeCenter)
    {
        toast.center=atView.center;
    }
    
    [UIView animateWithDuration:MessageToastFadeDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         toast.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:MessageToastFadeDuration
                                               delay:duration
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              toast.alpha = 0.0;
                                          } completion:^(BOOL finished) {
                                              [toast removeFromSuperview];
                                          }];
                     }];
    
}

#pragma mark - Init

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initWithText:(NSString*)text
{
    self = [super init];
    if (self)
    {
        self.text=text;
        
        self.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
        self.layer.cornerRadius = MessageToastCornerRadius;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.8;
        self.layer.shadowRadius = MessageToastCornerRadius;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.6];
        
        UILabel *messageLabel = [[UILabel alloc] init];
        messageLabel.numberOfLines = 0;
        messageLabel.font = [UIFont systemFontOfSize:18];
        messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.alpha = 1.0;
        messageLabel.text = text;
        messageLabel.tag = MessageToastContentTag;
        
        NSDictionary *attribute = @{NSFontAttributeName: messageLabel.font};
        CGSize size = [text boundingRectWithSize:CGSizeMake(([UIScreen mainScreen].bounds.size.width) * 0.8, ([UIScreen mainScreen].bounds.size.height) * 0.8)
                                            options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        messageLabel.frame = CGRectMake(0.0, 0.0, size.width, size.height);
        
        CGFloat contentWidth =  (messageLabel.frame.size.width + MessageToastHorizontalPadding * 2);
        CGFloat contentHeight = (messageLabel.frame.size.height + MessageToastVerticalPadding * 2);
        
        self.frame = CGRectMake(0, 0, contentWidth, contentHeight);
        
        messageLabel.frame = CGRectMake(MessageToastHorizontalPadding, MessageToastVerticalPadding, messageLabel.frame.size.width, messageLabel.frame.size.height);
        [self addSubview:messageLabel];
        
    }
    return self;
}

@end
