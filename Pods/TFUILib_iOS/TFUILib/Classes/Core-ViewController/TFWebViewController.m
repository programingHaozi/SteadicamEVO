//
//  TFWebViewController.m
//  Treasure
//
//  Created by xiayiyong on 15/9/9.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFWebViewController.h"
#import "TFBaseLib.h"

#define LINE_HEIGHT 3

@interface TFWebViewController ()<LBWebViewDelegate>

@property (nonatomic, readwrite, strong) NSURLRequest* loadRequest;
@property (nonatomic, strong) void(^requestBlock)(NSURLRequest *request);
@property (nonatomic, strong) void(^didStarBlock)();
@property (nonatomic, strong) void(^didFinishBlock)();
@property (nonatomic, strong) void(^didFailBlock)(NSError *error);

@property (nonatomic, assign) BOOL isCanClose;

@end

@implementation TFWebViewController

- (instancetype)initWithURL:(NSString *)URL
        isNeedMulilayerBack:(BOOL)needBack
                isNeedClose:(BOOL)isNeedClose
                      title:(NSString *)title
             isNeedProgress:(BOOL)isNeedProgress
 shouldStartLoadWithRequest:(void(^)(NSURLRequest *request))requestBlock
               didStartLoad:(void(^)())didStarBlock
              DidFinishLoad:(void(^)())didFinishBlock
                didFailLoad:(void(^)(NSError *error))didFailBlock;
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self)
    {
        [self addwebView:self.view.frame];
        self.isNeedClose = isNeedClose;
        self.isNeedMulilayerBack = needBack;
        self.title = title;
        _urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:URL]];
        [self loadUrl];
        self.isNeedProgressView = isNeedProgress;
        self.requestBlock = requestBlock;
        self.didStarBlock = didStarBlock;
        self.didFinishBlock = didFinishBlock;
        self.didFailBlock = didFailBlock;
    }
    
    return self;
}

- (void)shouldStartLoadWithRequest:(void(^)(NSURLRequest *request))requestBlock
                      didStartLoad:(void(^)())didStarBlock
                     didFinishLoad:(void(^)())didFinishBlock
                       didFailLoad:(void(^)(NSError *error))didFailBlock;
{
    self.requestBlock = requestBlock;
    self.didStarBlock = didStarBlock;
    self.didFinishBlock = didFinishBlock;
    self.didFailBlock = didFailBlock;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addwebView:self.view.frame];
    self.view.backgroundColor = [UIColor clearColor];
    [self initDataWithParam];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.progressView) {
        [self.progressView removeFromSuperview];
    }
}

#pragma mark- init autolayout bind

- (void)initViews
{
    NSString *className=NSStringFromClass([self class]);
    if (![className isEqualToString:NSStringFromClass([TFWebViewController class])])
    {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:[NSString stringWithFormat:@"You must override %@ in %@", NSStringFromSelector(_cmd), self.class]
                                     userInfo:nil];
    }
}

- (void)autolayoutViews
{
    NSString *className=NSStringFromClass([self class]);
    if (![className isEqualToString:NSStringFromClass([TFWebViewController class])])
    {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:[NSString stringWithFormat:@"You must override %@ in %@", NSStringFromSelector(_cmd), self.class]
                                     userInfo:nil];
    }
}

- (void)bindData
{
    NSString *className=NSStringFromClass([self class]);
    if (![className isEqualToString:NSStringFromClass([TFWebViewController class])])
    {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:[NSString stringWithFormat:@"You must override %@ in %@", NSStringFromSelector(_cmd), self.class]
                                     userInfo:nil];
    }
}

/**
 *  初始化数据
 */
- (void)initDataWithParam
{
    if (self.placeholderTitle) {
        [self setTitle:self.placeholderTitle];
    }
    if (self.fixedTitle) {
        [self setTitle:self.fixedTitle];
    }
}

/**
 *  添加webView
 *
 *  @param frame lb尺寸
 */
- (void)addwebView:(CGRect) frame;
{
    self.webView = [[TFWebView alloc] initWithFrame:frame];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
}

/**
 *  添加进度条(添加在navigationBar上)
 *
 *  @param proColor 进度条颜色
 */
- (void)addProgressViewAboveNaviBar:(UIColor*)proColor;
{
    CGFloat progressBarHeight = 2.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    self.progressView = [[TFProgressView alloc] initWithFrame:barFrame color:proColor];
    [self.navigationController.navigationBar addSubview:self.progressView];
}

/**
 *  添加化进度条(添加在WebView上)
 *
 *  @param proColor 进度条颜色
 */
- (void)addProgressViewAboveWebView:(UIColor*)proColor y:(float)y
{
    CGFloat progressBarHeight = 2.f;
    
    CGRect frame = CGRectMake(0, y, self.webView.frame.size.width, progressBarHeight);
    self.progressView = [[TFProgressView alloc] initWithFrame:frame color:proColor];
    [self.webView addSubview:self.progressView];
}

