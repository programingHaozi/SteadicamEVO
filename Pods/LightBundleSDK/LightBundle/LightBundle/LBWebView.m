//
//  LBwebview.m
//
//  Created by Ren Wenchao 任文超 on 15/9/23.
//  Copyright © 2015年 Ren Wenchao 任文超. All rights reserved.
//

#import <objc/runtime.h>
#import <WebKit/WebKit.h>
#import <Foundation/Foundation.h>

#import "KLightBundleDefine.h"
#import "KPluginDefine.h"
#import "LBAESCrypt.h"
#import "LBNJKWebViewProgress.h"
#import "LBWebview.h"

#import "LBRIButtonItem.h"
#import "LBUIAlertView+Blocks.h"
#import "LBZXingObjC.h"

#define kSCHEME @"lb://"   // scheme字串

@interface LBWebView() <UIWebViewDelegate,
                        WKUIDelegate,
                        WKNavigationDelegate,
                        WKScriptMessageHandler,
                        UINavigationControllerDelegate,
                        NJKWebViewProgressDelegate>
{
    
}

// 进度条
@property (nonatomic, strong) LBBasePlugin *lbBasePlugin;
@property (nonatomic, strong) LBNJKWebViewProgress* lbNJKWebViewProgress;
// callbakid
@property (nonatomic, strong)NSString *callbackIdStr;

@end

@implementation LBWebView

#pragma mark - 外部方法

/**
 *  通过frame初始化
 *
 *  @param frame frame
 *
 *  @return
 */
- (id)initWithFrame:(CGRect)frame;
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubview:self.webView];
        [self addSubview:self.errorView];
    }
    return self;
}

/**
 *  加载url链接
 *
 *  @param url url 链接
 */
- (void)loadUrl:(NSURLRequest *)urlRequest;
{
    if (urlRequest.URL.absoluteString.length > 0)
    {
        NSString *newUrl = urlRequest.URL.absoluteString;
        newUrl = [newUrl stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        NSURLRequest *newRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:newUrl] cachePolicy:urlRequest.cachePolicy timeoutInterval:urlRequest.timeoutInterval];
        
        LBLog(@"加载url链接:%@", newRequest.URL.absoluteString);
        self.curUrl = newUrl;
        
        if (self.isUIWebView)
        {
            [(UIWebView*)self.webView loadRequest:newRequest];
        }
        else
        {
            [(WKWebView*)self.webView loadRequest:newRequest];
        }
    }
    else
    {
        LBLog(@"加载url失败:%@", urlRequest.URL.absoluteString);
    }
}

/**
 *  加载url链接
 *
 *  @param urlStr   url链接
 *  @param urlParam 参数(uid,userId,token,城市名,经度,纬度)
 */
