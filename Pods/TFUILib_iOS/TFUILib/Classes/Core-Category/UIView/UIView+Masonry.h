//
//  UIView+Masonry.h
//  Treasure
//
//  Created by xiayiyong on 15/9/9.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Masonry)

/**
 *  视图添加约束，使之和父控件一样大
 *
 *  @param insets insets
 */
-(void)masViewEqualToSuperViewWithInsets:(UIEdgeInsets)insets;

//居中显示
+ (void)centerView:(UIView *)view size:(CGSize)size;


//含有边距
+ (void)view:(UIView *)view EdgeInset:(UIEdgeInsets)edgeInsets;


//view的数目大于两个
+ (void)equalSpacingView:(NSArray *)views
               viewWidth:(CGFloat)width
              viewHeight:(CGFloat)height
          superViewWidth:(CGFloat)superViewWidth;

@end
