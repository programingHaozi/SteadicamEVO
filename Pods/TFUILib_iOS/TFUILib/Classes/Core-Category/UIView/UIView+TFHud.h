//
//  UIView+TFHud.h
//  TFUILib
//
//  Created by xiayiyong on 16/4/18.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (TFHud)

/**
 *  显示Loading视图
 */
-(void)showHud;

/**
 *  显示Loading视图
 *
 *  @param alertText 提示信息
 */
-(void)showHudWithText:(NSString *)text;

/**
 *  隐藏Loading视图
 */
-(void)hideHud;

@end
