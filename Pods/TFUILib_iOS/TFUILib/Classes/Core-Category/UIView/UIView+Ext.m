//
//  UIView+Ext.m
//  UIViewExtension
//
//  Created by xiayiyong on 15/4/15.
//  Copyright (c) 2015年 xiayiyong. All rights reserved.
//

#import "UIView+Ext.h"
#import "UIView+Category.h"

@implementation UIView (Ext)

+ (CGRect)mainFrame
{
    return CGRectMake(0, 0, [[UIScreen mainScreen] applicationFrame].size.width, [[UIScreen mainScreen] applicationFrame].size.height - 20 - 44);
}

@end
