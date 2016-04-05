//
//  AdjustmentView.m
//  SteadicamEVO
//
//  Created by Chen Hao 陈浩 on 16/4/5.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import "AdjustmentView.h"

@implementation AdjustmentView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self initViews];
        [self autolayoutViews];
        [self bindData];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initViews];
        [self autolayoutViews];
        [self bindData];
    }
    
    return self;
}

-(void)initViews
{
    
}

-(void)autolayoutViews
{
    
}

-(void)bindData
{
    
}

@end
