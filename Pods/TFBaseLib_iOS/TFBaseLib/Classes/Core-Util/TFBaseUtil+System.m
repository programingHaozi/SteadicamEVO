//
//  TFBaseUtil+System.m
//  TFBaseLib
//
//  Created by xiayiyong on 15/10/16.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFBaseUtil+System.h"
#import <UIKit/UIKit.h>

NSInteger tf_iOSVersion(void)
{
    return [TFBaseUtil iOSVersion];
}

BOOL tf_isiPad(void)
{
    return [TFBaseUtil isiPad];
}

BOOL tf_isiPhone(void)
{
    return [TFBaseUtil isiPhone];
}

BOOL tf_isRetina(void)
{
    return [TFBaseUtil isRetina];
}

BOOL tf_isRetinaHD(void)
{
    return [TFBaseUtil isRetinaHD];
}

BOOL tf_isLandscape(void)
{
    return [TFBaseUtil isLandscape];
}

@implementation TFBaseUtil (System)

+ (NSInteger)iOSVersion
{
    return [[[UIDevice currentDevice] systemVersion] integerValue];
}

+ (BOOL)isiPad
{
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad;
}

+ (BOOL)isiPhone
{
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone;
}

+ (BOOL)isRetina
{
    return [[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)]
    && ([UIScreen mainScreen].scale == 2.0 || [UIScreen mainScreen].scale == 3.0);
}

+ (BOOL)isRetinaHD
{
    return [[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)]
    && ([UIScreen mainScreen].scale == 3.0);
}

+ (BOOL)isLandscape
{
    return (UIInterfaceOrientationIsLandscape \
            ([[UIApplication sharedApplication] statusBarOrientation]));
}

@end
