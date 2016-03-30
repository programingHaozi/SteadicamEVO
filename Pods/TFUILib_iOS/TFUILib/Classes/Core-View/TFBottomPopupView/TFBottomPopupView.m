//
//  TFBottomPopupView.m
//  AFPopup
//
//  Created by Alvaro Franco on 3/7/14.
//  Copyright (c) 2014 xiayiyong. All rights reserved.
//

#import "TFBottomPopupView.h"
#import <QuartzCore/QuartzCore.h>

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

@property (nonatomic, strong) UIView *modalView;
@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) UIView *backgroundShadowView;
@property (nonatomic, strong) UIImageView *renderImage;

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
        
        self.modalView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, height)];
        self.modalView.backgroundColor = [UIColor clearColor];
        self.modalView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight |
        UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
        UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        
        self.blackView = [[UIView alloc] initWithFrame:self.frame];
        self.blackView.backgroundColor = [UIColor blackColor];
        self.blackView.autoresizingMask = self.modalView.autoresizingMask;
        
        self.backgroundShadowView = [[UIView alloc] initWithFrame:self.frame];
        self.backgroundShadowView.backgroundColor = [UIColor blackColor];
        self.backgroundShadowView.alpha = 0.0;
        self.backgroundShadowView.autoresizingMask = self.modalView.autoresizingMask;
        
        self.renderImage = [[UIImageView alloc] initWithFrame:self.frame];
        self.renderImage.autoresizingMask = self.modalView.autoresizingMask;
        self.renderImage.contentMode = UIViewContentModeScaleToFill;
        
        [self.modalView addSubview:popupView];
        [self addSubview:self.blackView];
        [self addSubview:self.renderImage];
        [self addSubview:self.backgroundShadowView];
        [self addSubview:self.modalView];
    }
    
    return self;
}

-(void)show
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *rootView = keyWindow.rootViewController.view;

    UIImage *rootViewRenderImage = [self imageWithView:rootView];
    _renderImage.image = rootViewRenderImage;
    
    _backgroundShadowView.alpha = 1.0;
    [keyWindow addSubview:self];
    _modalView.center = CGPointMake(self.frame.size.width/2.0, _modalView.frame.size.height * 1.5);
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         //_modalView.center = self.center;
                         _modalView.frame=CGRectMake(0,
                                                     [[UIScreen mainScreen]bounds].size.height-_modalView.frame.size.height,
                                                     _modalView.frame.size.width,
                                                     _modalView.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         _backgroundShadowView.alpha = 0.4;
                         _renderImage.layer.transform = CATransform3DMakePerspective(0, -0.0007);
                     }
     
                     completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:0.2
                                          animations:^{
                                              float newWidht = _renderImage.frame.size.width * 0.7;
                                              float newHeight = _renderImage.frame.size.height * 0.7;
                                              _renderImage.frame = CGRectMake(([[UIScreen mainScreen]bounds].size.width - newWidht) / 2, 22, newWidht, newHeight);
                                              _renderImage.layer.transform = CATransform3DMakePerspective(0, 0);
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
                         _modalView.center = CGPointMake(self.frame.size.width/2.0, _modalView.frame.size.height * 1.5);
                         _modalView.frame=CGRectMake(0, [[UIScreen mainScreen]bounds].size.height, _modalView.frame.size.width, _modalView.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         _backgroundShadowView.alpha = 0.0;
                         _renderImage.layer.transform = CATransform3DMakePerspective(0, -0.0007);
                     }
     
                     completion:^(BOOL finished) {

                         [UIView animateWithDuration:0.2
                                          animations:^{
                                              _renderImage.frame = [[UIScreen mainScreen]bounds];
                                              _renderImage.layer.transform = CATransform3DMakePerspective(0, 0);
                                          } completion:^(BOOL finished) {
                                              [self removeFromSuperview];
                                          }];
                     }];
}

-(UIImage *)imageWithView:(UIView *)view
{
    
    UIGraphicsBeginImageContextWithOptions(_renderImage.frame.size, view.opaque, [[UIScreen mainScreen] scale]);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return backgroundImage;
}

@end
