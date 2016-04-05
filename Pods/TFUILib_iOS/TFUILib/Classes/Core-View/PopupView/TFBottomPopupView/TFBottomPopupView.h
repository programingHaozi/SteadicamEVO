//
//  TFBottomPopupView.h
//  AFPopup
//
//  Created by Alvaro Franco on 3/7/14.
//  Copyright (c) 2014 xiayiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TFBottomPopupViewBlock)(void);

@interface TFBottomPopupView : UIView

- (instancetype)initWithPopupView:(UIView*)popupView andHeight:(CGFloat)height;

- (void)show;

- (void)hide;

@end
