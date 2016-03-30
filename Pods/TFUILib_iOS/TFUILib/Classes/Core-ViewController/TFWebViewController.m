//
//  TFWebViewController.m
//  Treasure
//
//  Created by xiayiyong on 15/9/9.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFWebViewController.h"
#import "TFBaseLib.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

#define LINE_HEIGHT 3

@interface TFWebViewController ()

@property (nonatomic, readwrite, strong) NSURLRequest* loadRequest;

@property (nonatomic, strong) void(^requestBlock)(NSURLRequest *request);
@property (nonatomic, strong) void(^didStarBlock)();
@property (nonatomic, strong) void(^didFinishBlock)();
@property (nonatomic, strong) void(^didFailBlock)(NSError *error);

/**
 *  导航栏返回按钮
 */
@property (nonatomic, strong) UIBarButtonItem *backButtonItem;

/**
 *  导航栏关闭按钮
 */
@property (nonatomic, strong) UIBarButtonItem *closeButtonItem;

@property (nonatomic, assign) BOOL isCanClose;

@end

@implementation TFWebViewController

- (instancetype)initWithURL:(NSString *)URL
        isNeedMulilayerBack:(BOOL)needBack
                isNeedClose:(BOOL)isNeedClose
                      title:(NSString *)title
 shouldStartLoadWithRequest:(void(^)(NSURLRequest *request))requestBlock
               didStartLoad:(void(^)())didStarBlock
              DidFinishLoad:(void(^)())didFinishBlock
                didFailLoad:(void(^)(NSError *error))didFailBlock;{
    self = [super initWithNibName:nil bundle:nil];

    if (self)
    {
        self.isNeedClose = isNeedClose;
        self.isNeedMulilayerBack = needBack;
        self.title = title;
        _urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:URL]];

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

