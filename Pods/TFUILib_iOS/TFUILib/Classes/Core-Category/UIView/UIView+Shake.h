//
//  UIView+Shake.h
//  UIView+Shake
//
//  Created by xiayiyong on 15/7/1.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  震动方向
 */
typedef NS_ENUM(NSInteger, ShakeDirection) {
    /**
     *  水平震动
     */
    ShakeDirectionHorizontal = 0,
    /**
     *  竖直震动
     */
    ShakeDirectionVertical
};

@interface UIView (Shake)

- (void)shake;

- (void)shake:(int)times withDelta:(CGFloat)delta;

- (void)shake:(int)times withDelta:(CGFloat)delta completion:(void((^)()))handler;

- (void)shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval;

- (void)shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval completion:(void((^)()))handler;

- (void)shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(ShakeDirection)shakeDirection;

- (void)shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(ShakeDirection)shakeDirection completion:(void(^)(void))completion;

@end
