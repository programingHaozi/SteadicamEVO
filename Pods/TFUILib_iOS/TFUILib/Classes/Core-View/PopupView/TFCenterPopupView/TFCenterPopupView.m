//
//  Created by xiayiyong on 16/3/30.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFCenterPopupView.h"


@interface TFCenterPopupView ()

@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) UIView *popupView;
@property (nonatomic, assign) TFCenterPopupViewAnimateType type;

@end

@implementation TFCenterPopupView

- (id)initWithPopupView:(UIView*)popupView
{
    self = [super initWithFrame:CGRectZero];
    
    if (self)
    {
        self.frame=CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height);
        
        UIViewAutoresizing autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight |
        UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
        UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        
        self.blackView = [[UIView alloc] initWithFrame:self.frame];
        self.blackView.backgroundColor = HEXCOLOR(0X000008,0.5);
        self.blackView.autoresizingMask = autoresizingMask;
        
        self.popupView=popupView;
        self.popupView.center = self.center;
        
        [self addSubview:self.blackView];
        [self addSubview:popupView];
    }
    
    return self;
}

- (void)showWithAnimate:(TFCenterPopupViewAnimateType)type
{
    self.type=type;
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    
    if (type==kCenterPopupViewAnimateSpring)
    {
        CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        popAnimation.duration = 0.4;
        popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DIdentity]];
        popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
        popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [self.popupView.layer addAnimation:popAnimation forKey:nil];
    }
    else if (type==kCenterPopupViewAnimateFade)
    {
        self.popupView.alpha = 0.0f;
        
        [UIView animateWithDuration:0.5
                         animations:^{
                             _popupView.alpha = 1.0f;
                         } completion:nil];
    }
}

-(void)show
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
}

-(void)hide
{
    [self removeFromSuperview];
}

@end