- (void)initBackButtonImage:(NSString *)strImage
                      title:(NSString *)strTitle
                      color:(UIColor *)color;
{
    CGRect rect = CGRectMake(0, -2*SCREEN_WIDTH/320, 30, 44);

    UIButton *btn = [[UIButton alloc] initWithFrame:rect];

    [btn addTarget:self action:@selector(leftButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateHighlighted];
    [btn setTitle:strTitle forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.backgroundColor = [UIColor clearColor];

    self.backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];

    [self updateLeftAndRightButton];
}

- (void)initCloseButtonImage:(NSString *)strImage
                       title:(NSString *)strTitle
                       color:(UIColor *)color;
{

    CGRect rect = CGRectMake(0, 0, 30, 44);

    UIButton *btn = [[UIButton alloc] initWithFrame:rect];

    [btn addTarget:self action:@selector(rightButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateHighlighted];
    [btn setTitle:strTitle forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.backgroundColor = [UIColor clearColor];

    self.closeButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.model)
    {
        self.isNeedProgressView = self.model.isNeedProgress;
    }
    self.isNeedProgressView = self.isNeedProgressView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initWebView];
    [self loadUrl];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    if (self.progressView)
    {
        [self.progressView removeFromSuperview];
        self.progressView = nil;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    if (self.progressView)
    {
        [self.progressView removeFromSuperview];
        self.progressView = nil;
    }
}

#pragma mark- init autolayout bind

/**
 *  初始化数据
 */
- (void)initDataWithParam
{
    if (self.placeholderTitle)
    {
        [self setTitle:self.placeholderTitle];
    }

    if (self.fixedTitle)
    {
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

#pragma mark- init autolayout bind

- (void)initWebView
{
    [self addwebView:CGRectZero];
    self.view.backgroundColor = [UIColor clearColor];
    [self initDataWithParam];

    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];

    @weakify(self);
    [[RACObserve(self, model) filter:^BOOL(id value) {
        return (value) ? YES : NO;
    }] subscribeNext:^(TFWebModel *model) {
        @strongify(self);
        self.isNeedClose = self.model.isNeedClose;
        self.isNeedMulilayerBack = self.model.isNeedMulilayerBack;
        self.urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.model.url]];
        self.fixedTitle = self.model.fixedTitle;
        self.placeholderTitle = self.model.placeholderTitle;
        self.progressViewColor = self.model.progressViewColor;

        if (self.placeholderTitle)
        {
            [self setTitle:self.placeholderTitle];
        }

        if (self.fixedTitle)
        {
            [self setTitle:self.fixedTitle];
        }

        [self loadUrl];
    }];
}

// 加载url
- (void)loadUrl
{

    if (self.urlRequest == nil)
    {
        return;
    }
    if ([self.urlRequest.URL.absoluteString rangeOfString:@"http://"].length || [self.urlRequest.URL.absoluteString rangeOfString:@"https://"].length)
    {
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
- (void)leftButtonEvent
{
    if ([self.webView canGoBack] && self.isNeedMulilayerBack)
    {
        self.isCanClose = YES;
        [self.webView goBack];
        [self updateLeftAndRightButton];
    }
    else
    {
        [self back];
    }
}

/**
 *  点击导航栏右按钮
 */
- (void)rightButtonEvent
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

    if (!self.model.isNeedAllowGesture)
    {
        [self.webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';" completionHandler:^(id ret, NSError *error) {

        }];

        [self.webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:^(id ret, NSError *error) {

        }];
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

- (void)setUrlRequest:(NSURLRequest *)urlRequest
{
    _urlRequest = urlRequest;
    [self loadUrl];
}

- (void)setIsNeedProgressView:(BOOL)isNeedProgressView
{
    _isNeedProgressView = isNeedProgressView;
    if (isNeedProgressView)
    {
        if (self.progressView)
        {
            [self.progressView removeFromSuperview];
            self.progressView = nil;
        }
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
        [self addProgressViewAboveNaviBar:color];

    }
}

- (void)setProgressViewColor:(UIColor *)progressViewColor
{
    _progressViewColor = progressViewColor;
    self.progressView.progressBarView.backgroundColor = progressViewColor;
}

/**
 *  设置返回按钮
 */
- (void)leftBackButton
{
    self.navigationItem.leftBarButtonItems = nil;

    UIBarButtonItem *leftBarItem = nil;

    if (self.backButtonItem) {
        leftBarItem = self.backButtonItem;
    }
    else {

        CGRect rect = CGRectMake(0, -2*SCREEN_WIDTH/320, 30, 44);

        UIButton *btn = [[UIButton alloc] initWithFrame:rect];

        [btn addTarget:self action:@selector(leftButtonEvent) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"返回" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.backgroundColor = [UIColor clearColor];
        leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:btn];

    }
    self.navigationItem.leftBarButtonItem = leftBarItem;
}

/**
 *  设置返回按钮和关闭按钮
 */
- (void)leftBackButtonAndRightCloseButton
{
    self.navigationItem.leftBarButtonItems = nil;

    UIBarButtonItem *leftBarItem = nil;
    if (self.backButtonItem) {
        leftBarItem = self.backButtonItem;
    }
    else {
        CGRect rect = CGRectMake(0, -2*SCREEN_WIDTH/320, 30, 44);

        UIButton *btn = [[UIButton alloc] initWithFrame:rect];

        [btn addTarget:self action:@selector(leftButtonEvent) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"返回" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.backgroundColor = [UIColor clearColor];
        leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }

    UIBarButtonItem *rightBarItem = nil;
    if (self.closeButtonItem) {
        rightBarItem = self.closeButtonItem;
    }
    else {
        CGRect rect = CGRectMake(0, 0, 30, 44);

        UIButton *btn = [[UIButton alloc] initWithFrame:rect];

        [btn addTarget:self action:@selector(rightButtonEvent) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
        [btn setTitle:@"关闭" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.backgroundColor = [UIColor clearColor];

        rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }

    if (self.isNeedClose) {
        self.navigationItem.leftBarButtonItem = leftBarItem;
        self.navigationItem.leftBarButtonItems = @[leftBarItem, rightBarItem];
    }
    else {
        self.navigationItem.leftBarButtonItem = leftBarItem;
    }

}

- (void)setUaDicton:(NSDictionary *)uaDicton
{
    _uaDicton = uaDicton;

    [[NSUserDefaults standardUserDefaults] registerDefaults:[[NSDictionary alloc] initWithObjectsAndKeys:[[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:uaDicton options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\n" withString:@""], @"UserAgent", nil]];
}

@end
