//
//  TFTextField.m
//  TFUILib
//
//  Created by xiayiyong on 16/1/12.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFTextField.h"
#import <TFBaseLib_iOS/TFBaseUtil+Valid.h>

@interface TFTextField() <UITextFieldDelegate>

@end

@implementation TFTextField

- (instancetype)initWithFrame:(CGRect)frame
                         text:(NSString *)text
                  placeholder:(NSString *)placeholder
{
    if (self = [super initWithFrame:frame])
    {
        self.text = text;
        self.placeholder = placeholder;
    }
    
    return self;
}

#pragma mark - setter -

- (void)setLeftMargin:(NSNumber *)leftMargin
{
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, leftMargin.floatValue, CGRectGetHeight(self.bounds))];
    leftView.alpha = 0.0;
    self.leftView = leftView;
    self.leftViewMode = UITextFieldViewModeAlways;
    
    _leftMargin = leftMargin;
}

- (void)setBottomBorderColor:(UIColor *)underlineColor
{
    _bottomBorderColor = underlineColor;
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    // Draw underline if need
    if (self.bottomBorderColor != nil) {
        CGFloat r, g, b, a;
        [self.bottomBorderColor getRed:&r green:&g blue:&b alpha:&a];
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(ctx, 1.0);
        CGContextSetRGBStrokeColor(ctx, r, g, b, a);
        CGContextMoveToPoint(ctx, 0, rect.size.height - 1);
        CGContextAddLineToPoint(ctx, rect.size.width, rect.size.height - 1);
        CGContextStrokePath(ctx);
    }
}

@end
