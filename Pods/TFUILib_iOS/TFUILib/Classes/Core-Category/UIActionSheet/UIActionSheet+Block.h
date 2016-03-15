//
//  UIActionSheet+Block.h
//  UIActionSheet+Block
//
//  Created by xiayiyong on 16/1/28.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIActionSheet (Block)

/**
 *  显示UIActionSheet
 *
 *  @param title                  视图标题
 *  @param cancelButtonTitle      取消按钮标题
 *  @param destructiveButtonTitle 特殊标记按钮标题
 *  @param otherButtonTitles      其他按钮标题
 *  @param block                  按钮点击事件block
 */
+ (void) showWithTitle:(NSString *)title
     cancelButtonTitle:(NSString *)cancelButtonTitle
destructiveButtonTitle:(NSString *)destructiveButtonTitle
     otherButtonTitles:(NSArray *)otherButtonTitles
                 block:(void (^)(UIActionSheet *, NSInteger))block;

/**
 *  初始化UIActionSheet
 *
 *  @param title                  视图标题
 *  @param cancelButtonTitle      取消按钮标题
 *  @param destructiveButtonTitle 特殊标记按钮标题
 *  @param otherButtonTitles      其他按钮标题
 *  @param block                  按钮点击事件block
 *
 *  @return UIActionSheet实例
 */
+ (instancetype)sheetWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
                        block:(void (^)(UIActionSheet *, NSInteger))block;

- (void)show;

@end
