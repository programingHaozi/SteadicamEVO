//
//  TFTopPopupView.m
//  AFPopup
//
//  Created by Alvaro Franco on 3/7/14.
//  Copyright (c) 2014 xiayiyong. All rights reserved.
//

#import "TFTopPopupView.h"
#import "UIView+Category.h"

@interface TFTopPopupView ()

@property (nonatomic, assign) TFTopPopupViewAnimateType type;

@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UIView *blackgroundView;

@end

@implementation TFTopPopupView

- (instancetype)initWithPopupView:(UIView*)popupView andHeight:(CGFloat)height
{
    self = [super initWithFrame:CGRectZero];
    
    if (self)
    {
        self.frame=CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height);
        
        if (height<=0||height>[[UIScreen mainScreen]bounds].size.height)
        {
            height=[[UIScreen mainScreen]bounds].size.height;
        }
        
        self.alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, height)];
        self.alertView.backgroundColor = [UIColor clearColor];
        self.alertView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight |
        UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
        UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        
        self.blackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.blackgroundView.backgroundColor = [UIColor blackColor];
        self.blackgroundView.autoresizingMask = self.alertView.autoresizingMask;
        
        [self.alertView addSubview:popupView];
        [self addSubview:self.blackgroundView];
        [self addSubview:self.alertView];
    }
    
    return self;
}

- (void)showWithAnimateType:(TFTopPopupViewAnimateType)type
{
    self.type=type;
    [self show];
}

-(void)show
{
    [self.keyWindow addSubview:self];
    
    _alertView.frame = CGRectMake(0, -_alertView.frame.size.height, _alertView.frame.size.width, _alertView.frame.size.height);
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _alertView.frame = CGRectMake(0, 0, _alertView.frame.size.width, _alertView.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

-(void)hide
{
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _alertView.frame = CGRectMake(0, -_alertView.frame.size.height, _alertView.frame.size.width, _alertView.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

@end
