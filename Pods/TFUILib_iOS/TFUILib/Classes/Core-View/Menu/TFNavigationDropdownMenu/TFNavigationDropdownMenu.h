//
//  TFNavigationDropdownMenu.h
//  TFNavigationDropdownMenu
//
//  Created by xiayiyong on 02/08/2015.
//  Copyright (c) 2015 xiayiyong. All rights reserved.
//  from https://github.com/PerfectFreeze/PFNavigationDropdownMenu
//

#import <UIKit/UIKit.h>

@interface TFNavigationDropdownMenu : UIView

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) UIColor *cellBackgroundColor;
@property (nonatomic, strong) UIColor *cellTextLabelColor;
@property (nonatomic, strong) UIFont *cellTextLabelFont;
@property (nonatomic, strong) UIColor *cellSelectionColor;
@property (nonatomic, strong) UIImage *checkMarkImage;
@property (nonatomic, strong) UIImage *arrowImage;
@property (nonatomic, assign) CGFloat arrowPadding;
@property (nonatomic, assign) NSTimeInterval animationDuration;
@property (nonatomic, strong) UIColor *maskBackgroundColor;
@property (nonatomic, assign) CGFloat maskBackgroundOpacity;
@property (nonatomic, copy) void(^didSelectItemAtIndexHandler)(NSUInteger indexPath);

- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString *)title
                        items:(NSArray *)items
                containerView:(UIView *)containerView;
@end
