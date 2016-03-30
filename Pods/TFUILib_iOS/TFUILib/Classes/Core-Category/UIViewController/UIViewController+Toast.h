//
//  UIViewController+Toast.h
//  TFUILib
//
//  Created by xiayiyong on 16/3/21.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Toast)

#pragma mark-  toast

/**
 *  在顶部显示一个Toast，持续2秒
 *
 *  @param text 要显示的文字
 */
- (void)showToast:(NSString*)text;

/**
 *  显示一个Toast
 *
 *  @param text     要显示的文字
 *  @param duration 显示时长(秒)
 *  @param position 位置(TFToastPositionTop/TFToastPositionCenter/TFToastPositionBottom)
 */
- (void)showToast:(NSString*)text
         duration:(NSTimeInterval)duration
         position:(id)position;

@end
