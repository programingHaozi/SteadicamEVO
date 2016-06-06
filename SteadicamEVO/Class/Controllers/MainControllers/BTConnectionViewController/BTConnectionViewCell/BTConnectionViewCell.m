//
//  BTConnectionViewCell.m
//  SteadicamEVO
//
//  Created by Chen Hao 陈浩 on 16/6/3.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import "BTConnectionViewCell.h"

@implementation BTConnectionViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = [UIColor clearColor];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    return self;
}

- (void)initViews
{
    [super initViews];
    
    self.accessoryImageVIew.image = IMAGE(@"BT_select");
    
    self.BTNameLabel = [[UILabel alloc]init];
    self.BTNameLabel.textColor = [UIColor whiteColor];
    self.BTNameLabel.font = [UIFont systemFontOfSize:11];
    [self.contentView addSubview:self.BTNameLabel];
}

-(void)autolayoutViews
{
    [super autolayoutViews];
    
    WS(weakSelf)
    [self.accessoryImageVIew mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@13);
        make.height.equalTo(@11);
        make.centerY.equalTo(weakSelf.mas_centerY).offset(0);
        make.right.equalTo(weakSelf.mas_right).offset(-35);
    }];
    
    [self.BTNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@16);
        make.left.equalTo(@40);
    }];
    [self.BTNameLabel setContentHuggingPriority:UILayoutPriorityRequired
                                     forAxis:UILayoutConstraintAxisHorizontal];
    [self.BTNameLabel setContentHuggingPriority:UILayoutPriorityRequired
                                     forAxis:UILayoutConstraintAxisVertical];
}

-(void)bindData
{
    [super bindData];
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (highlighted)
    {
        self.BGImageView.image = IMAGE(@"cell_select_bg");
    }
    else
    {
        self.BGImageView.image = nil;
    }
}

#pragma mark - set -

-(void)setSelectBt:(BOOL)selectBt
{
    _selectBt = selectBt;
    
    self.accessoryImageVIew.hidden = !selectBt;
}

@end
