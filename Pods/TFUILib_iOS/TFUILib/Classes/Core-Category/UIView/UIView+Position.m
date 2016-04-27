//
//  UIView+Position.m
//  StringDemo
//
//  Created by xiayiyong on 15/7/1.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "UIView+Position.h"

@implementation UIView (Position)

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x
{
    CGRect frame   = self.frame;
    frame.origin.x = x;
    self.frame     = frame;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right
{
    CGRect frame   = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame     = frame;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y
{
    CGRect frame   = self.frame;
    frame.origin.y = y;
    self.frame     = frame;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect frame   = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame     = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame     = self.frame;
    frame.size.width = width;
    self.frame       = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame      = self.frame;
    frame.size.height = height;
    self.frame        = frame;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    self.center = CGPointMake(centerX, self.center.y);
    
    return;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY
{
    self.center = CGPointMake(self.center.x, centerY);
    
    return;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame   = frame;
    
    return;
}

-(void)setTopLeft:(CGPoint)topLeft
{
    [self setTop:topLeft.y];
    [self setLeft:topLeft.x];
}

-(CGPoint)topLeft
{
    return CGPointMake(self.left, self.top);
}

-(void)setTopRight:(CGPoint)topRight
{
    [self setTop:topRight.y];
    [self setRight:topRight.x];
}

-(CGPoint)topRight
{
    return CGPointMake(self.right, self.top);
}

-(void)setBottomLeft:(CGPoint)bottomLeft
{
    [self setBottom:bottomLeft.y];
    [self setLeft:bottomLeft.x];
}

-(CGPoint)bottomLeft
{
    return CGPointMake(self.left, self.bottom);
}

-(void)setBottomRight:(CGPoint)bottomRight
{
    [self setBottom:bottomRight.y];
    [self setRight:bottomRight.x];
}

-(CGPoint)bottomRight
{
    return CGPointMake(self.right, self.bottom);
}

-(void)setLeftTop:(CGPoint)leftTop
{
    [self setTopLeft:leftTop];
}

-(CGPoint)leftTop
{
    return self.topLeft;
}

-(void)setLeftBottom:(CGPoint)leftBottom
{
    [self setBottomLeft:leftBottom];
}

-(CGPoint)leftBottom
{
    return self.bottomLeft;
}

-(void)setRightTop:(CGPoint)rightTop
{
    [self setTopRight:rightTop];
}

-(CGPoint)rightTop
{
    return self.topRight;
}

-(void)setRightBottom:(CGPoint)rightBottom
{
    [self setBottomRight:rightBottom];
}

-(CGPoint)rightBottom
{
    return self.bottomRight;
}

-(CGFloat)screenWidth
{
    return [UIScreen mainScreen].bounds.size.width;
}

-(CGFloat)screenHeight
{
    return [UIScreen mainScreen].bounds.size.height;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
    
    return;
}

- (CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
    self.clipsToBounds = cornerRadius > 0.0;
}

- (UIColor *)borderColor
{
    return [[UIColor alloc] initWithCGColor:self.layer.borderColor];
}

- (void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
}

- (CGFloat)borderWidth
{
    return self.layer.borderWidth;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
}

- (UIColor *)shadowColor
{
    return [[UIColor alloc] initWithCGColor:self.layer.shadowColor];
}

- (void)setShadowColor:(UIColor *)shadowColor
{
    self.layer.shadowColor = shadowColor.CGColor;
}

- (void)setBorderWithCornerRadius:(CGFloat)radius width:(CGFloat)width color:(UIColor *)color
{
    if (radius >= 0.0) {
        self.cornerRadius = radius;
    }
    
    if (width >= 0.0) {
        self.borderWidth = width;
    }
    
    self.borderColor = color;
    
    self.clipsToBounds = radius > 0.0;
}


@end
