//
//  UIButton+Ext.m
//  Treasure
//
//  Created by xiayiyong on 15/7/1.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "UIButton+Ext.h"

// image
// Only load png image successfully.
#define kImageWithName(Name) ([UIImage imageNamed:Name])
#define kBigImageWithName(Name) ([UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:Name ofType:nil]])


@implementation UIButton (Ext)

#pragma mark - 设置按钮正常状态下的图片

- (void)setNormalImage:(id)image
{
    if ([image isKindOfClass:[UIImage class]])
    {
        [self setImage:image forState:UIControlStateNormal];
    }
    else if ([image isKindOfClass:[UIColor class]])
    {
        [self setImage:[self imageWithColor:image] forState:UIControlStateNormal];
    }
    else if ([image isKindOfClass:[NSString class]])
    {
        if ([image length]>0)
        {
            [self setImage:kImageWithName(image) forState:UIControlStateNormal];
        }
    }
}

- (void)setNormalBackgroundImage:(id)image
{
    if ([image isKindOfClass:[UIImage class]])
    {
        [self setBackgroundImage:image forState:UIControlStateNormal];
    }
    else if ([image isKindOfClass:[UIColor class]])
    {
        [self setBackgroundImage:[self imageWithColor:image] forState:UIControlStateNormal];
    }
    else if ([image isKindOfClass:[NSString class]])
    {
        if ([image length]>0)
        {
            [self setBackgroundImage:kImageWithName(image) forState:UIControlStateNormal];
        }
    }
}

#pragma mark - 设置按钮Hightlighted状态下的图片

- (void)setHightlightedImage:(id)image
{
    if ([image isKindOfClass:[UIImage class]])
    {
        [self setImage:image forState:UIControlStateHighlighted];
    }
    else if ([image isKindOfClass:[UIColor class]])
    {
        [self setImage:[self imageWithColor:image] forState:UIControlStateHighlighted];
    }
    else if ([image isKindOfClass:[NSString class]])
    {
        if ([image length]>0)
        {
            [self setImage:kImageWithName(image) forState:UIControlStateHighlighted];
        }
    }
}

- (void)setHightlightedBackgroundImage:(id)image
{
    if ([image isKindOfClass:[UIImage class]])
    {
        [self setBackgroundImage:image forState:UIControlStateHighlighted];
    }
    else if ([image isKindOfClass:[UIColor class]])
    {
        [self setBackgroundImage:[self imageWithColor:image] forState:UIControlStateHighlighted];
    }
    else if ([image isKindOfClass:[NSString class]])
    {
        if ([image length]>0)
        {
            [self setBackgroundImage:kImageWithName(image) forState:UIControlStateHighlighted];
        }
    }
}

#pragma mark - 设置按钮Selected状态下的图片

- (void)setSelectedImage:(id)image
{
    if ([image isKindOfClass:[UIImage class]])
    {
        [self setImage:image forState:UIControlStateSelected];
    }
    else if ([image isKindOfClass:[UIColor class]])
    {
        [self setImage:[self imageWithColor:image] forState:UIControlStateSelected];
    }
    else if ([image isKindOfClass:[NSString class]])
    {
        if ([image length]>0)
        {
            [self setImage:kImageWithName(image) forState:UIControlStateSelected];
        }
    }
}

- (void)setSelectedBackgroundImage:(id)image
{
    if ([image isKindOfClass:[UIImage class]])
    {
        [self setBackgroundImage:image forState:UIControlStateSelected];
    }
    else if ([image isKindOfClass:[UIColor class]])
    {
        [self setBackgroundImage:[self imageWithColor:image] forState:UIControlStateSelected];
    }
    else if ([image isKindOfClass:[NSString class]])
    {
        if ([image length]>0)
        {
            [self setBackgroundImage:kImageWithName(image) forState:UIControlStateSelected];
        }
    }
}

#pragma mark - 设置按钮禁用状态下的图片

