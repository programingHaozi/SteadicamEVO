//
//  UIViewController+Toast.m
//  TFUILib
//
//  Created by xiayiyong on 16/3/21.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "UIViewController+Toast.h"
#import "UIView+TFToast.h"

@implementation UIViewController (Toast)

#pragma mark loading

#pragma mark toast

- (void)showToast:(NSString*)text
{
    [self showToast:text duration:2.0 position:TFToastPositionTop];
}

- (void)showToast:(NSString*)text duration:(NSTimeInterval)duration position:(id)position
{
    [[UIApplication sharedApplication].keyWindow makeToast:text
                                                  duration:duration
                                                  position:position];
}

@end
