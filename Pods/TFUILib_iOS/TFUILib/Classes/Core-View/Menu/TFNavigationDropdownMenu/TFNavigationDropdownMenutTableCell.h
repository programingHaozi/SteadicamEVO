//
//  TFNavigationDropdownMenutTableCell.h
//  TFNavigationDropdownMenu
//
//  Created by xiayiyong on 02/08/2015.
//  Copyright (c) 2015 xiayiyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFNavigationDropdownMenuConfiguration.h"

@interface TFNavigationDropdownMenutTableCell : UITableViewCell

@property (nonatomic, strong) UIImageView *checkmarkIcon;
@property (nonatomic, assign) CGRect cellContentFrame;
@property (nonatomic, strong) TFNavigationDropdownMenuConfiguration *configuration;

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                configuration:(TFNavigationDropdownMenuConfiguration *)configuration;

@end
