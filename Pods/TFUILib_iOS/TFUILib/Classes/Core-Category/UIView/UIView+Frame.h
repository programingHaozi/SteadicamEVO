//
//  UIView+Frame.h
//  StringDemo
//
//  Created by xiayiyong on 15/7/1.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

/**
 *  左边距
 */
@property(nonatomic) CGFloat left;

/**
 *  右边距
 */
@property(nonatomic) CGFloat right;

/**
 *  上边距
 */
@property(nonatomic) CGFloat top;

/**
 *  底边距
 */
@property(nonatomic) CGFloat bottom;

/**
 *  宽度
 */
@property(nonatomic) CGFloat width;

/**
 *  长度
 */
@property(nonatomic) CGFloat height;

/**
 *  中点X坐标
 */
@property(nonatomic) CGFloat centerX;

/**
 *  中点Y坐标
 */
@property(nonatomic) CGFloat centerY;

/**
 *  起点坐标
 */
@property(nonatomic) CGPoint origin;

/**
 *  尺寸大小
 */
@property(nonatomic) CGSize size;

/**
 *  圆角
 */
@property (nonatomic) CGFloat cornerRadius;

/**
 *  边框宽度
 */
@property (nonatomic) CGFloat borderWidth;

/**
 *  边框颜色
 */
@property (nonatomic, strong) UIColor *borderColor;

/**
 *  阴影颜色
 */
@property (nonatomic, strong) UIColor *shadowColor;

@end
