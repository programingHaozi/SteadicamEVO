//
//  TFLoadingView.h
//  TFUILib
//
//  Created by xiayiyong on 16/4/15.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFView.h"

@interface TFLoadingView : UIView

/**
 *  指示器样式
 */
@property(nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;

/**
 *  文字字体
 */
@property (nonatomic,strong) NSString *text;

/**
 *  显示LoadingView
 *
 *  @param text           text
 *  @param atView         父窗口
 *  @param indicatorStyle 指示器样式
 *
 *  @return 
 */
+ (void) showWithText:(NSString *)text
      activityIndicatorViewStyle:(UIActivityIndicatorViewStyle)indicatorStyle
               atView:(UIView *)atView;

/**
 *  隐藏
 */
+(void)hideAtView:(UIView *)atView;

/**
 *  初始化LoadingView
 *
 *  @param text           text
 *  @param indicatorStyle 指示器样式
 *
 *  @return
 */
- (instancetype) initWithText:(NSString *)text
   activityIndicatorViewStyle:(UIActivityIndicatorViewStyle)indicatorStyle;

/**
 *  显示
 */
-(void)showAtView:(UIView *)atView;

/**
 *  隐藏
 */
-(void)hide;

@end

