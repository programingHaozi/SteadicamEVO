//
//  UIView+Toast.m
//  Toast
//
//  Copyright 2014 Charles Scalesse.
//

#import "UIView+TFToast.h"
#import "TFToast.h"

@implementation UIView(TFToast)

#pragma mark toast

- (void)showToast:(NSString*)text
{
    [TFToast showWithText:text duration:2.5 atView:self];
}

- (void)showToastWithText:(NSString*)text
{
    [TFToast showWithText:text duration:2.5 atView:self];
}

@end
