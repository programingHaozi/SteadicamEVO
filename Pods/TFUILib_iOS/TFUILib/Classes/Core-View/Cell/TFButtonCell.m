//
//  TFButtonCell.m
//  TFUILib
//
//  Created by xiayiyong on 16/3/7.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFButtonCell.h"

@implementation TFButtonCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.font = [UIFont boldSystemFontOfSize:14.0];
    
    self.textLabel.textColor = [UIColor colorWithRed:74/255.0 green:110/255.0 blue:165/255.0 alpha:1.0];
    self.textLabel.highlightedTextColor = [UIColor whiteColor];
    
    return self;
}

- (id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    CGRect r = CGRectInset(self.contentView.bounds , 20, 8);
    self.textLabel.frame = r;
}


@end
