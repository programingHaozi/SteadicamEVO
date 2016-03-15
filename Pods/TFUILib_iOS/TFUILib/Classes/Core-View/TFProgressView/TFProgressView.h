//
//  TFProgressView.h
//  TFUILib
//
//  Created by 张国平 on 16/3/9.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFProgressView : UIView

@property (nonatomic) float progress;

/**
 *  进度条view
 */
@property (nonatomic) UIView *progressBarView;

/**
 *  进度条更新的动画持续时间 默认0.27f
 */
@property (nonatomic) NSTimeInterval barAnimationDuration;

/**
 *  进度条加载完颜色褪去的动画时间 默认0.27f
 */
@property (nonatomic) NSTimeInterval fadeAnimationDuration;

/**
 *  褪去动画的延时时间 默认0.1f
 */
@property (nonatomic) NSTimeInterval fadeOutDelay;

/**
 *  初始化
 *
 *  @param frame frame大小
 *  @param color 进度条的颜色
 *
 *  @return 返回的progressview
 */
- (instancetype)initWithFrame:(CGRect)frame color:(UIColor *)color;

/**
 *  设置progressView的进度
 *
 *  @param progress 进度值0——1之间
 *  @param animated 是否需要动画
 */
- (void)setProgress:(float)progress animated:(BOOL)animated;


@end
