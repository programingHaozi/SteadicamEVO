//
//  UIViewController+NavigationButton.h
//  TFUILib
//
//  Created by xiayiyong on 16/3/21.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (NavigationButton)

@property (nonatomic, getter=isNavigationBar) BOOL navigationBarHidden;
@property (nonatomic,strong) UINavigationBar* customNavigationBar;

#pragma mark - init button

/**
 *  初始化导航栏中间视图
 *
 *  @param view 视图
 */
- (void)initMiddleView:(UIView*)view;

/**
 *  初始化导航栏左侧图片
 *
 *  @param strImage 图片名
 */
- (void)initLeftImage:(NSString *)strImage;

/**
 *  初始化导航栏左侧图片以及事件
 *
 *  @param strImage 图片名
 *  @param selector 点击事件
 */
- (void)initLeftImage:(NSString *)strImage selector:(SEL)selector;

/**
 *  初始化导航栏左侧标题
 *
 *  @param strTitle 标题
 */
- (void)initLeftTitle:(NSString *)strTitle;

/**
 *  初始化导航栏左侧标题以及事件
 *
 *  @param strTitle 标题
 *  @param selector 点击事件
 */
- (void)initLeftTitle:(NSString *)strTitle selector:(SEL)selector;

/**
 *  初始化导航栏左侧标题
 *
 *  @param strTitle 标题
 *  @param color    标题颜色
 */
- (void)initLeftTitle:(NSString *)strTitle color:(UIColor *)color;

/**
 *  初始化导航栏左侧
 *
 *  @param strTitle 标题
 *  @param color    标题颜色
 *  @param selector 点击事件
 */
- (void)initLeftTitle:(NSString *)strTitle
                color:(UIColor *)color
             selector:(SEL)selector;

/**
 *  初始化导航栏左侧
 *
 *  @param strImage 图片名
 *  @param strTitle 标题
 *  @param color    标题颜色
 */
- (void)initLeftImage:(NSString *)strImage
                title:(NSString *)strTitle
                color:(UIColor *)color;

/**
 *  初始化导航栏左侧
 *
 *  @param strImage 图片名
 *  @param strTitle 标题
 *  @param color    标题颜色
 *  @param selector 点击事件
 */
- (void)initLeftImage:(NSString *)strImage
                title:(NSString *)strTitle
                color:(UIColor *)color
             selector:(SEL)selector;

/**
 *  初始化导航栏右侧
 *
 *  @param strImage 图片名
 */
- (void)initRightImage:(NSString *)strImage;

/**
 *  初始化导航栏右侧
 *
 *  @param strImage 图片名
 *  @param selector 点击事件
 */
- (void)initRightImage:(NSString *)strImage selector:(SEL)selector;

/**
 *  初始化导航栏右侧
 *
 *  @param strTitle 标题
 */
- (void)initRightTitle:(NSString *)strTitle;

/**
 *  初始化导航栏右侧
 *
 *  @param strTitle 标题
 *  @param selector 点击事件
 */
- (void)initRightTitle:(NSString *)strTitle selector:(SEL)selector;

/**
 *  初始化导航栏右侧
 *
 *  @param strTitle 标题
 *  @param color    标题颜色
 */
- (void)initRightTitle:(NSString *)strTitle color:(UIColor *)color;

/**
 *  初始化导航栏右侧
 *
 *  @param strTitle 标题
 *  @param color    标题颜色
 *  @param selector 点击事件
 */
- (void)initRightTitle:(NSString *)strTitle
                 color:(UIColor *)color
              selector:(SEL)selector;

/**
 *  初始化导航栏右侧
 *
 *  @param strImage 图片
 *  @param strTitle 标题
 *  @param color    标题颜色
 */
- (void)initRightImage:(NSString *)strImage
                 title:(NSString *)strTitle
                 color:(UIColor *)color;

/**
 *  初始化导航栏右侧
 *
 *  @param strImage 图片
 *  @param strTitle 标题
 *  @param color    标题颜色
 *  @param selector 点击事件
 */
- (void)initRightImage:(NSString *)strImage
                 title:(NSString *)strTitle
                 color:(UIColor *)color
              selector:(SEL)selector;

/**
 *  重置导航栏左侧标题
 *
 *  @param str 标题
 */
- (void)resetLeftTitle:(NSString*)str;

/**
 *  重置导航栏右侧标题
 *
 *  @param str 标题
 */
- (void)resetRightTitle:(NSString*)str;

/**
 *  初始化返回按钮
 */
- (void)initBackButton;

#pragma mark button event

/**
 *  左侧导航栏按钮事件
 *
 *  @param button
 */
- (void)leftButtonEvent;

/**
 *  右侧导航栏按钮事件
 *
 *  @param button
 */
- (void)rightButtonEvent;

/**
 *  隐藏导航栏左边按钮
 */
- (void)hideLeftButton;

/**
 *  隐藏导航栏右边按钮
 */
- (void)hideRightButton;

/**
 *  导航栏左边按钮可点击
 */
- (void)enableLeftButton;

/**
 *  导航栏右边按钮可点击
 */
- (void)enableRightButton;

/**
 *  导航栏左边按钮不可点击
 */
- (void)disableLeftButton;

/**
 *  导航栏右边按钮不可点击
 */
- (void)disableRightButton;

@end
