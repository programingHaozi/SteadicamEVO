//
//  TFTableViewCell.m
//  TFUILib
//
//  Created by xiayiyong on 16/1/12.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFTableViewCell.h"

@implementation TFTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
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

- (void)bindData
{
    
}

-(CGFloat)cellHeight
{
    return 44;
}

+(CGFloat)cellHeightWithData:(id)model width:(CGFloat)width
{
    return 0;
}

+(CGFloat)cellHeight
{
    return 44;
}

+(NSString*)reusableIdentifier
{
    return NSStringFromClass([self class]);
}

@end
