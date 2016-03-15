//
//  TFLabel.m
//  TFUILib
//
//  Created by xiayiyong on 16/1/12.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFLabel.h"

@implementation TFLabel

#pragma mark - Accessors

@synthesize verticalTextAlignment = _verticalTextAlignment;

- (void)setVerticalTextAlignment:(TFLabelVerticalTextAlignment)verticalTextAlignment
{
    _verticalTextAlignment = verticalTextAlignment;
    
    [self setNeedsLayout];
}

@synthesize textEdgeInsets = _textEdgeInsets;

- (void)setTextEdgeInsets:(UIEdgeInsets)textEdgeInsets
{
    _textEdgeInsets = textEdgeInsets;
    
    [self setNeedsLayout];
}

#pragma mark - UIView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)aFrame
{
    if ((self = [super initWithFrame:aFrame]))
    {
        [self initialize];
    }
    return self;
}

#pragma mark - UILabel

- (void)drawTextInRect:(CGRect)rect
{
    rect = UIEdgeInsetsInsetRect(rect, self.textEdgeInsets);
    
    if (self.verticalTextAlignment == TFLabelVerticalTextAlignmentTop)
    {
        CGSize sizeThatFits = [self sizeThatFits:rect.size];
        rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, sizeThatFits.height);
    }
    else if (self.verticalTextAlignment == TFLabelVerticalTextAlignmentBottom)
    {
        CGSize sizeThatFits = [self sizeThatFits:rect.size];
        rect = CGRectMake(rect.origin.x, rect.origin.y + (rect.size.height - sizeThatFits.height), rect.size.width, sizeThatFits.height);
    }
    
    [super drawTextInRect:rect];
}

#pragma mark - Private

- (void)initialize
{
    self.verticalTextAlignment = TFLabelVerticalTextAlignmentMiddle;
    self.textEdgeInsets = UIEdgeInsetsZero;
}

@end
