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
#import "UIViewController+HUD.h"
#import "UIViewController+Loading.h"
#import "UIViewController+Toast.h"
#import "UIViewController+Push.h"
#import "UIViewController+HandleAction.h"

typedef void (^TFViewControllerResultBlock)(id);

@interface TFViewController : UIViewController

/**
 *  控制器的viewModel
 */
@property (nonatomic, strong) TFViewModel *viewModel;

/**
 *  控制器回调
 */
@property (nonatomic, strong) TFViewControllerResultBlock resultBlock;

@property (nonatomic,strong) UINavigationBar* customNavigationBar;
@property (nonatomic,strong) UINavigationItem* customNavigationItem;
@property (nonatomic,assign) BOOL customNavigationBarHidden;
@property (nonatomic,assign) BOOL customNavigationBarTranslucent;

@property (nonatomic,assign) CGFloat top;

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

/**
 *  初始化视图
 */
- (void)initViews;

/**
 *  自动布局视图
 */
- (void)autolayoutViews;

/**
 *  绑定数据
 */
- (void)bindData;

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
 *  显示自定义导航栏
 *
 *  @param customNaviBar 自定义导航栏
 */
-(void)showCustomNaviBar:(UIView*)customNaviBar;

/**
 *  隐藏自定义导航栏
 */
-(void)hideCustomNaviBar;

#pragma mark - init button

/**
 *  初始化标题栏
 *
 *  @param title 标题
 */
-(void)initTitle:(NSString*)title;

/**
 *  初始化标题以及颜色
 *
 *  @param title      标题
 *  @param titleColor 标题颜色
 */
- (void)initTitle:(NSString *)title color:(UIColor *)titleColor;

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
 *  初始化导航栏左侧图片
 *
 *  @param strImage       正常图片
 *  @param highLightImage 高亮图片
 */
- (void)initLeftImage:(NSString *)strImage highLightImage:(NSString *)highLightImage;

/**
 *  初始化导航栏左侧图片以及事件
 *
 *  @param strImage 图片名
 *  @param selector 点击事件
 */
- (void)initLeftImage:(NSString *)strImage selector:(SEL)selector;

/**
 *  初始化导航栏左侧图片以及事件
 *
 *  @param strImage       正常图片
 *  @param highLightImage 高亮图片
 *  @param selector       点击事件
 */
- (void)initLeftImage:(NSString *)strImage highLightImage:(NSString *)highLightImage selector:(SEL)selector;

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
 *  @param strImage       正常图片名
 *  @param highLightImage 高亮图片
 *  @param strTitle       标题
 *  @param color          标题颜色
 */
- (void)initLeftImage:(NSString *)strImage
       highLightImage:(NSString *)highLightImage
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
 *  初始化导航栏左侧
 *
 *  @param strImage       图片名
 *  @param highLightImage 高亮图片
 *  @param strTitle       标题
 *  @param color          标题颜色
 *  @param selector       点击事件
 */
- (void)initLeftImage:(NSString *)strImage
       highLightImage:(NSString *)highLightImage
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
 *  初始化导航栏右侧图片
 *
 *  @param strImage       正常图片
 *  @param highLightImage 高亮图片
 */
- (void)initRightImage:(NSString *)strImage highLightImage:(NSString *)highLightImage;

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
 *  @param strImage       正常图片
 *  @param highLightImage 高亮图片
 *  @param selector       点击事件
 */
- (void)initRightImage:(NSString *)strImage highLightImage:(NSString *)highLightImage selector:(SEL)selector;

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
 *  @param strImage       正常图片
 *  @param highLightImage 高亮图片
 *  @param strTitle       标题
 *  @param color          标题颜色
 */
- (void)initRightImage:(NSString *)strImage
        highLightImage:(NSString *)highLightImage
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
 *  初始化导航栏右侧
 *
 *  @param strImage       正常图片
 *  @param highLightImage 高亮图片
 *  @param strTitle       标题
 *  @param color          标题颜色
 *  @param selector       点击事件
 */
- (void)initRightImage:(NSString *)strImage
        highLightImage:(NSString *)highLightImage
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
 *  显示导航栏左侧按钮
 */
- (void)showLeftButton;

/**
 *  隐藏导航栏右边按钮
 */
- (void)hideRightButton;

/**
 *  显示导航栏右边按钮
 */
- (void)showRightButton;

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
