//
//  LBXScanLineAnimation.m
//
//
//  Created by lbxia on 15/11/3.
//  Copyright © 2015年 lbxia. All rights reserved.
//

#import "LBXScanLineAnimation.h"

@interface LBXScanLineAnimation()
{
    BOOL isAnimationing;
}

@property (nonatomic,assign) CGRect animationRect;

@end

@implementation LBXScanLineAnimation

- (instancetype)init
{
    self = [super init];
    if (self)
    {

    }
    return self;
}

- (void)dealloc
{
    [self stopAnimating];
}

- (void)stepAnimation
{
    if (!isAnimationing)
    {
        return;
    }
   
    CGFloat leftx = _animationRect.origin.x + 5;
    CGFloat width = _animationRect.size.width - 10;
    
    self.frame = CGRectMake(leftx, _animationRect.origin.y + 8, width, 8);
    
    self.alpha = 0.0;
    
    self.hidden = NO;
    
    __weak __typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         weakSelf.alpha = 1.0;
                     }
                     completion:^(BOOL finished){

                     }];
    
    [UIView animateWithDuration:3
                     animations:^{
                         CGFloat leftx = _animationRect.origin.x + 5;
                         CGFloat width = _animationRect.size.width - 10;
                         weakSelf.frame = CGRectMake(leftx, _animationRect.origin.y + _animationRect.size.height - 8, width, 4);
                     }
                     completion:^(BOOL finished){
                         self.hidden = YES;
                         [weakSelf performSelector:@selector(stepAnimation) withObject:nil afterDelay:0.3];
                     }];
}

- (void)startAnimatingWithRect:(CGRect)animationRect inView:(UIView *)parentView image:(UIImage*)image
{
    if (isAnimationing)
    {
        return;
    }
    
    isAnimationing = YES;

    self.animationRect = animationRect;
    
    CGFloat centery = CGRectGetMinY(animationRect) + CGRectGetHeight(animationRect)/2;
    CGFloat leftx = animationRect.origin.x + 5;
    CGFloat width = animationRect.size.width - 10;
    
    self.frame = CGRectMake(leftx, centery, width, 2);
    self.image = image;
    
    [parentView addSubview:self];
    
    [self stepAnimation];
    
}

- (void)stopAnimating
{
    if (isAnimationing)
    {
        isAnimationing = NO;
        
        [self removeFromSuperview];
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];  
}

@end
