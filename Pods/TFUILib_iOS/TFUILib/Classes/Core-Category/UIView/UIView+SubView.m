//
//  UIView+SubView.m
//  TFBaseLib
//
//  Created by xiayiyong on 15/10/16.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "UIView+SubView.h"

@implementation UIView (SubView)

- (void)removeAllSubviews
{
    for (UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
}

- (UIView *)subViewWithTag:(int)tag
{
    for (UIView *v in self.subviews)
    {
        if (v.tag == tag)
        {
            return v;
        }
    }
    
    return nil;
}

@end
