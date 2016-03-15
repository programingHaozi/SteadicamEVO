//
//  UITableView+Extension.h
//  UITableViewReloadAnimation
//
//  Created by xiayiyong on 15/7/1.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TFReloadAnimationDirectionType)
{
    TFReloadAnimationDirectionLeft,
    TFReloadAnimationDirectionRight,
    TFReloadAnimationDirectionTop,
    TFReloadAnimationDirectionBottom,
};

@interface UITableView (ReloadAnimation)
- (void)reloadDataWithDirectionType:(TFReloadAnimationDirectionType)direction animationTime:(NSTimeInterval)animationTime interval:(NSTimeInterval)interval;
@end
