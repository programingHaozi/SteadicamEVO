//
//  TFImageLoopView.h
//  TFImageLoopView
//
//  Created by aier on 15-3-22.
//  Copyright (c) 2015年 GSD. All rights reserved.
//  https://github.com/gsdios/SDCycleScrollView
//

#import <UIKit/UIKit.h>

/**
 *  PageContol位置
 */
typedef NS_ENUM(NSUInteger, TFImageLoopViewPageContolAliment)
{
    /**
     *  右边位置
     */
    TFImageLoopViewPageContolAlimentRight,
    /**
     *  中间位置
     */
    TFImageLoopViewPageContolAlimentCenter
};

/**
 *  PageContol样式
 */
typedef NS_ENUM(NSUInteger, TFImageLoopViewPageContolStyle)
{
    /**
     *  系统自带经典样式
     */
    TFImageLoopViewPageContolStyleClassic,
    /**
     *  动画效果
     */
    TFImageLoopViewPageContolStyleAnimated,
    /**
     *  不显示pagecontrol
     */
    TFImageLoopViewPageContolStyleNone
};

@class TFImageLoopView;

@protocol TFImageLoopViewDelegate <NSObject>

@optional

/**
 *  点击图片回调
 *
 *  @param cycleScrollView TFImageLoopView
 *  @param index           图片Index
 */
- (void)imageLoopView:(TFImageLoopView *)loopView
   didSelectItemAtIndex:(NSInteger)index;

/**
 *  图片滚动回调
 *
 *  @param cycleScrollView TFImageLoopView
 *  @param index           图片Index
 */
- (void)imageLoopView:(TFImageLoopView *)loopView
       didScrollToIndex:(NSInteger)index;

@end

@interface TFImageLoopView : UIView

/**
 *  每张图片对应要显示的image数组
 */
@property (nonatomic, strong) NSArray *imagesGroup;

/**
 *  每张图片对应要显示的文字数组
 */
@property (nonatomic, strong) NSArray *titlesGroup;

/**
 *  自动滚动间隔时间,默认2s
 */
@property (nonatomic, assign) CGFloat autoScrollTimeInterval;

/**
 *  是否无限循环,默认Yes
 */
@property(nonatomic,assign) BOOL infiniteLoop;

/**
 *  是否自动滚动,默认Yes
 */
@property(nonatomic,assign) BOOL autoScroll;

/**
 *  delegate
 */
@property (nonatomic, weak) id<TFImageLoopViewDelegate> delegate;

/**
 *  block监听点击方式
 */
@property (nonatomic, copy) void (^clickItemOperationBlock)(NSInteger currentIndex);

/**
 *  轮播图片的ContentMode，默认为 UIViewContentModeScaleToFill
 */
@property (nonatomic, assign) UIViewContentMode bannerImageViewContentMode;

/**
 *  占位图，用于网络未加载到图片时
 */
@property (nonatomic, strong) UIImage *placeholderImage;

/**
 *  是否显示分页控件
 */
@property (nonatomic, assign) BOOL showPageControl;

/**
 *  是否在只有一张图时隐藏pagecontrol，默认为YES
 */
@property(nonatomic) BOOL hidesForSinglePage;

/**
 *  pagecontrol 样式，默认为动画样式
 */
@property (nonatomic, assign) TFImageLoopViewPageContolStyle pageControlStyle;

/**
 *  分页控件位置
 */
@property (nonatomic, assign) TFImageLoopViewPageContolAliment pageControlAliment;

/**
 *  分页控件小圆标大小
 */
@property (nonatomic, assign) CGSize pageControlDotSize;

/**
 *  当前分页控件小圆标颜色
 */
@property (nonatomic, strong) UIColor *currentPageDotColor;

/**
 *  其他分页控件小圆标颜色
 */
@property (nonatomic, strong) UIColor *pageDotColor;

/**
 *  当前分页控件小圆标图片
 */
@property (nonatomic, strong) UIImage *currentPageDotImage;

/**
 *  其他分页控件小圆标图片
 */
@property (nonatomic, strong) UIImage *pageDotImage;

/**
 *  分页控件位置
 */
@property (nonatomic, assign) float pageControlDistanceFormBottom;

/**
 *  轮播文字label字体颜色
 */
@property (nonatomic, strong) UIColor *titleLabelTextColor;

/**
 *  轮播文字label字体大小
 */
@property (nonatomic, strong) UIFont  *titleLabelTextFont;

/**
 *  轮播文字label背景颜色
 */
@property (nonatomic, strong) UIColor *titleLabelBackgroundColor;

/**
 *  轮播文字label高度
 */
@property (nonatomic, assign) CGFloat titleLabelHeight;

/**
 *  初始轮播图（推荐使用）
 *
 *  @param frame            轮播视图大小
 *  @param delegate         代理
 *  @param placeholderImage 占位图片
 *
 *  @return 轮播视图
 */
+ (instancetype)loopViewWithFrame:(CGRect)frame
                     delegate:(id<TFImageLoopViewDelegate>)delegate
             placeholderImage:(UIImage *)placeholderImage;

/**
 *  初始化轮播图
 *
 *  @param frame       轮播视图大小
 *  @param imagesGroup 图片数组
 *
 *  @return 轮播视图
 */
+ (instancetype)loopViewWithFrame:(CGRect)frame imagesGroup:(NSArray *)imagesGroup;

/**
 *  初始化轮播图
 *
 *  @param frame        轮播图大小
 *  @param imagesGroup  图片数组
 *  @param infiniteLoop 是否无限循环
 *
 *  @return 轮播视图
 */
+ (instancetype)loopViewWithFrame:(CGRect)frame
                  imagesGroup:(NSArray *)imagesGroup
           shouldInfiniteLoop:(BOOL)infiniteLoop;

/**
 *  清除图片缓存（此次升级后统一使用SDWebImage管理图片加载和缓存）
 */
+ (void)clearImagesCache;

/**
 *  清除图片缓存（兼容旧版本方法）
 */
- (void)clearCache;

@end
