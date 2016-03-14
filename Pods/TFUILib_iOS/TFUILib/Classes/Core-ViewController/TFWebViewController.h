//
//  TFWebViewController.h
//  Treasure
//
//  Created by xiayiyong on 15/9/9.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFViewController.h"
#import "TFWebModel.h"
#import "Masonry.h"

@interface TFWebViewController : TFViewController<UIWebViewDelegate>

@property (nonatomic,strong) NSString *url;

@property (nonatomic,strong) UIWebView *webView;

- (void)loadWebView:(NSString *)url title:(NSString*)title;

- (void)loadWebView:(NSString *)url title:(NSString*)title showProgress:(BOOL)flag;

@end
