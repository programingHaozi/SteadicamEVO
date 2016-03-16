//
//  LBBasePlugin.h
//  LightBundle
//
//  Created by Hu Dan 胡丹 on 15/11/3.
//  Copyright © 2015年 Ren Wenchao 任文超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LBWebView.h"
#import "KLightBundleDefine.h"
#import "KEnumPublicDefine.h"


@interface LBBasePlugin : NSObject

/**
 *  lb
 */
@property (nonatomic,retain) LBWebView *lb;

/**
 *  viewController
 */
@property (nonatomic,retain) UIViewController *viewController;

/**
 *  js-sdk传过来的参数
 */
@property (nonatomic,retain) NSDictionary *paramers;


#pragma mark - UI显示相关

/**
 *  工程中状态栏的style
 */
@property (nonatomic,assign) UIStatusBarStyle statusBarStyle;

/**
 *  工程中导航栏的背景颜色
 */
@property (nonatomic,retain) UIColor *navBgColor;

/**
 *  工程中window的tintColor
 */
@property (nonatomic,retain) UIColor *windowTintColor;

/**
 *  工程中导航栏的背景image
 */
@property (nonatomic,retain) UIImage *navigationBarBgImage;

/**
 *  工程中导航栏下面的横线image
 */
@property (nonatomic,retain) UIImage *navigationBarShadowImage;

/**
 *  初始化
 *
 *  @param callBackId
 *
 *  @return
 */
- (instancetype)initWithCallBackId:(NSString*)callBackId param:(NSDictionary *)paramers;

/**
 *  调用native功能
 */
- (void)jsCallFunction;

/**
 *  返回js-sdk数据
 *
 *  @param text      返回内容 (类型为NSString、NSDictionary或对象)
 *  @param errorCode 错误码
 *  @param msg       消息
 *
 *  @return          调用js的返回值
 */
- (void)callbackJsSdk:(id)text errorCode:(LBErrorCode)errorCode msg:(NSString *)msg;

/**
 *  取消插件展示
 */
- (void)stopShowing;

/**
 *  提示vc未设置
 */
- (void)alertNoVc;

/**
 *  show alert
 *
 *  @param text text
 */
- (void)showAlert:(NSString *)text;

/**
 *  UIColor转UIImage
 *
 *  @param color color
 *
 *  @return image
 */
- (UIImage *)createImageWithColor:(UIColor *)color;

@end
