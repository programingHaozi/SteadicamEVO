//
//  TFTableViewCell.m
//  TFUILib
//
//  Created by xiayiyong on 16/1/12.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFTableViewCell.h"

@implementation TFTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+(CGFloat)cellHeightWithData:(id)model width:(CGFloat)width
{
    return 0;
}

- (void)updateCellForData:(id)data {
    
    // 子类实现
    self.updateData = data;
}

-(CGFloat)cellHeight
{
    return 60;
}

+(CGFloat)cellHeight
{
    return 60;
}
@end
