//
//  UIViewController+HUD.h
//  TFUILib
//
//  Created by xiayiyong on 16/3/21.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HUD)

#pragma mark- hud

/**
 *  显示loadingHUD页面
 */
- (void)showLoadingHud;

/**
 *  显示loadingHUD页面
 *
 *  @param text 提示信息
 */
- (void)showLoadingHudWithText:(NSString*)text;

/**
 *  隐藏loadingHUD页面
 */
- (void)hideLoadingHud;

@end
