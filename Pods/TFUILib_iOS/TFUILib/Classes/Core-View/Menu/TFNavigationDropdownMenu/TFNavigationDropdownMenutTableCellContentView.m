//
//  TFNavigationDropdownMenutTableCellContentView.m
//  TFNavigationDropdownMenu
//
//  Created by xiayiyong on 02/08/2015.
//  Copyright (c) 2015 xiayiyong. All rights reserved.
//

#import "TFNavigationDropdownMenutTableCellContentView.h"

@implementation TFNavigationDropdownMenutTableCellContentView

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    if ([UINavigationBar appearance].barStyle == UIBarStyleDefault)
    {
        CGContextSetRGBStrokeColor(context, 0, 0, 0, 0.4);
    }
    else
    {
        CGContextSetRGBStrokeColor(context, 1, 1, 1, 0.3);
    }
    CGContextSetLineWidth(context, 1);
    CGContextMoveToPoint(context, 0, self.bounds.size.height);
    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
    CGContextStrokePath(context);
}

@end
