//
//  TFProgressView.m
//  TFUILib
//
//  Created by 张国平 on 16/3/9.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFProgressView.h"

@implementation TFProgressView

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor *)color
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self configureViews:color];
    }
    
    return self;
}

-(void)configureViews:(UIColor *)color
{
    self.userInteractionEnabled = NO;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _progressBarView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, 0, self.bounds.size.height)];
    _progressBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    UIColor *tintColor = color;
    _progressBarView.backgroundColor = tintColor;
    [self addSubview:_progressBarView];
    
    _barAnimationDuration = 0.27f;
    _fadeAnimationDuration = 0.27f;
    _fadeOutDelay = 0.1f;
}

-(void)setProgress:(float)progress
{
    [self setProgress:progress animated:YES];
}

- (void)setProgress:(float)progress animated:(BOOL)animated
{
    BOOL isGrowing = progress > 0.0;
    [UIView animateWithDuration:(isGrowing && animated) ? _barAnimationDuration : 0.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = _progressBarView.frame;
        frame.size.width = progress * self.bounds.size.width;
        _progressBarView.frame = frame;
    } completion:nil];
    
    if (progress >= 1.0)
    {
        [UIView animateWithDuration:animated ? _fadeAnimationDuration : 0.0 delay:_fadeOutDelay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _progressBarView.alpha = 0.0;
        } completion:^(BOOL completed){
            CGRect frame = _progressBarView.frame;
            frame.size.width = 0;
            _progressBarView.frame = frame;
        }];
    }
    else
    {
        [UIView animateWithDuration:animated ? _fadeAnimationDuration : 0.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _progressBarView.alpha = 1.0;
        } completion:nil];
    }
}


@end
