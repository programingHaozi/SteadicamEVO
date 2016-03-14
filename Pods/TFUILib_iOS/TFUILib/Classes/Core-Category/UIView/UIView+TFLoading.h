//
//  UIView+Loading.h
//  loading
//
//  Created by xiayiyong on 15/9/9.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFLoadingView : UIView

@property(nonatomic, strong) UIActivityIndicatorView *indicator;
@property(nonatomic, strong) UILabel *alertLabel;
@property(nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;

- (id)initWithFrame:(CGRect)frame superView:(UIView *)superView alertText:(NSString *)alertMessage fixedY:(CGFloat)fixedY activityIndicatorViewStyle:(UIActivityIndicatorViewStyle)indicatorStyle;

@end

@interface UIView (TFLoading)

@property(nonatomic, strong) TFLoadingView *loadingView;

-(void)showLoading;
-(void)showLoadingWithText:(NSString *)alertText;
-(void)showLoadingWithScrollViewFixed:(BOOL)shouldFixed alertText:(NSString *)alertText;
-(void)showLoadingWithScrollViewFixed:(BOOL)shouldFixed alertText:(NSString *)alertText activityIndicatorViewStyle:(UIActivityIndicatorViewStyle)indicatorStyle;
-(void)hideLoading;

@end
