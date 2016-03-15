//
//  UIView+SubView.h
//  TFBaseLib
//
//  Created by xiayiyong on 15/10/16.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SubView)

/**
 *  移除所有子视图
 */
- (void)removeAllSubviews;

/**
 *  根据tag获取子视图
 *
 *  @param tag 子视图tag
 *
 *  @return 子视图
 */
- (UIView *)subViewWithTag:(int)tag;

@end
