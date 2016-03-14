//
//  TFWebViewController.m
//  Treasure
//
//  Created by xiayiyong on 15/9/9.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFWebViewController.h"

#define LINE_HEIGHT 3

@interface TFWebViewController ()

@property (nonatomic,strong) UIView *progressView;

@end

@implementation TFWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initBackButton];
    
    [self.view addSubview:self.webView];
    [self.webView addSubview:self.peogressView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(super.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    if (self.url!=nil)
    {
        [self loadWebView:self.url title:self.title];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadWebView:(NSString *)urlString title:(NSString*)title
{
    [self loadWebView:urlString title:title showProgress:NO];
}

- (void)loadWebView:(NSString *)urlString title:(NSString*)title showProgress:(BOOL)flag
{
    [self setTitle:title];
    
    NSLog(@"url=%@",urlString);
    
    NSURL *url =[NSURL URLWithString:urlString];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

#pragma mark webViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

- (void)setProgress:(float)progress
{
    if (progress<=0||progress>=1)
    {
        self.peogressView.frame=CGRectMake(0, 0, 0, LINE_HEIGHT);
    }
    else
    {
        self.peogressView.frame=CGRectMake(0, 0, self.webView.bounds.size.width*progress, LINE_HEIGHT);
    }
}

-(UIWebView *)webView
{
    if(_webView==nil)
    {
        _webView=[[UIWebView alloc]initWithFrame:self.view.bounds];
    }
    
    return _webView;
}

-(UIView *)peogressView
{
    if(_progressView==nil)
    {
        _progressView=[[UIView alloc]init];
        _progressView.frame=CGRectMake(0, 0, 0, LINE_HEIGHT);
        _progressView.backgroundColor=[UIColor greenColor];
    }
    
    return _progressView;
}

@end
