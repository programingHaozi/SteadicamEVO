//
//  Created by xiayiyong on 16/3/30.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFView.h"

typedef enum : NSUInteger
{
    kCenterPopupViewAnimateNone = 0,//无动画
    kCenterPopupViewAnimateSpring = 1,//弹性动画
    kCenterPopupViewAnimateFade = 2,
} TFCenterPopupViewAnimateType;

typedef void (^TFCenterPopupViewBlock)(void);

@interface TFCenterPopupView : UIView

/**
 *  初始化
 *
 *  @param popupView 要显示的视图
 *
 *  @return 
 */
- (instancetype)initWithPopupView:(UIView*)popupView;

/**
 *  显示视图
 *
 *  @param ani 是否带动画
 */
- (void)showWithAnimate:(TFCenterPopupViewAnimateType)type;

/**
 *  显示视图
 */
- (void)show;

/**
 *  隐藏视图
 */
- (void)hide;

@end

