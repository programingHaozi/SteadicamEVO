//
//  TFViewController.h
//  Treasure
//
//  Created by xiayiyong on 15/9/7.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJExtension.h"
#import "Masonry.h"
#import "TFViewModel.h"
#import "TFActionModel.h"
#import "TFWebModel.h"

typedef void (^TFViewControllerResultBlock)(id);

@interface TFViewController : UIViewController

/**
 *  控制器的viewModel
 */
@property (nonatomic, strong) TFViewModel *viewModel;

/**
 *  控制器回调
 */
@property (nonatomic, strong) TFViewControllerResultBlock block;

/**
 *  自定义导航栏
 */
@property (nonatomic, strong) UIView *customNaviBarView;

#pragma mark - init

/**
 *  初始化控制器
 *
 *  @param block 控制器回调
 *
 *  @return 控制器
 */
- (id)initWithResultBlock:(TFViewControllerResultBlock)block;

/**
 *  初始化控制器
 *
 *  @param viewModel 控制器viewModel
 *
 *  @return 控制器
 */
- (id)initWithViewModel:(id)viewModel;

/**
 *  初始化控制器
 *
 *  @param viewModel 控制器viewModel
 *  @param block     控制器回调
 *
 *  @return 控制器
 */
- (id)initWithViewModel:(id)viewModel resultBlock:(TFViewControllerResultBlock)block;

/**
 *  初始化控制器
 *
 *  @param data 数据
 *
 *  @return 控制器
 */
- (id)initWithData:(NSDictionary*)data;

/**
 *  初始化控制器
 *
 *  @param data  数据
 *  @param block 控制器回调
 *
 *  @return 控制器
 */
- (id)initWithData:(NSDictionary*)data resultBlock:(TFViewControllerResultBlock)block;

/**
 *  初始化控制器
 *
 *  @param viewModel 控制器viewModel
 *  @param nibName   nib名称
 *  @param bundle    NSBundle
 *
 *  @return 控制器
 */
- (id)initWithViewModel:(id)viewModel
                nibName:(NSString *)nibName
                 bundle:(NSBundle *)bundle;

#pragma mark- showNavigationBar

- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated;

- (void)showNavigationBar;

- (void)hideNavigationBar;

/**
 *  显示自定义导航栏
 */
- (void)showCustomNaviBar:(UIView*)customNaviBar;

/**
 *  隐藏自定义导航栏
 */
- (void)hideCustomNaviBar;

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

#pragma mark-  load data

/**
 *  开始载入数据
 */
- (void)startLoadData;

/**
 *  停止载入数据
 */
- (void)endLoadData;

/**
 *  获取视图
 *
 *  @param aView 视图
 *  @param name  视图名称
 *
 *  @return 视图
 */
- (UIView*)findView:(UIView*)aView withName:(NSString*)name;

#pragma mark - push pop

/**
 *  push方法
 *
 *  @param vc 控制器
 */
- (void)pushViewController:(UIViewController *)vc;

/**
 *  pop方法
 */
- (void)popViewController;

/**
 *  弹出模态视图
 */
- (void)presentViewController;

/**
 *  隐藏模态视图
 */
- (void)dismissViewController;

/**
 *  pop模块控制器
 */
- (void)popModuleViewController;

/**
 *  返回方法
 */
- (void)back;


#pragma mark button event

- (void)leftEvent:(UIButton*)button;

- (void)rightEvent:(UIButton*)button;

/**
 *  导航栏按钮隐藏
 */
- (void)hideBack;

/**
 *  隐藏导航栏左边按钮
 */
- (void)hideLeft;

/**
 *  隐藏导航栏右边按钮
 */
- (void)hideRight;

/**
 *  导航栏左边按钮可点击
 */
- (void)enableLeft;

/**
 *  导航栏右边按钮可点击
 */
- (void)enableRight;

/**
 *  导航栏左边按钮不可点击
 */
- (void)disableLeft;

/**
 *  导航栏右边按钮不可点击
 */
- (void)disableRight;

#pragma mark- handle

-(void) handleData:(id)data;

#pragma mark event

/**
 *  左导航按钮的时间
 *
 *  @param button
 */
- (void)leftEvent:(UIButton*)button;

/**
 *  右导航按钮的事件
 *
 *  @param button 
 */
- (void)rightEvent:(UIButton*)button;

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

@end
