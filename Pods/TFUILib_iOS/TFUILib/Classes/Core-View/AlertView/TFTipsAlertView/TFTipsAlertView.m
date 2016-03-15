//
//  TFTipsAlert.m
//  TF-ToC-Iphone
//
//  Created by Xuehan Gong on 14-5-7.
//  Copyright (c) 2014年 Chexiang. All rights reserved.
//

#import "TFTipsAlertView.h"
#import <TFBaseLib.h>

#define VIEW_BOTTOM_MARGIN 10.0f

@implementation TFTipsAlertView

- (id)initWithTitle:(NSString *)title
           delegate:(id<TFTipsAlertViewDelegate>)delegate
            content:(NSString *)content
      confirmButton:(NSString *)confirm
       cancelButton:(NSString *)cancel;
{
    TFView *contentView = nil;
    
    if (cancel == nil)
    {
        contentView = [SingleButtonContent
                       singleButtonContentWithTitle:title
                       content:content
                       confirmButton:confirm];
    }
    else
    {
        contentView = [DoubleButtonContent
                       doubleButtonContentWithTitle:title
                       content:content
                       confrimButton:confirm
                       cancelButton:cancel];
    }
    
    self = [super initWithContentView:contentView
                             position: TFCustomAlertViewPositionMiddle];
    
    if (self != nil)
    {
        self.delegate = delegate;
        
        [contentView setValue:self forKey:@"delegate"];
        
        for (UIGestureRecognizer *recongnizer in self.gestureRecognizers)
        {
            [self removeGestureRecognizer:recongnizer];
        }
    }
    
    return self;
}

- (id)initWithTitle:(NSString *)title
           subtitle:(NSString *)subtitle
           delegate:(id<TFTipsAlertViewDelegate>)delegate
      confirmButton:(NSString *)confirm
       cancelButton:(NSString *)cancel
{
    TFView *contentView = [SubtitleDoubleButtonContent
                           subtitleDoubleButtonContentWithTitle:title
                           subtitle:subtitle
                           confrimButton:confirm
                           cancelButton:cancel];
    
    self = [super initWithContentView:contentView
                             position: TFCustomAlertViewPositionMiddle];
    if (self != nil)
    {
        self.delegate = delegate;
        [contentView setValue:self forKey:@"delegate"];
        
        for (UIGestureRecognizer *recongnizer in self.gestureRecognizers)
        {
            [self removeGestureRecognizer:recongnizer];
        }
    }
    
    return self;
}

#pragma mark - Delegate Method

- (void)confirmButtonClicked
{
    if ([_delegate respondsToSelector:@selector(tipsAlertView:clickedButtonAtIndex:)])
    {
        [_delegate tipsAlertView:self clickedButtonAtIndex:1];
    }
    
    [self hide];
}

- (void)cancelButtonClicked
{
    if ([_delegate respondsToSelector:@selector(tipsAlertView:clickedButtonAtIndex:)])
    {
        [_delegate tipsAlertView:self clickedButtonAtIndex:0];
    }
    
    [self hide];
}

@end

@implementation SingleButtonContent

