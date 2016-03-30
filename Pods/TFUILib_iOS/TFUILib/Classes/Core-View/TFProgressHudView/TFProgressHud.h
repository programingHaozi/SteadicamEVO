//
//  TFProgressHud.h
//  TFProgressHud
//
//  Created by AQ on 15-5-27.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFProgressObject.h"

typedef NS_ENUM(NSUInteger, HudType)
{
    HudTypeHud,
    HudTypeProgress,
    HudTypeLoading,
    HudTypeLoadingText
};

typedef NS_ENUM(NSUInteger, TextPositionType)
{
    TextPositionTypeLeft,
    TextPositionTypeTop,
    TextPositionTypeRight,
    TextPositionTypeBottom,
    TextPositionTypeCenter
};

typedef NS_ENUM(NSUInteger, ImagePositionType)
{
    ImagePositionTypeLeft,
    ImagePositionTypeTop,
    ImagePositionTypeRight,
    ImagePositionTypeBottom,
    ImagePositionTypeCenter
};

typedef NS_ENUM(NSUInteger, HudAnimatedType)
{
    HudAnimatedTypeNone,
    HudAnimatedTypeLeft,
    HudAnimatedTypeTop,
    HudAnimatedTypeRight,
    HudAnimatedTypeBottom,
    HudAnimatedTypeChangeGradually,
};

typedef void (^TFProgressHudBlock)();

@interface TFProgressHud : UIView

@property (nonatomic,strong) UIColor *loadingBackColor;
@property (nonatomic,strong) UIColor *loadingForeColor;

/**
 *  下载进度，有两个属性，文件长度和分段长度
 */
@property (nonatomic,strong) TFProgressObject *progress;

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *subTitle;

/**
 *  文字与图的间隙
 */
@property (nonatomic,assign) CGFloat gap;
@property (nonatomic,strong) UIColor *loadingTextColor;
@property (nonatomic,assign) CGFloat textFont;

//显示下载进度
+ (void)showProgress:(UIView *)view withObject:(TFProgressObject *)obj;

//展示一个带loading视图
+ (void)showLoadingHud:(UIView *)view animated:(HudAnimatedType)animatedType;

//展示一个带文字的loading视图
+ (void)showLoadingHud:(UIView *)view withText:(NSString *)text textPosition:(TextPositionType)positionType animated:(HudAnimatedType)animatedType;

//展示文本视图
+ (void)showHud:(UIView *)view title:(NSString *)title animated:(HudAnimatedType)animtedType;

//移除活动视图
+ (void)hideAllHudInView:(UIView *)view animated:(HudAnimatedType)animatedType;

@end
