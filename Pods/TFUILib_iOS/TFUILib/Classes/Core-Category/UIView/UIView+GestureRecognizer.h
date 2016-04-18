//
//  UIView+GestureRecognizer.h
//  KBDropdownController
//
//  Created by Jing Dai on 6/8/15.
//  Copyright (c) 2015 daijing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GestureRecognizer)

- (void)setTapGestureWithBlock:(void (^)(void))block;

@end
