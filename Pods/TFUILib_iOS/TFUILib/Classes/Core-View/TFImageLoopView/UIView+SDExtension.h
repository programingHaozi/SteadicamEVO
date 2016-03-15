//
//  UIView+SDExtension.h
//  SDRefreshView
//
//  Created by aier on 15-2-23.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SDColorCreater(r, g, b, a) [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:a]

@interface UIView (SDExtension)

/**
 *  高度
 */
@property (nonatomic, assign) CGFloat sd_height;

/**
 *  宽度
 */
@property (nonatomic, assign) CGFloat sd_width;

/**
 *  y轴便宜
 */
@property (nonatomic, assign) CGFloat sd_y;

/**
 *  x轴便宜
 */
@property (nonatomic, assign) CGFloat sd_x;

@end
