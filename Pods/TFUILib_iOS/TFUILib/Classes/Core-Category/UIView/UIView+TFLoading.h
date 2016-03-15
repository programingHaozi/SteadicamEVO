//
//  UIView+Loading.h
//  loading
//
//  Created by xiayiyong on 15/9/9.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFLoadingView : UIView

/**
 *  指示器
 */
@property(nonatomic, strong) UIActivityIndicatorView *indicator;

/**
 *  提示Label
 */
@property(nonatomic, strong) UILabel *alertLabel;

/**
 *  指示器样式
 */
@property(nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;

/**
 *  初始化LoadingView
 *
 *  @param frame          视图大小
 *  @param superView      父视图
 *  @param alertMessage   提示信息
 *  @param fixedY         Y轴偏移
 *  @param indicatorStyle 指示器样式
 *
 *  @return LoadingView
 */
- (id) initWithFrame:(CGRect)frame
           superView:(UIView *)superView
                 alertText:(NSString *)alertMessage
                    fixedY:(CGFloat)fixedY
activityIndicatorViewStyle:(UIActivityIndicatorViewStyle)indicatorStyle;

@end

@interface UIView (TFLoading)

/**
 *  Loading视图
 */
@property(nonatomic, strong) TFLoadingView *loadingView;

/**
 *  显示Loading视图
 */
-(void)showLoading;

/**
 *  显示Loading视图
 *
 *  @param alertText 提示信息
 */
-(void)showLoadingWithText:(NSString *)alertText;

/**
 *  显示带ScrollView的Loading视图
 *
 *  @param shouldFixed Y轴是否偏移
 *  @param alertText   提示信息
 */
-(void)showLoadingWithScrollViewFixed:(BOOL)shouldFixed
                            alertText:(NSString *)alertText;

/**
 *  显示带ScrollView的Loading视图
 *
 *  @param shouldFixed    Y周是否偏移
 *  @param alertText      提示信息
 *  @param indicatorStyle 指示器样式
 */
-(void)showLoadingWithScrollViewFixed:(BOOL)shouldFixed
                            alertText:(NSString *)alertText
           activityIndicatorViewStyle:(UIActivityIndicatorViewStyle)indicatorStyle;

/**
 *  隐藏Loading视图
 */
-(void)hideLoading;

@end
