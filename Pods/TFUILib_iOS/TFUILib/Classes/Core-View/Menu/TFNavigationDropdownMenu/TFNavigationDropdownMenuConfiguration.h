//
//  TFNavigationDropdownMenuConfiguration.h
//  TFNavigationDropdownMenu
//
//  Created by xiayiyong on 02/08/2015.
//  Copyright (c) 2015 xiayiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFNavigationDropdownMenuConfiguration : NSObject
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) UIColor *cellBackgroundColor;
@property (nonatomic, strong) UIColor *cellTextColor;
@property (nonatomic, strong) UIFont *cellTextFont;
@property (nonatomic, strong) UIColor *cellSelectedColor;
@property (nonatomic, strong) UIImage *checkImage;
@property (nonatomic, strong) UIImage *arrowImage;
@property (nonatomic, assign) CGFloat arrowPadding;
@property (nonatomic, assign) NSTimeInterval animationDuration;
@property (nonatomic, strong) UIColor *maskBackgroundColor;
@property (nonatomic, assign) CGFloat maskBackgroundOpacity;
@end