- (void)loadUrlWithParam:(NSURLRequest *)urlRequest urlParam:(LBUrlParamModel *)urlParam
{
    NSString *url = urlRequest.URL.absoluteString;
    NSString *uid = urlParam.uid;
    NSString *token = urlParam.userToken;
    NSString *userId = urlParam.userId;
    NSString *locCity = urlParam.locCity;
    NSString *locLong = urlParam.locLong;
    NSString *locLat = urlParam.locLat;
    
    if (!uid || 0 == uid.length || [uid isEqualToString:@"0"])
    {
        uid = @"";
    }
    if (!userId || 0 == userId.length)
    {
        userId = @"";
    }
    if (!token || 0 == token.length)
    {
        token = @"";
    }
    if (!locCity || 0 == locCity.length)
    {
        locCity = @"上海";
    }
    if (!locLong || 0 == locLong.length)
    {
        locLong = @"0.000000";
    }
    if (!locLat || 0 == locLat.length)
    {
        locLat = @"0.000000";
    }
    
    BOOL hasUid = NO;
    BOOL hasUserId = NO;
    BOOL hasToken = NO;
    BOOL hasCity = NO;
    BOOL hasLong = NO;
    BOOL hasLat = NO;
    
    if ([url rangeOfString:@"uid="].length)
    {
        hasUid = YES;
    }
    if ([url rangeOfString:@"userId="].length)
    {
        hasUserId = YES;
    }
    if ([url rangeOfString:@"userToken="].length)
    {
        hasToken = YES;
    }
    if ([url rangeOfString:@"cityName="].length)
    {
        hasCity = YES;
    }
    if ([url rangeOfString:@"longitude="].length)
    {
        hasLong = YES;
    }
    if ([url rangeOfString:@"latitude="].length)
    {
        hasLat = YES;
    }
    
    // 参数拼接
    if (![url rangeOfString:@"?"].length)
    {
        url = [[NSString stringWithFormat:@"%@?uid=%@&userId=%@&userToken=%@&cityName=%@&longitude=%@&latitude=%@", urlRequest.URL.absoluteString, [LBAESCrypt aes256Encrypt:[NSString stringWithFormat:@"%@", uid]], uid, token, locCity, locLong, locLat] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    else
    {
        if (!hasUid)
        {
            url = [NSString stringWithFormat:@"%@&uid=%@", url, [LBAESCrypt aes256Encrypt:[NSString stringWithFormat:@"%@", uid]]];
        }
        
        if (!hasUserId)
        {
            url = [NSString stringWithFormat:@"%@&userId=%@", url, [NSString stringWithFormat:@"%@", uid]];
        }
        
        if (!hasToken)
        {
            url = [NSString stringWithFormat:@"%@&userToken=%@", url, token];
        }
        
        if (!hasCity)
        {
            url = [NSString stringWithFormat:@"%@&cityName=%@", url, locCity];
        }
        
        if (!hasLong)
        {
            url = [NSString stringWithFormat:@"%@&longitude=%@", url, locLong];
        }
        
        if (!hasLat)
        {
            url = [NSString stringWithFormat:@"%@&latitude=%@", url, locLat];
        }
        
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }

    [self loadUrl:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:urlRequest.cachePolicy timeoutInterval:urlRequest.timeoutInterval]];
}

/**
 *  加载html
 *
 *  @param string  html
 *  @param baseURL base url
 */
- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL
{
    if (self.isUIWebView)
    {
        [(UIWebView*)self.webView loadHTMLString:string baseURL:baseURL];
    }
    else
    {
        [(WKWebView*)self.webView loadHTMLString:string baseURL:baseURL];
    }
}

/**
 *  运行js字符串
 *
 *  @param javaScriptString  json字符串
 *  @param completionHandler 回调
 */
- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id, NSError *))completionHandler
{
    if (self.isUIWebView)
    {
        NSString* result = [(UIWebView*)self.webView stringByEvaluatingJavaScriptFromString:javaScriptString];
        if (completionHandler)
        {
            completionHandler(result,nil);
        }
    }
    else
    {
        return [(WKWebView*)self.webView evaluateJavaScript:javaScriptString completionHandler:completionHandler];
    }
}

/**
 *  返回js-sdk数据
 *
 *  @param text      返回内容 (类型为NSString、NSDictionary或对象)
 *  @param errorCode 错误码
 *  @param msg       消息
 *
 *  @return          调用js的返回值
 */
- (void)callbackJsSdk:(id)text errorCode:(LBErrorCode)errorCode msg:(NSString *)msg
{
    [_lbBasePlugin callbackJsSdk:text errorCode:errorCode msg:msg];
}

/**
 *  webview常用方法
 */
- (void)goBack
{
    if (self.isUIWebView)
    {
        [(UIWebView*)self.webView goBack];
    }
    else
    {
        [(WKWebView*)self.webView goBack];
    }
}

- (void)goForward
{
    if (self.isUIWebView)
    {
        [(UIWebView*)self.webView goForward];
    }
    else
    {
        [(WKWebView*)self.webView goForward];
    }
}

- (void)reload
{
    if (self.isUIWebView)
    {
        [(UIWebView*)self.webView reload];
    }
    else
    {
        [(WKWebView*)self.webView reload];
    }
}

- (void)stopLoading
{
    if (self.isUIWebView)
    {
        [(UIWebView*)self.webView stopLoading];
    }
    else
    {
        [(WKWebView*)self.webView stopLoading];
    }
}

