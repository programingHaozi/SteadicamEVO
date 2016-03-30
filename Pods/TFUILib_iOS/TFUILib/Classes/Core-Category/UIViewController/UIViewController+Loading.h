//
//  UIViewController+Loading.h
//  TFUILib
//
//  Created by xiayiyong on 16/3/21.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Loading)

#pragma mark-  loadinfgview

/**
 *  显示Loading
 */
- (void)showLoading;

/**
 *  显示Loading
 *
 *  @param text 提示信息
 */
- (void)showLoadingWithText:(NSString*)text;

/**
 *  隐藏Loading
 */
- (void)hideLoading;

@end
