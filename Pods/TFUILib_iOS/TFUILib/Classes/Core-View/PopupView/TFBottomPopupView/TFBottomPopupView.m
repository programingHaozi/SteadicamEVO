//
//  TFBottomPopupView.m
//  AFPopup
//
//  Created by Alvaro Franco on 3/7/14.
//  Copyright (c) 2014 xiayiyong. All rights reserved.
//

#import "TFBottomPopupView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+Category.h"

#define CATransform3DPerspective(t, x, y) (CATransform3DConcat(t, CATransform3DMake(1, 0, 0, x, 0, 1, 0, y, 0, 0, 1, 0, 0, 0, 0, 1)))
#define CATransform3DMakePerspective(x, y) (CATransform3DPerspective(CATransform3DIdentity, x, y))

CG_INLINE CATransform3D
CATransform3DMake(CGFloat m11, CGFloat m12, CGFloat m13, CGFloat m14,
				  CGFloat m21, CGFloat m22, CGFloat m23, CGFloat m24,
				  CGFloat m31, CGFloat m32, CGFloat m33, CGFloat m34,
				  CGFloat m41, CGFloat m42, CGFloat m43, CGFloat m44)
{
	CATransform3D t;
	t.m11 = m11; t.m12 = m12; t.m13 = m13; t.m14 = m14;
	t.m21 = m21; t.m22 = m22; t.m23 = m23; t.m24 = m24;
	t.m31 = m31; t.m32 = m32; t.m33 = m33; t.m34 = m34;
	t.m41 = m41; t.m42 = m42; t.m43 = m43; t.m44 = m44;
	return t;
}

@interface TFBottomPopupView ()

@property (nonatomic, assign) TFBottomPopupViewAnimateType type;

@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *backgroundShadowView;
@property (nonatomic, strong) UIImageView *renderImageView;

@end

@implementation TFBottomPopupView

- (id)initWithPopupView:(UIView*)popupView andHeight:(CGFloat)height
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
        
        self.backgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.backgroundView.backgroundColor = [UIColor blackColor];
        self.backgroundView.autoresizingMask = self.alertView.autoresizingMask;
        
        self.backgroundShadowView = [[UIView alloc] initWithFrame:self.frame];
        self.backgroundShadowView.backgroundColor = [UIColor blackColor];
        self.backgroundShadowView.alpha = 0.0;
        self.backgroundShadowView.autoresizingMask = self.alertView.autoresizingMask;
        
        self.renderImageView = [[UIImageView alloc] initWithFrame:self.frame];
        self.renderImageView.autoresizingMask = self.alertView.autoresizingMask;
        self.renderImageView.contentMode = UIViewContentModeScaleToFill;
        
        [self.alertView addSubview:popupView];
        [self addSubview:self.backgroundView];
        [self addSubview:self.renderImageView];
        [self addSubview:self.backgroundShadowView];
        [self addSubview:self.alertView];
    }
    
    return self;
}

- (void)showWithAnimateType:(TFBottomPopupViewAnimateType)type
{
    self.type=type;
    [self show];
}

-(void)show
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *rootView = keyWindow.rootViewController.view;

    UIImage *rootViewRenderImage = [self imageWithView:rootView];
    _renderImageView.image = rootViewRenderImage;
    
    _backgroundShadowView.alpha = 1.0;
    [keyWindow addSubview:self];
    _alertView.center = CGPointMake(self.frame.size.width/2.0, _alertView.frame.size.height * 1.5);
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         //_alertView.center = self.center;
                         _alertView.frame=CGRectMake(0,
                                                     [[UIScreen mainScreen]bounds].size.height-_alertView.frame.size.height,
                                                     _alertView.frame.size.width,
                                                     _alertView.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         _backgroundShadowView.alpha = 0.4;
                         _renderImageView.layer.transform = CATransform3DMakePerspective(0, -0.0007);
                     }
     
                     completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:0.2
                                          animations:^{
                                              float newWidht = _renderImageView.frame.size.width * 0.7;
                                              float newHeight = _renderImageView.frame.size.height * 0.7;
                                              _renderImageView.frame = CGRectMake(([[UIScreen mainScreen]bounds].size.width - newWidht) / 2, 22, newWidht, newHeight);
                                              _renderImageView.layer.transform = CATransform3DMakePerspective(0, 0);
                                          } completion:^(BOOL finished) {
                                              
                                          }];
                     }];

}

-(void)hide
{
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _alertView.center = CGPointMake(self.frame.size.width/2.0, _alertView.frame.size.height * 1.5);
                         _alertView.frame=CGRectMake(0, [[UIScreen mainScreen]bounds].size.height, _alertView.frame.size.width, _alertView.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         _backgroundShadowView.alpha = 0.0;
                         _renderImageView.layer.transform = CATransform3DMakePerspective(0, -0.0007);
                     }
     
                     completion:^(BOOL finished) {

                         [UIView animateWithDuration:0.2
                                          animations:^{
                                              _renderImageView.frame = [[UIScreen mainScreen]bounds];
                                              _renderImageView.layer.transform = CATransform3DMakePerspective(0, 0);
                                          } completion:^(BOOL finished) {
                                              [self removeFromSuperview];
                                          }];
                     }];
}

-(UIImage *)imageWithView:(UIView *)view
{
    
    UIGraphicsBeginImageContextWithOptions(_renderImageView.frame.size, view.opaque, [[UIScreen mainScreen] scale]);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return backgroundImage;
}

@end
