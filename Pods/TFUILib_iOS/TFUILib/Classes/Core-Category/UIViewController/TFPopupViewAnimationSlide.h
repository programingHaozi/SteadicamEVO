//
//  TFPopupViewAnimationSlide.h
//  TFPopupViewController
//
//  Created by xiayiyong on 15/3/5.
//  Copyright (c) 2015年 xiayiyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIViewController+TFPopupViewController.h"

typedef NS_ENUM(NSUInteger, TFPopupViewAnimationSlideType) {
    TFPopupViewAnimationSlideTypeBottomTop,
    TFPopupViewAnimationSlideTypeBottomBottom,
    TFPopupViewAnimationSlideTypeTopTop,
    TFPopupViewAnimationSlideTypeTopBottom,
    TFPopupViewAnimationSlideTypeLeftLeft,
    TFPopupViewAnimationSlideTypeLeftRight,
    TFPopupViewAnimationSlideTypeRightLeft,
    TFPopupViewAnimationSlideTypeRightRight,
};

@interface TFPopupViewAnimationSlide : NSObject<TFPopupAnimation>

@property (nonatomic,assign)TFPopupViewAnimationSlideType type;

@end
