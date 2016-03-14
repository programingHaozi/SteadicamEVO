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

typedef void (^TFViewControllerBlock)(id);

@interface TFViewController : UIViewController

@property (nonatomic, strong) id viewModel;
@property (nonatomic, strong) TFViewControllerBlock block;

@property (nonatomic, readonly) NSInteger activeRequestCount;

/**
 *  自定义导航栏
 */
@property (nonatomic, strong) UIView *customNaviBarView;

- (void) addRequest:(id)request;
- (void) removeRequest:(id)request;
- (void) cancelRequests;

#pragma mark - init

- (id)initWithBlock:(TFViewControllerBlock)block;

- (id)initWithViewModel:(id)viewModel;

- (id)initWithViewModel:(id)viewModel block:(TFViewControllerBlock)block;

- (id)initWithData:(NSDictionary*)data;

- (id)initWithData:(NSDictionary*)data block:(TFViewControllerBlock)block;

- (id)initWithViewModel:(id)viewModel nibName:(NSString *)nibName bundle:(NSBundle *)bundle;

#pragma mark- hud loadinfgview toast

/**
 显示和隐藏空态页面
 */
-(void)showEmptyView;
-(void)hideEmptyView;

/**
 显示和隐藏loadingHUD页面
 */
-(void)showLoadingHud;
-(void)showLoadingHudWithText:(NSString*)text;
-(void)hideLoadingHud;

-(void)showLoading;
-(void)showLoadingWithText:(NSString*)text;
-(void)hideLoading;

-(void)startLoadData;
-(void)endLoadData;

/**
 *  显示和隐藏自定义导航栏
 */
-(void)showCustomNaviBar:(UIView*)customNaviBar;
-(void)hideCustomNaviBar;
-(UIView*)findView:(UIView*)aView withName:(NSString*)name;

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
- (void)showToast:(NSString*)text duration:(NSTimeInterval)duration position:(id)position;

#pragma mark - push pop

-(void)pushViewController:(UIViewController *)vc;
-(void)popViewController;

-(void)presentViewController;
-(void)dismissViewController;

-(void)popModuleViewController;

-(void)back;

#pragma mark - button event

/**
 *  导航栏按钮隐藏
 */
-(void)hideBack;
-(void)hideLeft;
-(void)hideRight;

/**
 *  导航栏按钮可点击
 */
-(void)enableLeft;
-(void)enableRight;

/**
 *  导航栏按钮不可点击
 */
-(void)disableLeft;
-(void)disableRight;

#pragma mark - init button

- (void)initMiddleView:(UIView*)view;

-(void)initLeftImage:(NSString *)strImage;
-(void)initLeftImage:(NSString *)strImage selector:(SEL)selector;
-(void)initLeftTitle:(NSString *)strTitle;
-(void)initLeftTitle:(NSString *)strTitle selector:(SEL)selector;
-(void)initLeftTitle:(NSString *)strTitle color:(UIColor *)color;
-(void)initLeftTitle:(NSString *)strTitle color:(UIColor *)color selector:(SEL)selector;
-(void)initLeftImage:(NSString *)strImage title:(NSString *)strTitle color:(UIColor *)color;
-(void)initLeftImage:(NSString *)strImage title:(NSString *)strTitle color:(UIColor *)color selector:(SEL)selector;

-(void)initRightImage:(NSString *)strImage;
-(void)initRightImage:(NSString *)strImage selector:(SEL)selector;
-(void)initRightTitle:(NSString *)strTitle;
-(void)initRightTitle:(NSString *)strTitle selector:(SEL)selector;
-(void)initRightTitle:(NSString *)strTitle color:(UIColor *)color;
-(void)initRightTitle:(NSString *)strTitle color:(UIColor *)color selector:(SEL)selector;
-(void)initRightImage:(NSString *)strImage title:(NSString *)strTitle color:(UIColor *)color;
-(void)initRightImage:(NSString *)strImage title:(NSString *)strTitle color:(UIColor *)color selector:(SEL)selector;

-(void)resetLeftTitle:(NSString*)str;
-(void)resetRightTitle:(NSString*)str;

-(void)initBackButton;

@end
