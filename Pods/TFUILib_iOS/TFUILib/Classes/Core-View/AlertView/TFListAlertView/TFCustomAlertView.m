//
//  TFCustomAlertView.m
//  babyincar-toc-iphone
//
//  Created by Xuehan Gong on 14-10-9.
//  Copyright (c) 2014年 Chexiang. All rights reserved.
//

#import "TFCustomAlertView.h"
#import <TFBaseLib.h>

/**
 *  TFCustomAlertViewPositionBottom的时候的弹性效果偏差值
 */
NSInteger const kAlertElasticityOffset = 50.0f;

NSString *const kTFAlertShowAnimationKey = @"showAnimation";

NSString *const kTFAlertHideAnimationKey = @"hideAnimation";

@interface TFCustomAlertView ()

@property (nonatomic,strong)UIView *shadowView;

@property (nonatomic,strong)UIView *containerView;

/**
 *  毛玻璃效果
 */
@property (nonatomic,strong)UIToolbar *toolBar;

@end

@implementation TFCustomAlertView

- (id)initWithContentFrame:(CGRect)frame position:( TFCustomAlertViewPosition)position
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    
    if (self)
    {
        //阴影层
        self.shadowView = [[UIView alloc] initWithFrame:self.bounds];
        self.shadowView.backgroundColor = [UIColor colorWithHexString:@"1d262e"];
        self.shadowView.alpha = 0;
        [self addSubview:_shadowView];
        
        //容器
        self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.containerView.backgroundColor = [UIColor clearColor];
        [self addSubview:_containerView];
        
        self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.containerView addSubview:_toolBar];
        
        self.showPosition = position;
        self.hidden = YES;
    }
    
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    CGPoint point = [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(_containerView.frame, point))
    {
        [self hide];
    }
}

- (id)initWithContentView:(UIView *)contentView position:( TFCustomAlertViewPosition)position
{
    self = [self initWithContentFrame:contentView.frame position:position];
    if (self)
    {
        self.contentView = contentView;
    }
    
    return self;
}

- (void)setShowPosition:( TFCustomAlertViewPosition)showPosition
{
    _showPosition = showPosition;
    
    switch (self.showPosition)
    {
        case  TFCustomAlertViewPositionTop:
            
            self.needBackground = NO;
            self.startPoint = CGPointMake(self.frame.size.width / 2, self.frame.size.height * 0.35);
            self.targetPoint = self.startPoint;
            
            break;
        case  TFCustomAlertViewPositionMiddle:
            self.needBackground = NO;
            self.startPoint = CGPointMake(self.frame.size.width / 2, self.frame.size.height * 0.43);
            self.targetPoint = self.startPoint;
            break;
            
        case  TFCustomAlertViewPositionBottom:
            self.needBackground = YES;
            self.startPoint = CGPointMake(self.frame.size.width / 2, self.frame.size.height + self.containerView.frame.size.height / 2);
            self.targetPoint = CGPointMake(self.frame.size.width / 2, self.frame.size.height - self.containerView.frame.size.height / 2);
            break;
        case  TFCustomAlertViewPositionFree:
            
            break;
        default:
            break;
    }
    
    self.containerView.center = self.startPoint;
}

- (void)setNeedBackground:(BOOL)needBackground
{
    _needBackground = needBackground;
    self.toolBar.hidden = !needBackground;
}


- (void)setContentView:(UIView *)contentView
{
    _contentView = contentView;
    [self.containerView addSubview:contentView];
}

- (void)showInView:(UIView *)view
{
    [view addSubview:self];
    [self show];
}

