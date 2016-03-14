//
//  NSString+SelfSize.m
//  Mamahome
//
//  Created by AQ on 15-4-21.
//  Copyright (c) 2015年 OIT. All rights reserved.
//

#import "NSString+SelfSize.h"

@implementation NSString (SelfSize)
- (CGSize)getSizeFromSelfWithWidth:(CGFloat)width andFont:(CGFloat)font
{
    CGFloat fontT = font;
    if(font<1)
        fontT = 17.;
    UIFont *fontTemp = [UIFont systemFontOfSize:fontT];
    NSDictionary *attribute = @{NSFontAttributeName:fontTemp};
    CGSize labelSize = [self boundingRectWithSize:CGSizeMake(width, 999) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
    return labelSize;
}

- (CGSize)getSizeFromSelfWithWidth:(CGFloat)width andUIFont:(UIFont *)font
{
    UIFont *fontTemp = font;
    if(!font)
        fontTemp = [UIFont systemFontOfSize:17.];
    NSDictionary *attribute = @{NSFontAttributeName:fontTemp};
    CGSize labelSize = [self boundingRectWithSize:CGSizeMake(width, 999) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
    return labelSize;
}
@end