- (void)setDisabledImage:(id)image
{
    if ([image isKindOfClass:[UIImage class]])
    {
        [self setImage:image forState:UIControlStateDisabled];
    }
    else if ([image isKindOfClass:[UIColor class]])
    {
        [self setImage:[self imageWithColor:image] forState:UIControlStateDisabled];
    }
    else if ([image isKindOfClass:[NSString class]])
    {
        [self setImage:kImageWithName(image) forState:UIControlStateDisabled];
    }
}

- (void)setDisabledBackgroundImage:(id)image
{
    if ([image isKindOfClass:[UIImage class]])
    {
        [self setBackgroundImage:image forState:UIControlStateDisabled];
    }
    else if ([image isKindOfClass:[UIColor class]])
    {
        [self setBackgroundImage:[self imageWithColor:image] forState:UIControlStateDisabled];
    }
    else if ([image isKindOfClass:[NSString class]])
    {
        [self setBackgroundImage:kImageWithName(image) forState:UIControlStateDisabled];
    }
}

#pragma mark - 设置按钮按钮全部状态背景

- (void)setNormalImage:(id)normalImage hightlightedImage:(id)hightlightedImage disabledImage:(id)disabledImage
{
    [self setNormalImage:normalImage];
    [self setHightlightedImage:hightlightedImage];
    [self setDisabledImage:disabledImage];
}

#pragma mark - 设置按钮按钮全部状态背景
- (void)setNormalBackgroundImage:(id)normalImage hightlightedImage:(id)hightlightedImage disabledImage:(id)disabledImage
{
    [self setNormalBackgroundImage:normalImage];
    [self setHightlightedBackgroundImage:hightlightedImage];
    [self setDisabledBackgroundImage:disabledImage];
}

#pragma mark - 设置标题

- (void)setNormalTitle:(NSString *)title
{
  [self setTitle:title forState:UIControlStateNormal];
}

- (void)setHighlightedTitle:(NSString *)title
{
  [self setTitle:title forState:UIControlStateHighlighted];
}

- (void)setSelectedTitle:(NSString *)title
{
  [self setTitle:title forState:UIControlStateSelected];
}

#pragma mark - 设置标题颜色
- (void)setNormalTitleColor:(UIColor *)titleColor
{
  [self setTitleColor:titleColor forState:UIControlStateNormal];
}

- (void)setHighlightedTitleColor:(UIColor *)titleColor
{
  [self setTitleColor:titleColor forState:UIControlStateHighlighted];
}

- (void)setSelectedTitleColor:(UIColor *)titleColor
{
  [self setTitleColor:titleColor forState:UIControlStateSelected];
}

#pragma mark - 设置标题 和 颜色
- (void)setNormalTitle:(NSString *)title textColor:(UIColor *)color
{
  [self setNormalTitle:title];
  [self setNormalTitleColor:color];
}

- (void)setHighlightedTitle:(NSString *)title textColor:(UIColor *)color
{
  [self setHighlightedTitle:title];
  [self setHighlightedTitleColor:color];
}

- (void)setSelectedTitle:(NSString *)title textColor:(UIColor *)color
{
  [self setSelectedTitle:title];
  [self setSelectedTitleColor:color];
}

#pragma mark -
/*!
 * 设置按钮状态下的字体大小
 */
- (void)setFontSize:(CGFloat)fontSize
{
  self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
}

- (void)setBoldFontSize:(CGFloat)boldFontSize
{
  self.titleLabel.font = [UIFont boldSystemFontOfSize:boldFontSize];
}

- (void)setNormalImageWithName:(NSString *)imageName title:(NSString *)title isImageLeft:(BOOL)isLeft
{
  [self setNormalImage:imageName];
  [self setNormalTitle:title];
  
  if (isLeft)
  {
    self.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, -20);
  }
  else
  {
    CGFloat w = self.frame.size.width;
    CGFloat imgW = self.imageView.image.size.width;
    self.imageEdgeInsets = UIEdgeInsetsMake(0, w - imgW, 0, -10 + imgW);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 15);
  }
}

-(UIImage *)imageWithColor:(UIColor *)color
{
    return [self imageWithColor:color size:CGSizeMake(1, 1)];
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
