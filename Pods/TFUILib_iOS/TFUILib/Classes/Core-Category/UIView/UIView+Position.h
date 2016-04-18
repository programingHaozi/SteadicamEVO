//
//  UIView+Position.h
//  StringDemo
//
//  Created by xiayiyong on 15/7/1.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Position)

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

@property(nonatomic) CGPoint topLeft;
@property(nonatomic) CGPoint topRight;
@property(nonatomic) CGPoint bottomLeft;
@property(nonatomic) CGPoint bottomRight;

@property(nonatomic) CGPoint leftTop;
@property(nonatomic) CGPoint leftBottom;
@property(nonatomic) CGPoint rightTop;
@property(nonatomic) CGPoint rightBottom;

/**
 *  屏幕宽度
 */
@property(nonatomic,readonly) CGFloat screenWidth;

/**
 *  屏幕高度
 */
@property(nonatomic,readonly) CGFloat screenHeight;

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

CGPoint CGRecGetTopLeftPoint(CGRect rect);
CGPoint CGRectGetTopRightPoint(CGRect rect);
CGPoint CGRectGetBottomLeftPoint(CGRect rect);
CGPoint CGRectGetBottomRightPoint(CGRect rect);

CGPoint CGRectGetTopCenterPoint(CGRect rect);
CGPoint CGRectGetBottomCenterPoint(CGRect rect);
CGPoint CGRectGetLeftCenterPoint(CGRect rect);
CGPoint CGRectGetRightCenterPoint(CGRect rect);

CGPoint CGRectGetCenter(CGRect rect);


@end
