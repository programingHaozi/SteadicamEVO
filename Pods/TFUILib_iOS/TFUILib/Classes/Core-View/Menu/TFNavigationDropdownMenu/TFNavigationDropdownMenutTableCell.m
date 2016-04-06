//
//  TFNavigationDropdownMenutTableCell.m
//  TFNavigationDropdownMenu
//
//  Created by xiayiyong on 02/08/2015.
//  Copyright (c) 2015 xiayiyong. All rights reserved.
//

#import "TFNavigationDropdownMenutTableCell.h"
#import "TFNavigationDropdownMenutTableCellContentView.h"

@implementation TFNavigationDropdownMenutTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                configuration:(TFNavigationDropdownMenuConfiguration *)configuration
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.configuration = configuration;
        
        // Setup cell
        self.cellContentFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.configuration.cellHeight);
        self.contentView.backgroundColor = self.configuration.cellBackgroundColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        self.textLabel.textColor = self.configuration.cellTextColor;
        self.textLabel.font = self.configuration.cellTextFont;
        self.textLabel.frame = CGRectMake(20, 0, self.cellContentFrame.size.width, self.cellContentFrame.size.height);
        
        // Checkmark icon
        self.checkmarkIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.cellContentFrame.size.width - 50, (self.cellContentFrame.size.height - 30)/2, 30, 30)];
        self.checkmarkIcon.hidden = YES;
        self.checkmarkIcon.image = self.configuration.checkImage;
        self.checkmarkIcon.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.checkmarkIcon];
        
        // Separator for cell
        TFNavigationDropdownMenutTableCellContentView *separator = [[TFNavigationDropdownMenutTableCellContentView alloc] initWithFrame:self.cellContentFrame];
        separator.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:separator];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.bounds = self.cellContentFrame;
    self.contentView.frame = self.bounds;
}

@end