#pragma mark - 代理
- (BOOL)callback_webViewShouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(NSInteger)navigationType
{
    //点击返回时移除 loading框 和 选择日期控件
    if (UIWebViewNavigationTypeBackForward == navigationType)
    {
        if (_lbBasePlugin)
        {
            [_lbBasePlugin stopShowing];
        }
    }
    
    // url拦截 判断scheme是否验证
    NSString *scheme = kSCHEME;
    if ([[[request URL] absoluteString] hasPrefix:scheme])
    {
        NSString *jsonString = [[[request URL] absoluteString] substringFromIndex:[scheme length]];
        // 两次解码
        jsonString = [jsonString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        jsonString = [jsonString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        
        if (dic)
        {
            LBLog(@"jsCalloc:%@", dic);
            
            self.callbackIdStr = [dic objectForKey:LB_RET_callbackId];
            
            Class pluginClass = [self getPluginClass:[dic objectForKey:LB_RET_NAME]];
            self.lbBasePlugin = [[pluginClass alloc]initWithCallBackId:self.callbackIdStr param:[dic objectForKey:LB_RET_PARAM]];
            self.lbBasePlugin.viewController = [self.delegate LBGetVc];
            self.lbBasePlugin.lb = self;
            if (![NSStringFromClass(pluginClass)
                 isEqualToString:NSStringFromClass([LBBasePlugin class])])
            {
                [self.lbBasePlugin jsCallFunction];
            }
            else
            {
                // 用户信息
                if ([[dic objectForKey:LB_RET_NAME] isEqualToString:LB_NAME_USERINFO])
                {
                    if ([self.delegate respondsToSelector:@selector(LBJsCallOcFunc:param:)])
                    {
                        [self.delegate LBJsCallOcFunc:LBJsCallOcFuncTypeUserInfo param:nil];
                    }
                }
                // app信息
                else if ([[dic objectForKey:LB_RET_NAME] isEqualToString:LB_NAME_APPINFO])
                {
                    if ([self.delegate respondsToSelector:@selector(LBJsCallOcFunc:param:)])
                    {
                        [self.delegate LBJsCallOcFunc:LBJsCallOcFuncTypeAppInfo param:nil];
                    }
                }
                // 跳转到native页面
                else if ([[dic objectForKey:LB_RET_NAME] isEqualToString:LB_NAME_REDIRECT])
                {
                    if ([self.delegate respondsToSelector:@selector(LBJsCallOcFunc:param:)])
                    {
                        [self.delegate LBJsCallOcFunc:LBJsCallOcFuncTypeRedirect param:[dic objectForKey:LB_RET_PARAM]];
                    }
                }
                // 支付宝支付
                else if ([[dic objectForKey:LB_RET_NAME] isEqualToString:LB_NAME_ALIPAY])
                {
                    if ([self.delegate respondsToSelector:@selector(LBJsCallOcFunc:param:)])
                    {
                        [self.delegate LBJsCallOcFunc:LBJsCallOcFuncTypeAlipay param:[dic objectForKey:LB_RET_PARAM]];
                    }
                }
                // 分享
                else if ([[dic objectForKey:LB_RET_NAME] isEqualToString:LB_NAME_SHAREINFO])
                {
                    if ([self.delegate respondsToSelector:@selector(LBJsCallOcFunc:param:)])
                    {
                        [self.delegate LBJsCallOcFunc:LBJsCallOcFuncTypeShareInfo param:[dic objectForKey:LB_RET_PARAM]];
                    }
                }
                // 支付中心
                else if ([[dic objectForKey:LB_RET_NAME] isEqualToString:LB_NAME_CHECKOUTCOUNTER])
                {
                    if ([self.delegate respondsToSelector:@selector(LBJsCallOcFunc:param:)])
                    {
                        [self.delegate LBJsCallOcFunc:LBJsCallOcFuncTypeCheckOut param:[dic objectForKey:LB_RET_PARAM]];
                    }
                }
                // 获取爱车
                else if ([[dic objectForKey:LB_RET_NAME] isEqualToString:LB_NAME_CARINFO])
                {
                    if ([self.delegate respondsToSelector:@selector(LBJsCallOcFunc:param:)])
                    {
                        [self.delegate LBJsCallOcFunc:LBJsCallOcFuncTypeCarInfo param:[dic objectForKey:LB_RET_PARAM]];
                    }
                }
                // 获取设备信息
                else if ([[dic objectForKey:LB_RET_NAME] isEqualToString:LB_NAME_DEVICEINFO])
                {
                    if ([self.delegate respondsToSelector:@selector(LBJsCallOcFunc:param:)])
                    {
                        [self.delegate LBJsCallOcFunc:LBJsCallOcFuncTypeDeviceInfo param:[dic objectForKey:LB_RET_PARAM]];
                    }
                }
                // 关闭网页
                else if ([[dic objectForKey:LB_RET_NAME] isEqualToString:LB_NAME_CLOSEWEBVIEW])
                {
                    if ([self.delegate respondsToSelector:@selector(LBJsCallOcFunc:param:)])
                    {
                        [self.delegate LBJsCallOcFunc:LBJsCallOcFuncTypeCloseWebview param:[dic objectForKey:LB_RET_PARAM]];
                    }
                }
                // 未匹配
                else
                {
                    [_lbBasePlugin showAlert:[NSString stringWithFormat:@"未匹配方法名:%@", [dic objectForKey:LB_RET_NAME]]];
                }
            }
        }
        
        return NO;
    }
    
    // 复制url到粘帖版 (测试状态生效)
    if ([[request URL] absoluteString].length && LB_DEBUG_APP)
    {
        [[UIPasteboard generalPasteboard] setString:[[request URL] absoluteString]];
    }
    
    LBLog(@"shouldStart url:%@", [[request URL] absoluteString]);
    
    self.curUrl = [[request URL] absoluteString];
    
    if ([self.delegate respondsToSelector:@selector(LBWebView:shouldStartLoadWithRequest:navigationType:)])
    {
        if (-1 == navigationType) {
            navigationType = UIWebViewNavigationTypeOther;
        }
        return [self.delegate LBWebView:self shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    
    return YES;
}

- (void)callback_webViewDidStartLoad
{
    if ([self.delegate respondsToSelector:@selector(LBWebViewDidStartLoad:)])
    {
        [self.delegate LBWebViewDidStartLoad:self];
    }
}

- (void)callback_webViewDidFinishLoad
{
    self.errorView.hidden = YES;
    
    if ([self.delegate respondsToSelector:@selector(LBWebView:didFailLoadWithError:)])
    {
        [self.delegate LBWebViewDidFinishLoad:self];
    }
}

- (void)callback_webViewDidFailLoadWithError:(NSError *)error
{
    if (error.code != NSURLErrorCancelled)
    {
        self.errorView.hidden = NO;
    }
    
    if ([self.delegate respondsToSelector:@selector(LBWebView:didFailLoadWithError:)])
    {
        [self.delegate LBWebView:self didFailLoadWithError:error];
    }
}

#pragma mark - UIWebView 代理

/**
 *  UIWebView delegate
 *  将要加载请求
 *
 *  @param webView
 *  @param request
 *  @param navigationType
 *
 *  @return
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [self callback_webViewShouldStartLoadWithRequest:request navigationType:navigationType];
    return YES;
}

/**
 *  UIWebView delegate
 *  开始加载请求
 *
 *  @param webView
 */
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self callback_webViewDidStartLoad];
}

/**
 *  UIWebView delegate
 *  结束加载
 *
 *  @param webView
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self callback_webViewDidFinishLoad];
}

/**
 *  UIWebView delegate
 *  加载失败
 *
 *  @param webView
 *  @param error
 */
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self callback_webViewDidFailLoadWithError:error];
}

