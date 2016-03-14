//
//  LGProgressHud.h
//  LGProgressHud
//
//  Created by AQ on 15-5-27.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGProgressObject.h"

typedef enum{
    HudTypeHud,
    HudTypeProgress,
    HudTypeLoading,
    HudTypeLoadingText
}HudType;

typedef enum{
    TextPositionTypeLeft,
    TextPositionTypeTop,
    TextPositionTypeRight,
    TextPositionTypeBottle,
    TextPositionTypeCentre
    
}TextPositionType;

typedef enum{
    ImagePositionTypeLeft,
    ImagePositionTypeTop,
    ImagePositionTypeRight,
    ImagePositionTypeBottle,
    ImagePositionTypeCentre
    
}ImagePositionType;

typedef enum{
    HudAnimatedTypeNone,
    HudAnimatedTypeLeft,
    HudAnimatedTypeTop,
    HudAnimatedTypeRight,
    HudAnimatedTypeBottle,
    HudAnimatedTypeChangeGradually,
//    HudAnimatedTypeScaleBigger,
//    HudAnimatedTypeScaleSmaller,
//    HudAnimatedTypeFade
    
}HudAnimatedType;

typedef void (^LGProgressHudBlock)();

@interface LGProgressHud : UIView

@property (nonatomic,strong) UIColor *loadingBackColor;
@property (nonatomic,strong) UIColor *loadingForeColor;

//下载进度，有两个属性，文件长度和分段长度
@property (nonatomic,strong) LGProgressObject *progress;

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *subTitle;
//文字与图的间隙
@property (nonatomic,assign) CGFloat gap;
@property (nonatomic,strong) UIColor *loadingTextColor;
@property (nonatomic,assign) CGFloat textFont;

//显示下载进度
+ (void)showProgress:(UIView *)view withObject:(LGProgressObject *)obj;

//单纯展示一个活动视图
+ (void)showLoadingHud:(UIView *)view animated:(HudAnimatedType)animatedType;
//展示一个带文字的活动视图，文字不宜过长
+ (void)showLoadingHud:(UIView *)view withText:(NSString *)text textPosition:(TextPositionType)positionType animated:(HudAnimatedType)animatedType;


//结果视图，展示文本，规定时间过后消失
+ (void)showHud:(UIView *)view title:(NSString *)title animated:(HudAnimatedType)animtedType;


//+ (void)showHud:(UIView *)view title:(NSString *)title duration:(NSTimeInterval)time animated:(HudAnimatedType)animtedType;

//+ (void)showHud:(UIView *)view title:(NSString *)title subTitle:(NSString *)subTitle duration:(NSTimeInterval)time animated:(HudAnimatedType)animtedType;

//+ (void)showHud:(UIView *)view title:(NSString *)title image:(UIImage *)image imagePosition:(ImagePositionType)position duration:(NSTimeInterval)time animated:(HudAnimatedType)animtedType;

//移除活动视图
+ (void)hideAllHudInView:(UIView *)view animated:(HudAnimatedType)animatedType;

@end
