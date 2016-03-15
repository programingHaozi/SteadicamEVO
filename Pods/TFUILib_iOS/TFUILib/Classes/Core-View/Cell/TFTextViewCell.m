//
//  TFTextViewCell.m
//  TFUILib
//
//  Created by xiayiyong on 16/3/7.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFTextViewCell.h"

@implementation TFTextViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(!(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    
    _textView = [[TFTextView alloc] initWithFrame:CGRectZero];
    _textView.font = [UIFont boldSystemFontOfSize:14.0];
    _textView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_textView];
    
    return self;
}

- (id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:reuseIdentifier];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    _textView.frame = CGRectInset(self.contentView.bounds, 4, 4);
}

- (void) _colorText:(BOOL)active
{
    _textView.textColor = active ? [UIColor whiteColor] : [UIColor blackColor];
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

@end
