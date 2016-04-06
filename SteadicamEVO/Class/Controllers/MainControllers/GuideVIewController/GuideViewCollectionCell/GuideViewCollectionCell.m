//
//  GuideViewCollectionCell.m
//  SteadicamEVO
//
//  Created by Chen Hao 陈浩 on 16/3/30.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import "GuideViewCollectionCell.h"
#import "PrepareChooseView.h"
#import "GifViews.h"

@interface GuideViewCollectionCell()

/**
 *  播放gif视图
 */
@property (nonatomic, strong) GifViews *gifView;

/**
 *  选择视图
 */
@property (nonatomic, strong) PrepareChooseView *chooseView;

@end

@implementation GuideViewCollectionCell

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
    WS(weakSelf)
    [RACObserve(self, moviePath) subscribeNext:^(NSString *path) {
        
        weakSelf.gifView.moviePath = path;
    }];
}

- (void)addSelectViewWithLeft:(NSString *)left
                        right:(NSString *)right
                        title:(NSString *)title
                        block:(void (^)(NSInteger))selectBlock
{
    self.gifView.hidden = YES;
    
    self.chooseView = [[PrepareChooseView alloc]initWithLeft:left
                                                       right:right
                                                       title:title];
    [self.contentView addSubview:self.chooseView];
    
    WS(weakSelf)
    [self.chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.mas_top).offset(40);
        make.left.equalTo(weakSelf.mas_left).offset(0);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-40);
        make.right.equalTo(weakSelf.mas_right).offset(0);
    }];
    
    self.chooseView.selectBlock = selectBlock;
}

-(void)removeSelectView
{
    self.gifView.hidden = NO;
    
    if (self.chooseView)
    {
        [self.chooseView removeFromSuperview];
    }
}


@end
