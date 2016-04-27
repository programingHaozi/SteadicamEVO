//
//  UIAlertView+Block.h
//  UIAlertView+Block
//
//  Created by xiayiyong on 16/1/28.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Block)

/**
 *  显示UIAlertView
 *
 *  @param title        视图标题
 *  @param message      提示信息
 *  @param buttonTitles 按钮标题数组
 *  @param block        按钮点击事件block
 */
+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
    cancelButtonTitle:(NSString *)cancelButtonTitle
    otherButtonTitles:(NSArray *)otherButtonTitles
                block:(void (^)(NSInteger buttonIndex))block;

/**
 *  显示UIAlertView
 *
 *  @param title        视图标题
 *  @param message      提示信息
 *  @param buttonTitles 按钮标题数组
 *  @param block        按钮点击事件block
 */
+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
    buttonTitles:(NSArray *)buttonTitles
                block:(void (^)(NSInteger buttonIndex))block;



@end