+ (SingleButtonContent *)singleButtonContentWithTitle:(NSString *)title
                                              content:(NSString *)content
                                        confirmButton:(NSString *)confirm
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TFTipsAlertView class]) owner:nil options:nil];
    
    SingleButtonContent *singleContent = [nibView objectAtIndex:0];
    
    CGRect viewFrame                = singleContent.frame;
    CGRect scrollFrame              = singleContent.scrollView.frame;
    CGRect buttonContainerViewFrame = singleContent.buttonContainerView.frame;
    
    singleContent.title_lbl.text      = title;
    singleContent.title_lbl.textColor = HEXCOLOR(0X333333,  1);
    if (title == nil)
    {
        singleContent.titleView.hidden = YES;
        viewFrame.size.height -= singleContent.titleView.frame.size.height;
        scrollFrame.origin.y  = 0.0;
    }
    
    singleContent.content_lbl.text      = content;
    singleContent.content_lbl.textColor = HEXCOLOR(0X333333,  1);
    
    CGSize fitSize = [singleContent.content_lbl sizeThatFits:CGSizeMake(singleContent.content_lbl.frame.size.width, CGFLOAT_MAX)];
    if (fitSize.height > singleContent.content_lbl.frame.size.height)
    {
        CGRect frame                         = singleContent.content_lbl.frame;
        frame.origin.y                       = VIEW_BOTTOM_MARGIN;
        frame.size.height                    = fitSize.height;
        singleContent.content_lbl.frame      = frame;

        CGSize contentSize                   = singleContent.scrollView.contentSize;
        contentSize.height                   = fitSize.height + VIEW_BOTTOM_MARGIN * 2;
        singleContent.scrollView.contentSize = contentSize;
    }
    
    [singleContent.confirm_btn setTitle:confirm forState:UIControlStateNormal];
    
    CGFloat height = singleContent.scrollView.contentSize.height + singleContent.buttonContainerView.frame.size.height + (title == nil ? 0.0 : singleContent.titleView.frame.size.height);
    
    CGFloat maxheight = ([UIScreen mainScreen].bounds.size.height/3)*2;
    
    if (height > viewFrame.size.height && height < maxheight)
    {
        viewFrame.size.height = height;
    }
    else if (height > maxheight)
    {
        viewFrame.size.height = maxheight;
    }
    
    scrollFrame.size.height = viewFrame.size.height - singleContent.buttonContainerView.frame.size.height - (title == nil ? 0.0 : singleContent.titleView.frame.size.height);
    
    buttonContainerViewFrame.origin.y = viewFrame.size.height - singleContent.buttonContainerView.frame.size.height;
    
    singleContent.frame                     = viewFrame;
    singleContent.scrollView.frame          = scrollFrame;
    singleContent.buttonContainerView.frame = buttonContainerViewFrame;
    
    return singleContent;
}

- (void)awakeFromNib
{
    self.cornerRadius = 5.0;
    self.clipsToBounds = YES;
}

- (IBAction)confirmButtonClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(confirmButtonClicked)])
    {
        [self.delegate confirmButtonClicked];
    }
}

@end

@implementation DoubleButtonContent

+ (DoubleButtonContent *)doubleButtonContentWithTitle:(NSString *)title
                                              content:(NSString *)content
                                        confrimButton:(NSString *)confirm
                                         cancelButton:(NSString *)cancel
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TFTipsAlertView class]) owner:nil options:nil];
    
    DoubleButtonContent *doubleContent = [nibView objectAtIndex:1];
    
    CGRect viewFrame                = doubleContent.frame;
    CGRect scrollFrame              = doubleContent.scrollView.frame;
    CGRect buttonContainerViewFrame = doubleContent.buttonContainerView.frame;
    
    doubleContent.title_lbl.text      = title;
    doubleContent.title_lbl.textColor = HEXCOLOR(0X333333,  1);
    
    if (title == nil)
    {
        doubleContent.titleView.hidden = YES;
        viewFrame.size.height -= doubleContent.titleView.frame.size.height;
        scrollFrame.origin.y = 0.0;
    }
    
    doubleContent.content_lbl.text      = content;
    doubleContent.content_lbl.textColor = HEXCOLOR(0X333333,  1);
    CGSize fitSize = [doubleContent.content_lbl sizeThatFits:CGSizeMake(doubleContent.content_lbl.frame.size.width, CGFLOAT_MAX)];
    
    if (fitSize.height > doubleContent.content_lbl.frame.size.height)
    {
        CGRect frame                    = doubleContent.content_lbl.frame;
        frame.origin.y                  = VIEW_BOTTOM_MARGIN;
        frame.size.height               = fitSize.height;
        doubleContent.content_lbl.frame = frame;
        
        CGSize contentSize                   = doubleContent.scrollView.contentSize;
        contentSize.height                   = fitSize.height + VIEW_BOTTOM_MARGIN * 2;
        doubleContent.scrollView.contentSize = contentSize;
    }
    
    [doubleContent.confirm_btn setTitle:confirm forState:UIControlStateNormal];
    [doubleContent.cancel_btn setTitle:cancel forState:UIControlStateNormal];
    
    CGFloat height = doubleContent.scrollView.contentSize.height + doubleContent.buttonContainerView.frame.size.height + (title == nil ? 0.0 : doubleContent.titleView.frame.size.height);
    
    CGFloat maxheight = ([UIScreen mainScreen].bounds.size.height/3)*2;
    
    if (height > viewFrame.size.height && height < maxheight)
    {
        viewFrame.size.height = height;
    }
    else if (height > maxheight)
    {
        viewFrame.size.height = maxheight;
    }
    
    scrollFrame.size.height = viewFrame.size.height - doubleContent.buttonContainerView.frame.size.height - (title == nil ? 0.0 : doubleContent.titleView.frame.size.height);
    
    buttonContainerViewFrame.origin.y = viewFrame.size.height - doubleContent.buttonContainerView.frame.size.height;
    
    doubleContent.frame                     = viewFrame;
    doubleContent.scrollView.frame          = scrollFrame;
    doubleContent.buttonContainerView.frame = buttonContainerViewFrame;
    
    return doubleContent;
}

