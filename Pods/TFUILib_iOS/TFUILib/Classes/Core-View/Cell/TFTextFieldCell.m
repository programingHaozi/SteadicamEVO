//
//  TFTextFieldCell.m
//  TFUILib
//
//  Created by xiayiyong on 16/3/7.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFTextFieldCell.h"

@implementation TFTextFieldCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(!(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    
    _textField = [[TFTextField alloc] initWithFrame:CGRectZero];
    _textField.font = [UIFont boldSystemFontOfSize:14.0];
    _textField.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_textField];
    
    return self;
}

- (id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    _textField.frame = CGRectInset(self.contentView.bounds, 4, 4);
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [self _colorText:selected];
}

- (void) setHighlighted:(BOOL)highlight animated:(BOOL)animated
{
    [super setHighlighted:highlight animated:animated];
    [self _colorText:highlight];
}

#pragma mark- private method

- (void) _colorText:(BOOL)active
{
    _textField.textColor = active ? [UIColor whiteColor] : [UIColor blackColor];
}

@end
