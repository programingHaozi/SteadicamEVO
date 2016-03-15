//
//  TFWebView.m
//  TFUILib
//
//  Created by xiayiyong on 16/1/12.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFWebView.h"

@implementation TFWebView

- (void)loadURL:(NSURL *)aURL
{
    [self loadUrl:[NSURLRequest requestWithURL:aURL]];
}

- (void)loadURLString:(NSString *)string;
{
    [self loadUrl:[NSURLRequest requestWithURL:[NSURL URLWithString:string]]];
}

- (void)loadRequest:(NSURLRequest *)aRequest;
{
    [self loadUrl:aRequest];
}

- (void)loadHTMLString:(NSString *)string;
{
    [self loadHTMLString:string baseURL:nil];
}

@end
