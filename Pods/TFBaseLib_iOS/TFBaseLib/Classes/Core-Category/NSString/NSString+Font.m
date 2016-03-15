//
//  NSString+Font.m
//  TFBaseLib
//
//  Created by xiayiyong on 16/3/14.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "NSString+Font.h"

@implementation NSString (Font)

- (CGSize)widthWithFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode
{
    CGSize result;
    if (!font) font = [UIFont systemFontOfSize:12];
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
    {
        NSMutableDictionary *attr = [NSMutableDictionary new];
        attr[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakByWordWrapping)
        {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineBreakMode = lineBreakMode;
            attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        CGRect rect = [self boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attr context:nil];
        result = rect.size;
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
    return result;
}

- (CGFloat)widthWithFont:(UIFont *)font width:(CGFloat)width
{
    CGSize size = [self widthWithFont:font size:CGSizeMake(width, HUGE) mode:NSLineBreakByWordWrapping];
    return size.width;
}

- (CGFloat)heightWithFont:(UIFont *)font width:(CGFloat)width
{
    CGSize size = [self widthWithFont:font size:CGSizeMake(width, HUGE) mode:NSLineBreakByWordWrapping];
    return size.height;
}

- (CGFloat)widthWithFont:(UIFont *)font
{
    CGSize size = [self widthWithFont:font size:CGSizeMake(HUGE, HUGE) mode:NSLineBreakByWordWrapping];
    return size.width;
}

- (CGFloat)heightWithFont:(UIFont *)font
{
    CGSize size = [self widthWithFont:font size:CGSizeMake(HUGE, HUGE) mode:NSLineBreakByWordWrapping];
    return size.height;
}

@end
