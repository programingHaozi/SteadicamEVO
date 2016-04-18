//
//  UIViewController+TFToast.h
//  TFUILib
//
//  Created by xiayiyong on 16/3/21.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (TFToast)

#pragma mark-  toast

/**
 *  在顶部显示一个Toast，持续2.5秒
 *
 *  @param text 要显示的文字
 */
- (void)showToast:(NSString*)text;

/**
 *   在顶部显示一个Toast，持续2.5秒
 *
 *  @param text text
 */
- (void)showToastWithText:(NSString*)text;

@end