/**
 *  加载进度更新
 *
 *  @param webViewProgress
 *  @param progress
 */
-(void)webViewProgress:(LBNJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    if ([self.delegate respondsToSelector:@selector(LBLoadingProgress:)])
    {
        [self.delegate LBLoadingProgress:progress];
    }
}

#pragma mark - WKWebView 代理 : WKNavigationDelegate

// 将要加载请求
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    BOOL ret = [self callback_webViewShouldStartLoadWithRequest:navigationAction.request navigationType:navigationAction.navigationType];
    if (ret) {
        if (navigationAction.targetFrame == nil)
        {
            [webView loadRequest:navigationAction.request];
        }
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    else
    {
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}

// 开始加载请求
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    [self callback_webViewDidStartLoad];
}

// 结束加载
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self callback_webViewDidFinishLoad];
}

// 加载失败
- (void)webView: (WKWebView *)webView didFailNavigation:(WKNavigation *) navigation withError: (NSError *) error
{
    [self callback_webViewDidFailLoadWithError:error];
}

// 加载失败
- (void)webView:(WKWebView *) webView didFailProvisionalNavigation: (WKNavigation *) navigation withError: (NSError *) error
{
    [self callback_webViewDidFailLoadWithError:error];
}

#pragma mark - WKWebView 代理 : WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(nonnull void (^)(void))completionHandler
{
    [[[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil] show];
    
    completionHandler();
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    LBRIButtonItem *cancelButtonItem = [LBRIButtonItem itemWithLabel:@"取消" action:^{
        completionHandler(false);
    }];
    
    LBRIButtonItem *otherButtonItem = [LBRIButtonItem itemWithLabel:@"确定" action:^{
        completionHandler(true);
    }];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message cancelButtonItem:cancelButtonItem otherButtonItems:otherButtonItem, nil];
    
    [alert show];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *))completionHandler
{
    
}

#pragma mark - kvo代理

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        if ([self.delegate respondsToSelector:@selector(LBLoadingProgress:)]) {
            [self.delegate LBLoadingProgress:[change[NSKeyValueChangeNewKey] doubleValue]];
        }
    }
}

#pragma mark - 内部方法

/**
 *  获取对应插件Class
 *
 *  @param classString
 *
 *  @return
 */
