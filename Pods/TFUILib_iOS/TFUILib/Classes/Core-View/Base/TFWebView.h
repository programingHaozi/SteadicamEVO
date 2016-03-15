//
//  TFWebView.h
//  TFUILib
//
//  Created by xiayiyong on 16/1/12.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <LightBundle.h>
@interface TFWebView : LBWebView

/**
 *  加载url
 *
 *  @param aURL url
 */
- (void)loadURL:(NSURL *)aURL;

/**
 *  加载url
 *
 *  @param aURL url
 */
- (void)loadURLString:(NSString *)string;

/**
 *  加载request
 *
 *  @param aRequest
 */
- (void)loadRequest:(NSURLRequest *)aRequest;

/**
 *  加载HTML
 *
 *  @param string 地址
 */
- (void)loadHTMLString:(NSString *)string;

@end
