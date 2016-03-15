//
//  UIView+TFLoading.m
//  loading
//
//  Created by xiayiyong on 15/9/9.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "UIView+TFLoading.h"
#import <objc/runtime.h>

#define GAP 5
#define ALERT_TEXT_WIDTH 200.f
#define DISAPEAR_DURATION 0.f

@interface TFLoadingView()

@end

@implementation TFLoadingView

@synthesize activityIndicatorViewStyle;

@synthesize alertLabel;

@synthesize indicator;

- (id)       initWithFrame:(CGRect)frame
                 superView:(UIView *)superView
                 alertText:(NSString *)alertMessage
                    fixedY:(CGFloat)fixedY
activityIndicatorViewStyle:(UIActivityIndicatorViewStyle)indicatorStyle
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        //loadView
        self.backgroundColor = [UIColor clearColor];
        
        //indicator
        if (!indicatorStyle)
            self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        
        self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:indicatorStyle];
        [self.indicator startAnimating];
        
        //alertText
        self.alertLabel           = [[UILabel alloc] init];
        self.alertLabel.tag       = 1;
        self.alertLabel.text      = alertMessage;
        self.alertLabel.textColor = [UIColor lightGrayColor];
        
        [self.alertLabel sizeToFit];

        [self addSubview:self.indicator];
        [self addSubview:self.alertLabel];
        
        [self layoutWithIndicator:indicator superView:superView fixedY:fixedY];
    }
    
    return self;
}

-(void)layoutWithIndicator:(UIActivityIndicatorView *)indicator
                 superView:(UIView *)superView
                    fixedY:(CGFloat)fixedY
{
    if (self.alertLabel.frame.size.width > ALERT_TEXT_WIDTH)
    {
        self.alertLabel.numberOfLines = (NSInteger)ceilf(self.alertLabel.frame.size.width/ALERT_TEXT_WIDTH);
        
        self.alertLabel.frame = CGRectMake(0, 0, ALERT_TEXT_WIDTH, self.alertLabel.frame.size.width*(NSInteger)ceilf(self.alertLabel.frame.size.width/ALERT_TEXT_WIDTH));
        
        [self.alertLabel sizeToFit];
    }
    
    //layout
    self.frame = CGRectMake(0, 0, self.indicator.frame.size.width + self.alertLabel.frame.size.width + GAP, MAX(self.indicator.frame.size.height, self.alertLabel.frame.size.height));
    
    self.indicator.frame = CGRectMake(0, self.center.y-(self.indicator.frame.size.height/2), self.indicator.frame.size.width, self.indicator.frame.size.height);
    
    self.alertLabel.frame = CGRectMake(self.indicator.frame.size.width + GAP, self.center.y-(self.alertLabel.frame.size.height/2), self.alertLabel.frame.size.width, self.alertLabel.frame.size.height);
    
    self.center = CGPointMake(superView.center.x, superView.center.y + fixedY);
}

@end

const void *TF_LOAD_VIEW_KEY = @"TFLoadViewKey";

@implementation UIView (TFLoading)

@dynamic loadingView;

-(UIView *)loadingView
{
    return objc_getAssociatedObject(self, TF_LOAD_VIEW_KEY);
}

-(void)setLoadingView:(UIView *)loadingView
{
    return objc_setAssociatedObject(self, TF_LOAD_VIEW_KEY, loadingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)showLoading
{
    self.userInteractionEnabled = NO;
    
    if (!self.loadingView)
    {
        self.loadingView = [[TFLoadingView alloc]
                            initWithFrame:CGRectMake(0, 0, 30, 30)
                                superView:self
                                alertText:@""
                                    fixedY:0
                                activityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    }
    
    [self addSubview:self.loadingView];
}

-(void)showLoadingWithText:(NSString *)alertText
{
    self.userInteractionEnabled = NO;
    
    if (!self.loadingView)
    {
        self.loadingView = [[TFLoadingView alloc]
                            initWithFrame:CGRectMake(0, 0, 30, 30)
                                superView:self
                                alertText:alertText
                                   fixedY:0
                                activityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    }
    
    [self addSubview:self.loadingView];
}

-(void)showLoadingWithScrollViewFixed:(BOOL)shouldFixed
                            alertText:(NSString *)alertText
{
    self.userInteractionEnabled = NO;
    
    if (!self.loadingView)
    {
        self.loadingView = [[TFLoadingView alloc]
                            initWithFrame:CGRectMake(0, 0, 30, 30)
                                superView:self
                                alertText:alertText
                                   fixedY:shouldFixed?(-44):0
                                activityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    }
    
    self.loadingView.alertLabel.text = alertText;
    [self.loadingView layoutWithIndicator:self.loadingView.indicator superView:self fixedY:shouldFixed?(-44):0];
    
    [self addSubview:self.loadingView];
}

-(void)showLoadingWithScrollViewFixed:(BOOL)shouldFixed
                            alertText:(NSString *)alertText
           activityIndicatorViewStyle:(UIActivityIndicatorViewStyle)indicatorStyle
{
    self.userInteractionEnabled = NO;
    
    if (!self.loadingView)
    {
        self.loadingView = [[TFLoadingView alloc]
                            initWithFrame:CGRectMake(0, 0, 30, 30)
                            superView:self
                            alertText:alertText
                               fixedY:shouldFixed?(-44):0
                            activityIndicatorViewStyle:indicatorStyle];
    }
    
    self.loadingView.alertLabel.text = alertText;
    [self.loadingView layoutWithIndicator:self.loadingView.indicator
                                superView:self fixedY:shouldFixed?(-44):0];
    
    [self addSubview:self.loadingView];
}

-(void)hideLoading
{
    [UIView animateWithDuration:DISAPEAR_DURATION animations:^{
        
        self.loadingView.alpha = 0.f;
        
    } completion:^(BOOL finished) {
        
        [self.loadingView removeFromSuperview];
        self.userInteractionEnabled = YES;
    }];
}

@end
