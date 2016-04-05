//
//  IntroductionViewCollectionCell.m
//  SteadicamEVO
//
//  Created by 耗子 on 16/4/5.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import "IntroductionViewCollectionCell.h"
#import "GifViews.h"

@interface IntroductionViewCollectionCell()

/**
 *  播放gif视图
 */
@property (nonatomic, strong) GifViews *gifView;

@end

@implementation IntroductionViewCollectionCell

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
    self.gifView = [[GifViews alloc]init];
    [self.contentView addSubview:self.gifView];
}

- (void)autolayoutViews
{
    WS(weakSelf)
    [self.gifView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.mas_top).offset(0);
        make.left.equalTo(weakSelf.mas_left).offset(0);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(0);
        make.right.equalTo(weakSelf.mas_right).offset(0);
    }];
}

- (void)bindData
{
    
}


@end
