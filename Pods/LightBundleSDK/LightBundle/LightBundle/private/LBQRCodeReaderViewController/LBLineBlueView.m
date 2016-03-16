//
//  LBLineBlueView.m
//  Orange
//
//  Created by limingchen on 15/3/4.
//  Copyright (c) 2015年 Chexiang. All rights reserved.
//

#import "LBLineBlueView.h"

@implementation LBLineBlueView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.alpha = 0.0;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置矩形填充颜色
    CGContextSetRGBFillColor(context, 37.0/255.0, 169.0/255.0, 226.0/255.0, 1.0);
    //填充矩形
    CGRect leftup1 = CGRectMake(0,0,4,18);
    CGContextFillRect(context, leftup1);
    CGRect leftup2 = CGRectMake(4,0,14,4);
    CGContextFillRect(context, leftup2);
    
    CGRect rightup1 = CGRectMake(CGRectGetMaxX(self.bounds) - 4 - 1,0,4,18);
    CGContextFillRect(context, rightup1);
    CGRect righttup2 = CGRectMake(CGRectGetMaxX(self.bounds) - 18,0,14,4);
    CGContextFillRect(context, righttup2);
    
    CGRect leftdown1 = CGRectMake(0,CGRectGetMaxY(self.bounds) - 18,4,18);
    CGContextFillRect(context, leftdown1);
    CGRect leftdown2 = CGRectMake(4,CGRectGetMaxY(self.bounds) - 4,14,4);
    CGContextFillRect(context, leftdown2);
    
    CGRect rightdown1 = CGRectMake(CGRectGetMaxX(self.bounds) - 4 - 1,CGRectGetMaxY(self.bounds) - 18,4,18);
    CGContextFillRect(context, rightdown1);
    CGRect rightdown2 = CGRectMake(CGRectGetMaxX(self.bounds) - 18,CGRectGetMaxY(self.bounds) - 4,14,4);
    CGContextFillRect(context, rightdown2);
    
    CGContextStrokePath(context);
}


@end
