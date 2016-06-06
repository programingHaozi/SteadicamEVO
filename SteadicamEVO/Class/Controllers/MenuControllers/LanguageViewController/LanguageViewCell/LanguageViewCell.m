//
//  LanguageViewCell.m
//  SteadicamEVO
//
//  Created by Chen Hao 陈浩 on 16/4/6.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import "LanguageViewCell.h"

@implementation LanguageViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {

    }
    
    return self;
}

- (void)initViews
{
    [super initViews];
    
    self.accessoryImageVIew.image = IMAGE(@"Language_select");
}

- (void)autolayoutViews
{
    [super autolayoutViews];
}

- (void)bindData
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

-(void)setSelectLanguage:(BOOL)selectLanguage
{
    _selectLanguage = selectLanguage;
    
    self.accessoryImageVIew.hidden = !selectLanguage;
}

@end
