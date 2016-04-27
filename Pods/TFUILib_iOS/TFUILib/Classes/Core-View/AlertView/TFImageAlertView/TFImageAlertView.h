//
//  TFImageAlertView.h
//  Treasure
//
//  Created by xiayiyong on 16/1/21.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFView.h"

/**
 *  TFImageAlertView按钮点击回调
 *
 *  @param index 按钮Index
 */
typedef void (^TFImageAlertViewBlock)(NSInteger index);

/**
 *  TFImageAlertView
 */
@interface TFImageAlertView : TFView

/**
 *  显示带messageAlertView
 *
 *  @param title        标题
 *  @param message      信息
 *  @param buttonTitles 按钮数组
 *  @param block        点击回调
 */
+ (void)showWithTitle:(NSString*)title
              message:(NSString*)message
    cancelButtonTitle:(NSString *)cancelButtonTitle
    otherButtonTitles:(NSArray *)otherButtonTitles
                block:(TFImageAlertViewBlock)block;

/**
 *  显示带messageAlertView
 *
 *  @param title        标题
 *  @param message      信息
 *  @param buttonTitles 按钮数组
 *  @param block        点击回调
 */
+ (void)showWithTitle:(NSString*)title
              message:(NSString*)message
    buttonTitles:(NSArray *)buttonTitles
                block:(TFImageAlertViewBlock)block;

/**
 *  显示带imageAlertView
 *
 *  @param title        标题
 *  @param image        图片
 *  @param buttonTitles 按钮数组
 *  @param block        点击回调
 */
+ (void)showWithTitle:(NSString*)title
              image:(NSString*)image
    cancelButtonTitle:(NSString *)cancelButtonTitle
    otherButtonTitles:(NSArray *)otherButtonTitles
                block:(TFImageAlertViewBlock)block;

/**
 *  显示带imageAlertView
 *
 *  @param title        标题
 *  @param image        图片
 *  @param buttonTitles 按钮数组
 *  @param block        点击回调
 */
+ (void)showWithTitle:(NSString*)title
                image:(NSString*)image
    buttonTitles:(NSArray *)buttonTitles
                block:(TFImageAlertViewBlock)block;

@end
