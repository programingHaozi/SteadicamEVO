//
//  UIViewController+TFHud.h
//  TFUILib
//
//  Created by xiayiyong on 16/3/21.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (TFHud)

#pragma mark- hud

/**
 *  显示HUD页面
 */
- (void)showHUD;

/**
 *  显示HUD页面
 *
 *  @param text 提示信息
 */
- (void)showHUDWithText:(NSString*)text;

/**
 *  隐藏HUD页面
 */
- (void)hideHUD;

@end
