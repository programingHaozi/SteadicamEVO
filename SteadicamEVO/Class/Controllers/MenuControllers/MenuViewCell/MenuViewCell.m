//
//  MenuViewCell.m
//  SteadicamEVO
//
//  Created by 耗子 on 16/4/6.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import "MenuViewCell.h"

@interface MenuViewCell()

@property (nonatomic, strong) UIImageView *BGImageView;

@property (nonatomic, strong) UIImageView *accessoryImageVIew;

@property (nonatomic, strong) UIImageView *seperateLine;

@end

@implementation MenuViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)initViews
{
    [super initViews];
    
    self.BGImageView = [[UIImageView alloc]init];
    self.BGImageView.backgroundColor = [UIColor clearColor];
    [self.contentView insertSubview:self.BGImageView atIndex:0];
    
    self.accessoryImageVIew = [[UIImageView alloc]init];
    self.accessoryImageVIew.image = IMAGE(@"arrow_right_gray");
    [self.contentView addSubview:self.accessoryImageVIew];
    
    self.seperateLine = [[UIImageView alloc]init];
    self.seperateLine.image = IMAGE(@"seperateLine");
    [self.contentView addSubview:self.seperateLine];
}

- (void)autolayoutViews
{
    [super autolayoutViews];
    
    WS(weakSelf)
    [self.BGImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.mas_top).offset(0);
        make.left.equalTo(weakSelf.mas_left).offset(0);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(0);
        make.right.equalTo(weakSelf.mas_right).offset(0);
    }];
    
    [self.seperateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@1);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(0);
        make.left.equalTo(weakSelf.mas_left).offset(24);
        make.right.equalTo(weakSelf.mas_right).offset(-24);
    }];
    
    [self.accessoryImageVIew mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@9);
        make.height.equalTo(@14);
        make.centerY.equalTo(weakSelf.mas_centerY).offset(0);
        make.right.equalTo(weakSelf.mas_right).offset(-35);
    }];
}

- (void)bindData
{
    [super bindData];
}

@end
