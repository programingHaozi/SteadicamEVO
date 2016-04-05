//
//  TFWebViewController.h
//  Treasure
//
//  Created by xiayiyong on 15/9/9.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFViewController.h"
#import "TFWebView.h"
#import "TFWebModel.h"
#import "Masonry.h"
#import "TFWebView.h"
#import "TFProgressView.h"

@interface TFWebViewController : TFViewController<LBWebViewDelegate>

/**
 *  Progress
 *
 *  @param URL            请求的地址
 *  @param needBack       是否需要返回
 *  @param isNeedClose    是否需要关闭
 *  @param title          标题
 *  @param requestBlock   requestBlock
 *  @param didStarBlock   didStarBlock
 *  @param didFinishBlock didFinishBlock
 *  @param didFailBlock   didFailBlock
 *
 *  @return 返回的webVC
 */
- (instancetype)initWithURL:(NSString *)URL
        isNeedMulilayerBack:(BOOL)needBack
                isNeedClose:(BOOL)isNeedClose
                      title:(NSString *)title
 shouldStartLoadWithRequest:(void(^)(NSURLRequest *request))requestBlock
               didStartLoad:(void(^)())didStarBlock
              DidFinishLoad:(void(^)())didFinishBlock
                didFailLoad:(void(^)(NSError *error))didFailBlock;

/**
 *  webView的回调
 *
 *  @param requestBlock   requestBlock
 *  @param didStarBlock   didStarBlock
 *  @param didFinishBlock didFinishBlock
 *  @param didFailBlock   didFailBlock
 */
- (void)shouldStartLoadWithRequest:(void(^)(NSURLRequest *request))requestBlock
                      didStartLoad:(void(^)())didStarBlock
                     didFinishLoad:(void(^)())didFinishBlock
                       didFailLoad:(void(^)(NSError *error))didFailBlock;


/**
 *  设置关闭按钮的颜色
 *
 *  @param strImage 图片
 *  @param strTitle 标题
 *  @param color    颜色
 */
- (void)initCloseButtonImage:(NSString *)strImage
                       title:(NSString *)strTitle
                       color:(UIColor *)color;

#pragma mark - 功能开关

/**
 *  webModel
 */
@property (nonatomic, strong) TFWebModel *model;

/**
 *  是否需要关闭按钮
 */
@property (nonatomic, assign) BOOL isNeedClose;

/**
 *  是否需要多层返回
 */
@property (nonatomic, assign) BOOL isNeedMulilayerBack;

/**
 *  是否需要显示进度条默认不显示
 */
@property (nonatomic, assign) BOOL isNeedProgressView;


#pragma mark - 参数配置

/**
 *  加载url链接
 */
@property (nonatomic, strong) NSURLRequest *urlRequest;

/**
 *  固定标题
 */
@property (nonatomic, strong) NSString *fixedTitle;

/**
 *  UA的参数
 */
@property (nonatomic, strong) NSDictionary *uaDicton;

/**
 *  第一次加载未加载完成显示的标题
 */
@property (nonatomic, strong) NSString *placeholderTitle;

#pragma mark - 成员变量

/**
 *  进度条
 */
@property (nonatomic, strong) TFProgressView* progressView;

/**
 *  进度条颜色
 */
@property (nonatomic, strong) UIColor *progressViewColor;


/**
 *  LBWebView
 */
@property (nonatomic, strong) TFWebView *webView;

#pragma mark -  外部函数

/**
 *  加载url
 */
- (void)loadUrl;

@end