- (void)show
{
    if (!self.superview)
    {
        [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    }
    
    self.hidden = NO;
    
    switch (self.showPosition)
    {
        case  TFCustomAlertViewPositionTop:
            
            //break;
        case  TFCustomAlertViewPositionMiddle:
        {
            CAKeyframeAnimation *transformAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
            
            transformAnimation.duration = 0.3;
            transformAnimation.delegate = self;
            transformAnimation.values   = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0, 0, 0)],
                                          [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05f, 1.05f, 1.05f)],
                                          [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95f, 0.95f, 0.95f)],
                                          [NSValue valueWithCATransform3D:CATransform3DIdentity]];
            transformAnimation.keyTimes = @[@0, @0.4,@0.7, @1.0];
            
            transformAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                                   [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                                   [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                                   [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            
            [_containerView.layer addAnimation:transformAnimation forKey:kTFAlertShowAnimationKey];
        }
            break;
            
        case  TFCustomAlertViewPositionBottom:
        {
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path,NULL,self.startPoint.x, self.startPoint.y);
            CGPathAddLineToPoint(path, NULL, self.targetPoint.x, self.targetPoint.y - kAlertElasticityOffset / 2);
            CGPathAddLineToPoint(path, NULL, self.targetPoint.x, self.targetPoint.y + kAlertElasticityOffset / 4);
            CGPathAddLineToPoint(path, NULL, self.targetPoint.x, self.targetPoint.y);
            
            //以“position”为关键字
            CAKeyframeAnimation *positonAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            positonAnimation.removedOnCompletion = NO;
            positonAnimation.fillMode = kCAFillModeForwards;
            [positonAnimation setCalculationMode:kCAAnimationCubic];
            positonAnimation.duration = 0.3;
            [positonAnimation setKeyTimes:@[[NSNumber numberWithFloat:0],
                                            [NSNumber numberWithFloat:0.35],
                                            [NSNumber numberWithFloat:0.7],
                                            [NSNumber numberWithFloat:0.9]]];
            
            [positonAnimation setPath:path];
            positonAnimation.delegate = self;
            [self.containerView.layer addAnimation:positonAnimation forKey:kTFAlertShowAnimationKey];
        }
            break;
            
        case  TFCustomAlertViewPositionFree:
            
            break;
        default:
            break;
    }
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    
    opacityAnimation.fromValue           = [NSNumber numberWithFloat:0];
    opacityAnimation.toValue             = [NSNumber numberWithFloat:0.8];
    opacityAnimation.duration            = 0.3;
    opacityAnimation.removedOnCompletion = NO;
    opacityAnimation.fillMode            = kCAFillModeForwards;
    opacityAnimation.delegate            = self;
    
    [self.shadowView.layer addAnimation:opacityAnimation forKey:nil];
}

- (void)hide
{
    switch (self.showPosition)
    {
        case  TFCustomAlertViewPositionTop:
            
            //break;
        case  TFCustomAlertViewPositionMiddle:
        {
            CAKeyframeAnimation *transformAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
            
            transformAnimation.duration            = 0.15;
            transformAnimation.delegate            = self;
            transformAnimation.removedOnCompletion = NO;
            transformAnimation.fillMode            = kCAFillModeForwards;
            transformAnimation.values              = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05f, 1.05f, 1.05f)],
                                      [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 0.01f)]];
            
            transformAnimation.keyTimes = @[@0.2, @0.5];
            transformAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                               [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
            [self.containerView.layer addAnimation:transformAnimation forKey:kTFAlertHideAnimationKey];
        }
            break;
            
        case  TFCustomAlertViewPositionBottom:
        {
            CABasicAnimation *positonAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
            
            positonAnimation.fromValue           = [NSValue valueWithCGPoint:self.targetPoint];
            positonAnimation.toValue             = [NSValue valueWithCGPoint:self.startPoint];
            positonAnimation.duration            = 0.15;
            positonAnimation.removedOnCompletion = NO;
            positonAnimation.fillMode            = kCAFillModeForwards;
            positonAnimation.delegate            = self;
            
            [self.containerView.layer addAnimation:positonAnimation forKey:kTFAlertHideAnimationKey];
        }
            break;
            
        case  TFCustomAlertViewPositionFree:
            
            break;
        default:
            break;
    }
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    
    opacityAnimation.fromValue           = [NSNumber numberWithFloat:0.8];
    opacityAnimation.toValue             = [NSNumber numberWithFloat:0];
    opacityAnimation.duration            = 0.15;
    opacityAnimation.removedOnCompletion = NO;
    opacityAnimation.fillMode            = kCAFillModeForwards;
    opacityAnimation.delegate            = self;
    
    [self.shadowView.layer addAnimation:opacityAnimation forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag)
    {
        if (anim == [self.containerView.layer animationForKey:kTFAlertShowAnimationKey])
        {
            self.containerView.center = CGPointMake(self.containerView.center.x,
                                                       SCREEN_HEIGHT - self.containerView.frame.size.height / 2);
            [self.containerView.layer removeAllAnimations];
            
        }
        else if (anim == [self.containerView.layer animationForKey:kTFAlertHideAnimationKey])
        {
            self.containerView.center = self.startPoint;
            [self.containerView.layer removeAllAnimations];
            [self.shadowView.layer removeAllAnimations];
            [self removeFromSuperview];
        }
    }
}

@end