- (void)awakeFromNib
{
    self.cornerRadius = 5.0;
    self.clipsToBounds = YES;
}

- (void)setDelegate:(id<TFTipsContentDelegate>)delegate
{
    _delegate = delegate;
}

- (IBAction)confirmButtonClicked:(id)sender
{
    if ([_delegate respondsToSelector:@selector(confirmButtonClicked)])
    {
        [_delegate confirmButtonClicked];
    }
}

- (IBAction)cancelButtonClicked:(id)sender
{
    if ([_delegate respondsToSelector:@selector(cancelButtonClicked)])
    {
        [_delegate cancelButtonClicked];
    }
}

@end

#pragma mark - SubtitleDoubleButtonContent

@implementation SubtitleDoubleButtonContent

+ (SubtitleDoubleButtonContent *)subtitleDoubleButtonContentWithTitle:(NSString *)title
                                                             subtitle:(NSString *)subtitle
                                                        confrimButton:(NSString *)confirm
                                                         cancelButton:(NSString *)cancel
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TFTipsAlertView class]) owner:nil options:nil];
    
    SubtitleDoubleButtonContent *doubleContent = [nibView objectAtIndex:2];
    doubleContent.title_lbl.text         = title;
    doubleContent.subtitle_lbl.text      = subtitle;
    doubleContent.title_lbl.textColor    = HEXCOLOR(0X333333,  1);
    doubleContent.subtitle_lbl.textColor = HEXCOLOR(0X333333,  1);

    [doubleContent.confirm_btn setTitle:confirm forState:UIControlStateNormal];
    [doubleContent.cancel_btn setTitle:cancel forState:UIControlStateNormal];
    
    if (cancel == nil)
    {
        CGRect frame                    = doubleContent.confirm_btn.frame;
        frame.origin.x                  = 0;
        frame.size.width                = doubleContent.bounds.size.width;
        doubleContent.confirm_btn.frame = frame;
    }
    
    return doubleContent;
}

- (void)awakeFromNib
{
    self.cornerRadius = 5.0;
    self.clipsToBounds = YES;
}

- (void)setDelegate:(id<TFTipsContentDelegate>)delegate
{
    _delegate = delegate;
}

- (IBAction)confirmButtonClicked:(id)sender
{
    if ([_delegate respondsToSelector:@selector(confirmButtonClicked)])
    {
        [_delegate confirmButtonClicked];
    }
}

- (IBAction)cancelButtonClicked:(id)sender
{
    if ([_delegate respondsToSelector:@selector(cancelButtonClicked)])
    {
        [_delegate cancelButtonClicked];
    }
}

@end
