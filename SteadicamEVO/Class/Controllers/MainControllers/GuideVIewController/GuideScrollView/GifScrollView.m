//
//  GifScrollView.m
//  SteadicamEVO
//
//  Created by Chen Hao 陈浩 on 16/4/19.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import "GifScrollView.h"
#import "PrepareChooseView.h"
#import "GifViews.h"

@interface GifScrollView()

@property (nonatomic, strong) NSMutableArray *subViews;

/**
 *  选择视图
 */
@property (nonatomic, strong) PrepareChooseView *chooseView;

@end


@implementation GifScrollView

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
    _subViews = [[NSMutableArray alloc]init];
    
    
}

-(void)autolayoutViews
{
    
}

-(void)bindData
{
    [RACObserve(self, dataArray) subscribeNext:^(id x) {
        
        
    }];
    
    [RACObserve(self, showChoose) subscribeNext:^(id x) {
        
    }];
}



@end
