//
//  TFLoopScrollView.h
//  TFLoopScrollView
//
//  Created by aier on 15-3-22.
//  Copyright (c) 2015年 GSD. All rights reserved.
//  https://github.com/gsdios/SDCycleScrollView
//

#import <UIKit/UIKit.h>

typedef enum {
    TFLoopScrollViewPageContolAlimentRight,
    TFLoopScrollViewPageContolAlimentCenter
} TFLoopScrollViewPageContolAliment;

typedef enum {
    TFLoopScrollViewPageContolStyleClassic,        // 系统自带经典样式
    TFLoopScrollViewPageContolStyleAnimated,       // 动画效果pagecontrol
    TFLoopScrollViewPageContolStyleNone            // 不显示pagecontrol
} TFLoopScrollViewPageContolStyle;

@class TFLoopScrollView;

@protocol TFLoopScrollViewDelegate <NSObject>

@optional

/** 点击图片回调 */
- (void)cycleScrollView:(TFLoopScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;

/** 图片滚动回调 */
- (void)cycleScrollView:(TFLoopScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index;

@end

@interface TFLoopScrollView : UIView



//** 每张图片对应要显示的image数组 */

@property (nonatomic, strong) NSArray *imagesGroup;

/** 每张图片对应要显示的文字数组 */
@property (nonatomic, strong) NSArray *titlesGroup;



// >>>>>>>>>>>>>>>>>>>>>>>>>  滚动控制接口

/** 自动滚动间隔时间,默认2s */
@property (nonatomic, assign) CGFloat autoScrollTimeInterval;

/** 是否无限循环,默认Yes */
@property(nonatomic,assign) BOOL infiniteLoop;

/** 是否自动滚动,默认Yes */
@property(nonatomic,assign) BOOL autoScroll;

@property (nonatomic, weak) id<TFLoopScrollViewDelegate> delegate;

/** block监听点击方式 */
@property (nonatomic, copy) void (^clickItemOperationBlock)(NSInteger currentIndex);


// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  自定义样式接口

/** 轮播图片的ContentMode，默认为 UIViewContentModeScaleToFill */
@property (nonatomic, assign) UIViewContentMode bannerImageViewContentMode;

/** 占位图，用于网络未加载到图片时 */
@property (nonatomic, strong) UIImage *placeholderImage;



/** 是否显示分页控件 */
@property (nonatomic, assign) BOOL showPageControl;

/** 是否在只有一张图时隐藏pagecontrol，默认为YES */
@property(nonatomic) BOOL hidesForSinglePage;

/** pagecontrol 样式，默认为动画样式 */
@property (nonatomic, assign) TFLoopScrollViewPageContolStyle pageControlStyle;

/** 分页控件位置 */
@property (nonatomic, assign) TFLoopScrollViewPageContolAliment pageControlAliment;

/** 分页控件小圆标大小 */
@property (nonatomic, assign) CGSize pageControlDotSize;

/** 当前分页控件小圆标颜色 */
@property (nonatomic, strong) UIColor *currentPageDotColor;

/** 其他分页控件小圆标颜色 */
@property (nonatomic, strong) UIColor *pageDotColor;

/** 当前分页控件小圆标图片 */
@property (nonatomic, strong) UIImage *currentPageDotImage;

/** 其他分页控件小圆标图片 */
@property (nonatomic, strong) UIImage *pageDotImage;

// 分页控件位置
@property (nonatomic, assign) float pageControlDistanceFormBottom;


/** 轮播文字label字体颜色 */
@property (nonatomic, strong) UIColor *titleLabelTextColor;

/** 轮播文字label字体大小 */
@property (nonatomic, strong) UIFont  *titleLabelTextFont;

/** 轮播文字label背景颜色 */
@property (nonatomic, strong) UIColor *titleLabelBackgroundColor;

/** 轮播文字label高度 */
@property (nonatomic, assign) CGFloat titleLabelHeight;


/** 初始轮播图（推荐使用） */
+ (instancetype)initWithFrame:(CGRect)frame delegate:(id<TFLoopScrollViewDelegate>)delegate placeholderImage:(UIImage *)placeholderImage;

+ (instancetype)initWithFrame:(CGRect)frame imagesGroup:(NSArray *)imagesGroup;

+ (instancetype)initWithFrame:(CGRect)frame imagesGroup:(NSArray *)imagesGroup shouldInfiniteLoop:(BOOL)infiniteLoop;

// >>>>>>>>>>>>>>>>>>>>>>>>>  清除缓存接口

/** 清除图片缓存（此次升级后统一使用SDWebImage管理图片加载和缓存）  */
+ (void)clearImagesCache;

/** 清除图片缓存（兼容旧版本方法） */
- (void)clearCache;

@end
