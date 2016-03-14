//
//  UIView+TFEmptyView.m
//  loading
//
//  Created by xiayiyong on 15/9/9.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "UIView+TFEmptyView.h"
#import <objc/runtime.h>

#define GAP 5
#define ALERT_TEXT_WIDTH 200.f
#define DISAPEAR_DURATION 0.f

@interface TFEmptyView()
@end

@implementation TFEmptyView
@synthesize alertLabel;

- (id)initWithFrame:(CGRect)frame superView:(UIView *)superView alertText:(NSString *)alertMessage 
{
    self = [super initWithFrame:frame];
    if (self) {
        //noneView
        self.backgroundColor = [UIColor clearColor];
        
        //alertText
        self.alertLabel = [[UILabel alloc] init];
        self.alertLabel.tag = 1;
        self.alertLabel.text = alertMessage;
        self.alertLabel.textColor = [UIColor lightGrayColor];
        [self.alertLabel sizeToFit];

        [self addSubview:self.alertLabel];
    }
    return self;
}

@end

const void *TF_EMPTY_VIEW_KEY = @"TFEmptyViewKey";

@implementation UIView (TFEmptyView)
@dynamic emptyView;

-(UIView *)emptyView
{
    return objc_getAssociatedObject(self, TF_EMPTY_VIEW_KEY);
}

-(void)setEmptyView:(UIView *)noneView
{
    return objc_setAssociatedObject(self, TF_EMPTY_VIEW_KEY, noneView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)showEmptyView
{
    self.userInteractionEnabled = NO;
    if (!self.emptyView) {
        self.emptyView = [[TFEmptyView alloc] initWithFrame:CGRectMake(0, 0, 30, 30) superView:self alertText:@""];
    }
    [self addSubview:self.emptyView];
}

-(void)hideEmptyView
{
    [UIView animateWithDuration:DISAPEAR_DURATION animations:^{
        self.emptyView.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self.emptyView removeFromSuperview];
        self.userInteractionEnabled = YES;
    }];
}
@end
