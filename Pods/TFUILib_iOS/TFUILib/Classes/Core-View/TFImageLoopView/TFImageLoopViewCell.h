//
//  TFImageLoopViewCell.h
//  TFImageLoopView
//
//  Created by aier on 15-3-22.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFImageLoopViewCell : UICollectionViewCell

/**
 *  图片框
 */
@property (weak, nonatomic) UIImageView *imageView;

/**
 *  标题
 */
@property (copy, nonatomic) NSString *title;

/**
 *  标题颜色
 */
@property (nonatomic, strong) UIColor *titleLabelTextColor;

/**
 *  标题字体大小
 */
@property (nonatomic, strong) UIFont *titleLabelTextFont;

/**
 *  标题label背景色
 */
@property (nonatomic, strong) UIColor *titleLabelBackgroundColor;

/**
 *  标题label高度
 */
@property (nonatomic, assign) CGFloat titleLabelHeight;

/**
 *  是否配置
 */
@property (nonatomic, assign) BOOL hasConfigured;

@end
