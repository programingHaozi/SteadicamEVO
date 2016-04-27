//
//  UINavigationController+KMNavigationBarTransition.h
//
//  Copyright (c) 2016 Zhouqi Mo (https://github.com/MoZhouqi)
//

#import <UIKit/UIKit.h>

@interface UINavigationController (TFNavigationBarTransition)
// By default this is white, it is related to issue with transparent navigationBar
- (UIColor *)TF_containerViewBackgroundColor;
@end
