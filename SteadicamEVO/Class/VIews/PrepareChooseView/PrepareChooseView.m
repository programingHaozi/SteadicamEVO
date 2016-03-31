//
//  PrepareChooseView.m
//  SteadicamEVO
//
//  Created by Chen Hao 陈浩 on 16/3/31.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import "PrepareChooseView.h"

@implementation PrepareChooseView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
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
   return [self initWithLeft:nil right:nil title:nil];
}

-(instancetype)initWithLeft:(id)left right:(id)right title:(NSString *)title
{
    if (self = [super init])
    {
        [self initViews];
        [self autolayoutViews];
        [self bindData];
    }
    
    return self;
}

- (void)initViews
{
    
}

- (void)autolayoutViews
{
    
}

-(void)bindData
{
    
}

@end
