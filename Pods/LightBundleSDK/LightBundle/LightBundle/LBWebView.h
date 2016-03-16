//
//  LBwebview.h
//
//  Created by Ren Wenchao 任文超 on 15/9/23.
//  Copyright © 2015年 Ren Wenchao 任文超. All rights reserved..
//

#import <UIKit/UIKit.h>

#import "KEnumPublicDefine.h"
#import "KMessagePublicDefine.h"
#import "LBUrlParamModel.h"
#import "LBUserInfoModel.h"
#import "LBAppInfoModel.h"

@protocol LBWebViewDelegate;

@interface LBWebView : UIView

/**
 *  LBWebView代理
 */
@property (nonatomic, assign) id<LBWebViewDelegate> delegate;

/**
 *  使用UIWebView、WKWebView的标记位
 */
@property (nonatomic, assign, readonly) BOOL isUIWebView;

/**
 *  是否可以回退
 */
@property (nonatomic, readonly) BOOL canGoBack;

/**
 *  是否可以前进
 */
@property (nonatomic, readonly) BOOL canGoForward;

/**
 *  当前加载的url
 */
@property (nonatomic, strong) NSString *curUrl;

/**
 *  加载错误时加载的view
 */
@property (nonatomic, strong) UIView *errorView;

/**
 *  webView 根据系统版本自动选择UIWebView或WKWebView(8.0之前使用UIWebView 8.0之后使用WKWebView)
 */
@property (nonatomic, strong) UIView *webView;

/**
 *  通过frame初始化
 *
 *  @param frame
 *
 *  @return
 */
- (id)initWithFrame:(CGRect)frame;

/**
 *  加载url链接
 *
 *  @param url
 */
- (void)loadUrl:(NSURLRequest *)urlRequest;

/**
 *  加载url链接
 *
 *  @param urlStr   url链接
 *  @param urlParam 参数(uid,userId,token,城市名,经度,纬度)
 */
- (void)loadUrlWithParam:(NSURLRequest *)urlRequest urlParam:(LBUrlParamModel *)urlParam;

/**
 *  加载html
 *
 *  @param string  html
 *  @param baseURL base url
 */
- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL;

/**
 *  运行js字符串
 *
 *  @param javaScriptString  js字符串
 *  @param completionHandler 回调
 *
 */
- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id ret, NSError *error))completionHandler;

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
 *  webview常用方法
 */
- (void)goBack;
- (void)goForward;
- (void)reload;
- (void)stopLoading;

@end

@protocol LBWebViewDelegate <NSObject>
@optional

/**
 *  获取UIViewController实例 - 用于弹出选择照片和扫二维码
 *
 *  @return
 */
- (UIViewController *)LBGetVc;

/**
 *  调用业务功能
 *
 *  @param lbFuncType 业务功能类型
 */
- (void)LBJsCallOcFunc:(LBJsCallOcFuncType) lbFuncType param:(NSDictionary *) param;

/**
 *  将要加载请求
 *
 *  @param webView
 *  @param request
 *  @param navigationType
 *
 *  @return
 */
- (BOOL)LBWebView:(LBWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

/**
 *  开始加载请求
 *
 *  @param webView
 */
- (void)LBWebViewDidStartLoad:(LBWebView *)webView;

/**
 *  结束加载
 *
 *  @param webView
 */
- (void)LBWebViewDidFinishLoad:(LBWebView *)webView;

/**
 *  加载失败
 *
 *  @param webView
 *  @param error
 */
- (void)LBWebView:(LBWebView *)webView didFailLoadWithError:(NSError *)error;

/**
 *  加载进度
 *
 *  @param progress 加载进度
 */
- (void)LBLoadingProgress:(float)progress;

@end
