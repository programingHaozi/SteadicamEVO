//
//  KMacroDefine.h
//  LightBundle
//
//  Created by Hu Dan 胡丹 on 15/11/3.
//  Copyright © 2015年 Ren Wenchao 任文超. All rights reserved.
//

#ifndef KMacroDefine_h
#define KMacroDefine_h

#pragma mark ----------日志输出------------

// 是否是测试状态
#define LB_DEBUG_APP 0

#if LB_DEBUG_APP
// log
#define LBLog(format, ...) NSLog((@"%@" format), @"[LightBundle:debug] ", ##__VA_ARGS__);
/**
 测试参数
 */
// 强制使用uiwebview
#define USE_UIWEBVIEW 0

#else

#define LBLog(format, ...) NSLog((@"%@" format), @"[LightBundle:LBWebView] ", ##__VA_ARGS__);
#define USE_UIWEBVIEW 0
#endif

#define LB_WKWebView (NSClassFromString(@"WKWebView"))

#pragma mark ----------js-sdk返回数据的方法------------

// js-sdk 返回数据的方法
#define LB_FUNC_CALLBACK(JsonText) ([NSString stringWithFormat:@"window.lb.callByNative(%@)", JsonText])

#pragma mark ----------UI------------
// color
#define COLOR_SYSTEM_DEFAULT [UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1]


#pragma mark ----------判断是否是模拟器------------

// 判断是否是模拟器
#if TARGET_IPHONE_SIMULATOR
#define LB_SIMULATOR 1
#elif TARGET_OS_IPHONE
#define LB_SIMULATOR 0
#endif


#pragma mark ----------判断系统------------------
/**
 *  判断系统版本
 *
 *  @return
 */
#define LB_SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]


#endif
