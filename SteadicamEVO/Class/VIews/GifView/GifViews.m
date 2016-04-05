//
//  GifViews.m
//  SteadicamEVO
//
//  Created by 耗子 on 16/4/5.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import "GifViews.h"

@interface GifViews()

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UIWebView *gifView;

@end

@implementation GifViews

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

- (void)initViews
{
    self.bgImageView = [[UIImageView alloc]init];
    self.bgImageView.image = IMAGE(@"guideGifBg");
    [self addSubview:self.bgImageView];
    
    self.gifView = [[UIWebView alloc]init];
    
    //自动调整尺寸
    self.gifView.scalesPageToFit = YES;
    //禁止滚动
    self.gifView.scrollView.scrollEnabled = NO;
    //设置透明效果
    self.gifView.backgroundColor = [UIColor clearColor];
    self.gifView.opaque = 0;
    
    [self addSubview:self.gifView];
    
}

-(void)autolayoutViews
{
    WS(weakSelf)
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.mas_top).offset(0);
        make.left.equalTo(weakSelf.mas_left).offset(0);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(0);
        make.right.equalTo(weakSelf.mas_right).offset(0);
    }];
    
    [self.gifView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.mas_top).offset(0);
        make.left.equalTo(weakSelf.mas_left).offset(0);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(0);
        make.right.equalTo(weakSelf.mas_right).offset(0);
    }];
}

-(void)bindData
{
    
}

@end
