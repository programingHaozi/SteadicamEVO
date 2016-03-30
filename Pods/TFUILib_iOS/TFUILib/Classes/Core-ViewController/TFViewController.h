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
#import "UIViewController+NavigationButton.h"
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

#pragma mark- showNavigationBar

- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated;

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

@end
