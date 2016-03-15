//
//  UIView+SuperView.m
//  HBToolkit
//
//  Created by xiayiyong on 15/7/1.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "UIView+SuperView.h"

@implementation UIView (SuperView)

- (UIView *)superViewWithClass:(Class)superViewClass
{
    
    UIView *superView      = self.superview;
    UIView *foundSuperView = nil;
    
    while (nil != superView && nil == foundSuperView)
    {
        if ([superView isKindOfClass:superViewClass])
        {
            foundSuperView = superView;
        }
        else
        {
            superView = superView.superview;
        }
    }
    
    return foundSuperView;
}

@end