// 加载url
- (void)loadUrl
{
    if ([self.urlRequest.URL.absoluteString rangeOfString:@"http://"].length || [self.urlRequest.URL.absoluteString rangeOfString:@"https://"].length) {
        
        [self.webView loadUrl:self.urlRequest];
    }
    else
    {
        [self.webView loadHTMLString:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.urlRequest.URL.absoluteString ofType:@"html"] encoding:NSUTF8StringEncoding error:nil] baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    }
}

/**
 *  刷新导航栏左、右边按钮
 */
- (void)updateLeftAndRightButton
{
    if (self.isCanClose)
    {
        [self leftBackButtonAndRightCloseButton];
    }
    else
    {
        [self leftBackButton];
    }
}

/**
 *  点击导航栏左按钮
 */
- (void)leftEvent:(UIButton *)button
{
    if ([self.webView canGoBack] && self.isNeedMulilayerBack)
    {
        self.isCanClose = YES;
        [self.webView goBack];
    }
    else {
        [self back];
    }
}


/**
 *  点击导航栏右按钮
 */
- (void)rightEvent:(UIButton *)button
{
    [self back];
}

#pragma mark - 代理回调

- (UIViewController *)LBGetVc
{
    return self;
}

- (BOOL)LBWebView:(LBWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (self.requestBlock)
    {
        self.requestBlock(request);
    }
    
    return YES;
}

- (void)LBWebViewDidStartLoad:(LBWebView *)webView
{
    [self.webView evaluateJavaScript:@"document.title" completionHandler:^(id ret, NSError *error)
     {
         [self setNavTitle:ret];
     }];
    
    if (self.isNeedClose)
    {
        [self updateLeftAndRightButton];
    }
    
    if (self.didStarBlock)
    {
        self.didStarBlock();
    }
    
}

- (void)LBWebViewDidFinishLoad:(LBWebView *)webView
{
    [self.webView evaluateJavaScript:@"document.title" completionHandler:^(id ret, NSError *error)
     {
         [self setNavTitle:ret];
     }];
    
    if (self.isNeedClose)
    {
        [self updateLeftAndRightButton];
    }
    
    if (self.didFinishBlock)
    {
        self.didFinishBlock();
    }
}

- (void)LBWebView:(LBWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.webView evaluateJavaScript:@"document.title" completionHandler:^(id ret, NSError *error) {
        [self setNavTitle:ret];
    }];
    
    if (self.isNeedClose)
    {
        [self updateLeftAndRightButton];
    }
    
    if (self.progressView)
    {
        [self.progressView setProgress:1.0];
    }
    
    if (self.didFailBlock)
    {
        self.didFailBlock(error);
    }
}

- (void)LBLoadingProgress:(float)progress
{
    if (self.progressView)
    {
        [self.progressView setProgress:progress];
    }
}

#pragma mark - 内部方法

- (void)setNavTitle:(NSString *)title
{
    if (self.fixedTitle)
    {
        self.title = self.fixedTitle;
    }
    else if (title.length)
    {
        self.title = title;
    }
}

- (void)setIsNeedProgressView:(BOOL)isNeedProgressView
{
    _isNeedProgressView = isNeedProgressView;
    if (isNeedProgressView)
    {
        UIColor *color;
        if (self.progressViewColor)
        {
            color = self.progressViewColor;
        }
        else
        {
            // 默认color
            color = [UIColor colorWithHexString:@"0X03A9F4"];
        }
        if (self.navigationController)
        {
            [self addProgressViewAboveNaviBar:color];
        }
        else
        {
            [self addProgressViewAboveWebView:color y:0];
        }
    }
}

- (void)setProgressViewColor:(UIColor *)progressViewColor
{
    _progressViewColor = progressViewColor;
    self.progressView.progressBarView.backgroundColor = progressViewColor;
}

- (UIColor *)closeButtonColor
{
    if (!_closeButtonColor)
    {
        _closeButtonColor = [UIColor blackColor];
    }
    
    return _closeButtonColor;
}

/**
 *  设置返回按钮
 */
- (void)leftBackButton
{
    [self hideRight];
}

/**
 *  设置返回按钮和关闭按钮
 */
- (void)leftBackButtonAndRightCloseButton
{
    [self initRightTitle:@"关闭" color:self.closeButtonColor];
    
    if (!self.isNeedClose)
    {
        [self hideRight];
    }
}

- (void)setUaDicton:(NSDictionary *)uaDicton
{
    _uaDicton = uaDicton;
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:[[NSDictionary alloc] initWithObjectsAndKeys:[[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:uaDicton options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\n" withString:@""], @"UserAgent", nil]];
}

@end
