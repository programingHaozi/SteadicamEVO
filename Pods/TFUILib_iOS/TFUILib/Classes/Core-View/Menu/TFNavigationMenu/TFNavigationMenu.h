//
//  TFNavigationMenu.h
//  TFNavigationMenu
//
//  Created by xiayiyong on 02/08/2015.
//  Copyright (c) 2015 xiayiyong. All rights reserved.
//  from https://github.com/PerfectFreeze/PFNavigationDropdownMenu
//

#import <UIKit/UIKit.h>

typedef void (^TFNavigationMenuBlock)(NSInteger index);

@interface TFNavigationMenu : UIView

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *textFont;
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

@property (nonatomic, copy) TFNavigationMenuBlock didSelectItemAtIndexHandler;

/**
 *  初始化
 *
 *  @param frame frame
 *  @param items 字符串列表
 *
 *  @return
 */
- (instancetype)initWithItems:(NSArray *)items block:(TFNavigationMenuBlock)block;

@end
