//
//  UIView+Animation.h
//  StringDemo
//
//  Created by xiayiyong on 15/7/1.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuartzCore/QuartzCore.h"

@interface UIView (Animation)

//揭开
+ (void)animationReveal:(UIView *)view direction:(NSString *)direction;

//渐隐渐消
+ (void)animationFade:(UIView *)view;

//翻转
+ (void)animationFlip:(UIView *)view direction:(NSString *)direction;

//旋转缩放
+ (void)animationRotateAndScaleEffects:(UIView *)view;//各种旋转缩放效果。
+ (void)animationRotateAndScaleDownUp:(UIView *)view;//旋转同时缩小放大效果

//push
+ (void)animationPush:(UIView *)view direction:(NSString *)direction;

//Curl UnCurl
+ (void)animationCurl:(UIView *)view direction:(NSString *)direction;
+ (void)animationUnCurl:(UIView *)view direction:(NSString *)direction;

//Move
+ (void)animationMove:(UIView *)view direction:(NSString *)direction;

//立方体
+ (void)animationCube:(UIView *)view direction:(NSString *)direction;

//水波纹
+ (void)animationRippleEffect:(UIView *)view;

//相机开合
+ (void)animationCameraEffect:(UIView *)view type:(NSString *)type;

//吸收
+ (void)animationSuckEffect:(UIView *)view;

+ (void)animationBounceOut:(UIView *)view;
+ (void)animationBounceIn:(UIView *)view;
+ (void)animationBounce:(UIView *)view;


/**
 *  添加抖动效果
 */
- (void)shakeView;

/**
 * 添加放大后又缩小的动画
 */
- (void)addScaleAnimationWithCompletion:(void(^)(void))completion;
- (void)addScaleAnimation:(CGPoint)scale completion:(void(^)(void))completion;

/**
 * 添加压下的动画
 */
- (void)addDownAnimationWithCompletion:(void(^)(void))completion;
- (void)addDownAnimation:(CGPoint)scale completion:(void(^)(void))completion;

/**
 * 添加淡入淡出的动画
 */
- (void)fadeWithDuration:(NSTimeInterval)duration;
+ (void)fadeInWithView:(UIView *)fadeView duration:(NSTimeInterval)duration;

- (void)crossfadeWithDuration:(NSTimeInterval)duration;
- (void)crossfadeWithDuration:(NSTimeInterval)duration completion:(void (^)(void))completion;

@end
