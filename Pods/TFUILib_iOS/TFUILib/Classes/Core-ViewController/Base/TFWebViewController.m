//
//  TFWebViewController.m
//  Treasure
//
//  Created by xiayiyong on 15/9/9.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFWebViewController.h"
#import "TFBaseLib.h"
#import <TFButton.h>
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



@end

@implementation TFWebViewController

#pragma mark- initMethod

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.isNeedProgressView = YES;
    }

    return self;
}

- (instancetype)initWithURL:(NSString *)URL
        isNeedMulilayerBack:(BOOL)needBack
                isNeedClose:(BOOL)isNeedClose
                      title:(NSString *)title
 shouldStartLoadWithRequest:(void(^)(NSURLRequest *request))requestBlock
               didStartLoad:(void(^)())didStarBlock
              DidFinishLoad:(void(^)())didFinishBlock
                didFailLoad:(void(^)(NSError *error))didFailBlock;{
    self = [self initWithNibName:nil bundle:nil];

    if (self)
    {
        self.isNeedClose = isNeedClose;
        self.isNeedMulilayerBack = needBack;
        [self initTitle:title];
        self.urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:URL]];

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

- (void)initCloseButtonImage:(NSString *)strImage
                       title:(NSString *)strTitle
                       color:(UIColor *)color;
{
    self.closeButtonItem = [self cretCloseButtonImage:strImage title:strTitle color:color];
}

#pragma mark- cycle

- (void)viewWillAppear:(BOOL)animated
{
    if (self.model)
    {
        self.isNeedProgressView = self.model.isNeedProgress;
    }
    else
    {
        self.isNeedProgressView = self.isNeedProgressView;
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
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

- (void)initViews
{
    [super initViews];
    [self.view addSubview:self.webView];
    [self initDataWithParam];
}

- (void)autolayoutViews
{
    [super autolayoutViews];

    WS(weakSelf)
    [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(super.view).with.insets(UIEdgeInsetsMake(weakSelf.top, 0, 0, 0));
    }];

}

- (void)bindData
{
    [super bindData];
    @weakify(self);
    [[RACObserve(self, model) filter:^BOOL(id value) {
        return (value) ? YES : NO;
    }] subscribeNext:^(TFWebModel *model) {
        @strongify(self);
        self.isNeedClose = self.model.isNeedClose;
        self.isNeedMulilayerBack = self.model.isNeedMulilayerBack;
        self.urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.model.url]];
        self.fixedTitleStr = self.model.fixedTitle;
        self.placeholderTitleStr = self.model.placeholderTitle;
        self.progressViewColor = self.model.progressViewColor;
        [self initDataWithParam];
    }];

    [self loadUrl];
}

/**
 *  初始化数据
 */
- (void)initDataWithParam
{
    if (self.placeholderTitleStr)
    {
        [self initTitle:self.placeholderTitleStr];
    }
    if (self.fixedTitleStr)
    {
        [self initTitle:self.fixedTitleStr];
    }
}

- (UIBarButtonItem *)cretCloseButtonImage:(NSString *)strImage
                                    title:(NSString *)strTitle
                                    color:(UIColor *)color;
{
    TFButton *btn = [[TFButton alloc]  initWithFrame:CGRectZero];
    [btn addTarget:self action:@selector(closeButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [btn setNormalTitle:strTitle textFont:[UIFont systemFontOfSize: 14.0] textColor:color];
    [btn setNormalImage:strImage hightlightedImage:strImage disabledImage:nil];
    [btn sizeToFit];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.backgroundColor = [UIColor clearColor];

    return [[UIBarButtonItem alloc] initWithCustomView:btn];
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
    CGRect barFrame = CGRectMake(0, 64 - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    self.progressView = [[TFProgressView alloc] initWithFrame:barFrame color:proColor];
    [self.customNavigationBar addSubview:self.progressView];
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
 *  刷新导航栏按钮
 */
- (void)updateLeftAndRightButton
{
    if (self.isCanClose)
    {
        if (self.isNeedClose)
        {
            self.customNavigationItem.leftBarButtonItems = @[self.backButtonItem, self.closeButtonItem];
        }
    }
}

/**
 *  点击导航栏返回按钮
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
 *  点击导航栏关闭按钮
 */
- (void)closeButtonEvent
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

#pragma mark- SetMethod

- (void)setNavTitle:(NSString *)title
{
    if (self.fixedTitleStr)
    {
        [self initTitle:self.fixedTitleStr];
    }
    else if (title.length)
    {
        [self initTitle:title];
    }
}

- (void)setIsNeedProgressView:(BOOL)isNeedProgressView
{
    _isNeedProgressView = isNeedProgressView;
    if (isNeedProgressView)
    {
        if (self.progressView)
        {
            [self.progressView removeFromSuperview];
            //            self.progressView = nil;
        }

        [self addProgressViewAboveNaviBar:self.progressViewColor ? self.progressViewColor : [UIColor colorWithHexString:@"0X03A9F4"]];

    }
}


- (void)setProgressViewColor:(UIColor *)progressViewColor
{
    _progressViewColor = progressViewColor;
    self.progressView.progressBarView.backgroundColor = progressViewColor;
}

- (void)setUaDicton:(NSDictionary *)uaDicton
{
    _uaDicton = uaDicton;

    [[NSUserDefaults standardUserDefaults] registerDefaults:[[NSDictionary alloc] initWithObjectsAndKeys:[[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:uaDicton options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\n" withString:@""], @"UserAgent", nil]];
}

#pragma mark- GetMethod
- (UIBarButtonItem *)backButtonItem
{
    if (!_backButtonItem)
    {
        _backButtonItem = self.customNavigationItem.leftBarButtonItem;
    }

    return _backButtonItem;
}

- (TFWebView *)webView
{
    if (!_webView)
    {
        _webView = [[TFWebView alloc] initWithFrame:CGRectZero];
        _webView.delegate = self;
    }

    return _webView;
}

- (UIBarButtonItem *)closeButtonItem
{
    if (!_closeButtonItem)
    {
        _closeButtonItem = [self cretCloseButtonImage:@"" title:@"关闭" color:[UIColor blackColor]];
    }
    
    return _closeButtonItem;
}

@end