- (Class)getPluginClass:(NSString *)classString
{
    Class pluginClass;
    
    // 相机相册
    if ([classString isEqualToString:LB_NAME_CAMERA])
    {
        pluginClass = [LBCamera class];
    }
    // 二维码扫码
    else if ([classString isEqualToString:LB_NAME_QRCODE])
    {
        pluginClass = [LBQrCode class];
    }
    // 二维码图片识别
    else if ([classString isEqualToString:LB_NAME_QRCODEIMAGE])
    {
       pluginClass = [LBQrCodeImage class];
    }
    // 扫描条形码
    else if ([classString isEqualToString:LB_NAME_BARCODE])
    {
        pluginClass = [LBBarCode class];
    }
    // 打电话
    else if ([classString isEqualToString:LB_NAME_TEL])
    {
        pluginClass = [LBTel class];
    }
    // 发送邮件
    else if ([classString isEqualToString:LB_NAME_EMAIL])
    {
        pluginClass = [LBEmail class];
    }
    // 发送短信
    else if ([classString isEqualToString:LB_NAME_SMS])
    {
        pluginClass = [LBSms class];
    }
    // 经纬度
    else if ([classString isEqualToString:LB_NAME_GEOLOCATION])
    {
        pluginClass = [LBGeoLocation class];
    }
    // 对话框
    else if ([classString isEqualToString:LB_NAME_DIALOG])
    {
        pluginClass = [LBDialog class];
    }
    // toast
    else if ([classString isEqualToString:LB_NAME_TOAST])
    {
        pluginClass = [LBToast class];
    }
    // loading
    else if ([classString isEqualToString:LB_NAME_LOADING])
    {
        pluginClass = [LBLoading class];
    }
    // 日期
    else if ([classString isEqualToString:LB_NAME_DATE])
    {
        pluginClass = [LBDate class];
    }
    // 业务功能(用户信息,设备信息,跳转到native页面,支付宝支付)
    else
    {
        pluginClass = [LBBasePlugin class];
    }
    return pluginClass;
}

- (void) layoutSubviews
{
    self.webView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.errorView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

#pragma mark - set & get

-(BOOL)canGoBack
{
    if (self.isUIWebView)
    {
        return [(UIWebView*)self.webView canGoBack];
    }
    else
    {
        return [(WKWebView*)self.webView canGoBack];
    }
}

-(BOOL)canGoForward
{
    if (self.isUIWebView)
    {
        return [(UIWebView*)self.webView canGoForward];
    }
    else
    {
        return [(WKWebView*)self.webView canGoForward];
    }
}

- (UIView *)errorView
{
    if (!_errorView)
    {
        _errorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _errorView.backgroundColor = [UIColor clearColor];
        _errorView.hidden = YES;
    }
    
    return _errorView;
}

- (UIView *)webView
{
    if (!_webView)
    {
        if (LB_WKWebView && !USE_UIWEBVIEW)
        {
            LBLog(@"使用WKWebView");
            _isUIWebView = NO;
            
            WKWebViewConfiguration* configuration = [[NSClassFromString(@"WKWebViewConfiguration") alloc] init];
            configuration.preferences = [NSClassFromString(@"WKPreferences") new];
            configuration.userContentController = [NSClassFromString(@"WKUserContentController") new];
            
            WKWebView* webView = [[LB_WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) configuration:configuration];
            webView.UIDelegate = self;
            webView.navigationDelegate = self;
            
            // 进度条监听
            [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
            
            _webView = webView;
        }
        else
        {
            LBLog(@"使用UIWebView");
            _isUIWebView = YES;
            
            UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            webView.delegate = self;
            webView.scalesPageToFit = YES;
            webView.backgroundColor = [UIColor clearColor];
            
            // 进度初始化
            self.lbNJKWebViewProgress = [[LBNJKWebViewProgress alloc] init];
            webView.delegate = _lbNJKWebViewProgress;
            _lbNJKWebViewProgress.webViewProxyDelegate = self;
            _lbNJKWebViewProgress.progressDelegate = self;
            
            _webView = webView;
        }
    }
    
    return _webView;
}

- (void)dealloc
{
    if (self.isUIWebView)
    {
        UIWebView* webView = (UIWebView*)self.webView;
        webView.delegate = nil;
    }
    else
    {
        WKWebView* webView = (WKWebView*)self.webView;
        webView.UIDelegate = nil;
        webView.navigationDelegate = nil;
        
        [webView removeObserver:self forKeyPath:@"estimatedProgress"];
    }
    [self stopLoading];
    [self removeFromSuperview];
}

@end
