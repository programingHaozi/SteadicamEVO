//
//  TFHud.h
//  TFHud
//
//  Created by xiayiyong on 15-5-27.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  HUD类型
 */
typedef NS_ENUM(NSUInteger, TFHudType) {
    /**
     *  只有文字
     */
    kHudTypeText,
    /**
     *  只有进度
     */
    kHudTypeProgress,
    /**
     *  只有loading
     */
    kHudTypeLoading,
    /**
     *  loading和text
     */
    kHudTypeLoadingText
};

/**
 *  文字和loading相对位置
 */
typedef NS_ENUM(NSUInteger, TFTextPositionType) {
    /**
     *  位子居左
     */
    kTextPositionTypeLeft,
    /**
     *  文字居上
     */
    kTextPositionTypeTop,
    /**
     *  文字居右
     */
    kTextPositionTypeRight,
    /**
     *  文字居下
     */
    kTextPositionTypeBottom,
    /**
     *  文字居中
     */
    kTextPositionTypeCenter
};

/**
 *  动画类型
 */
typedef NS_ENUM(NSUInteger, TFHudAnimatedType) {
    /**
     *  无动画
     */
    kHudAnimatedTypeNone,
    /**
     *  从左
     */
    kHudAnimatedTypeLeft,
    /**
     *  从上
     */
    kHudAnimatedTypeTop,
    /**
     *  从右
     */
    kHudAnimatedTypeRight,
    /**
     *  从下
     */
    kHudAnimatedTypeBottom,
    /**
     *  。。。
     */
    kHudAnimatedTypeChangeGradually,
};

typedef void (^TFHudBlock)();


@interface TFHudProgress : NSObject

/**
 *  总大小
 */
@property (nonatomic,assign) long long fileLength;

/**
 *  已完成
 */
@property (nonatomic,assign) long long loadedLength;

@end

@interface TFHud : UIView

@property (nonatomic,strong) UIColor *loadingBackColor;
@property (nonatomic,strong) UIColor *loadingForeColor;

/**
 *  下载进度，有两个属性，文件长度和分段长度
 */
@property (nonatomic,strong) TFHudProgress *progress;

/**
 *  文字与图的间隙
 */
@property (nonatomic,assign) CGFloat gap;

/**
 *  文字颜色
 */
@property (nonatomic,strong) UIColor *textColor;

/**
 *  文字字体
 */
@property (nonatomic,assign) CGFloat textFont;

/**
 *  显示text
 *
 *  @param text 文字内容
 *  @param view 父窗口
 */
+ (void)showWithText:(NSString *)text atView:(UIView *)view;

/**
 *  显示进度
 *
 *  @param progress 进度
 *  @param view     父窗口
 */
+ (void)showWithProgress:(TFHudProgress *)progress atView:(UIView *)view;

/**
 *  显示loading和text
 *
 *  @param text         文字
 *  @param view
 *  @param positionType 文字位置
 */
+ (void)showLoadingWithText:(NSString *)text textPosition:(TFTextPositionType)positionType atView:(UIView *)view;

/**
 *  显示loading
 *
 *  @param view 父窗口
 */
+ (void)showLoadingAtView:(UIView *)view;

/**
 *  移除活动视图
 *
 *  @param view 父窗口
 */
+ (void)hideInView:(UIView *)view;

@end
