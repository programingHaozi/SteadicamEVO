//
//  UIView+Capture.m
//  TFUILib
//
//  Created by xiayiyong on 15/10/29.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "UIView+Capture.h"

@implementation UIView (Capture)

- (UIImage *)captureScreenshot
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    
    // after ios 7
    if ([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
    {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                    [self methodSignatureForSelector:
                                     @selector(drawViewHierarchyInRect:afterScreenUpdates:)]];
        [invocation setTarget:self];
        [invocation setSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)];
        CGRect arg2 = self.bounds;
        BOOL arg3 = YES;
        [invocation setArgument:&arg2 atIndex:2];
        [invocation setArgument:&arg3 atIndex:3];
        [invocation invoke];
    }
    else
    { // before ios 7
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshot;
}

- (UIImage *)takeScreenshot
{
    BOOL ignoreOrientation = ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0);
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    CGSize imageSize = CGSizeZero;
    if (UIInterfaceOrientationIsPortrait(orientation) || ignoreOrientation)
    {
        imageSize = [UIScreen mainScreen].bounds.size;
    }
    else
    {
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height,
                               [UIScreen mainScreen].bounds.size.width);
    }
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, self.center.x, self.center.y);
    CGContextConcatCTM(context, self.transform);
    CGContextTranslateCTM(context, -self.bounds.size.width * self.layer.anchorPoint.x, -self.bounds.size.height * self.layer.anchorPoint.y);
    
    // Correct for the screen orientation
    if(!ignoreOrientation)
    {
        if(orientation == UIInterfaceOrientationLandscapeLeft)
        {
            CGContextRotateCTM(context, (CGFloat)M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        }
        else if(orientation == UIInterfaceOrientationLandscapeRight)
        {
            CGContextRotateCTM(context, (CGFloat)-M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        }
        else if(orientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            CGContextRotateCTM(context, (CGFloat)M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
    }
    
    if([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
    {
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    }
    else
    {
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    
    CGContextRestoreGState(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
