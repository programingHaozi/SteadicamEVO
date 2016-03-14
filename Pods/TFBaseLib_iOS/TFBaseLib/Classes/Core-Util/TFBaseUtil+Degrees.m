//
//  TFBaseUtil+Degrees.m
//  TFBaseLib
//
//  Created by xiayiyong on 15/10/16.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TFBaseUtil+Degrees.h"

CGFloat tf_degreesToRadian(CGFloat degree)
{
    return [TFBaseUtil degreesToRadian:degree];
}

CGFloat tf_randianToDegrees(CGFloat radian)
{
    return [TFBaseUtil randianToDegrees:radian];
}

@implementation TFBaseUtil (Degrees)

+(CGFloat)degreesToRadian:(CGFloat)degree {
    return (M_PI * degree) / 180.0;
}

+(CGFloat)randianToDegrees:(CGFloat)radian {
    return (radian * 180.0) / M_PI;
}

@end
