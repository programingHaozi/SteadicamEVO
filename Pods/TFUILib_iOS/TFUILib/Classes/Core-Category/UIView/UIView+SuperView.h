//
//  UIView+SuperView.h
//  HBToolkit
//
//  Created by xiayiyong on 15/7/1.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SuperView)

/**
 *  根据类型取父视图
 *
 *  @param superViewClass 父视图类型
 *
 *  @return 父视图
 */
- (UIView *)superViewWithClass:(Class)superViewClass;

@end
