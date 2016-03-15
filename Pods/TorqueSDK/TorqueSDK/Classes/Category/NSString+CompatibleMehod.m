//
//  NSString+CompatibleMehod.m
//  TorqueSDK
//
//  Created by Gong Shuying 龚书英 on 15/8/24.
//  Copyright © 2015年 saike. All rights reserved.
//

#import "NSString+CompatibleMehod.h"

#import <UIKit/UIKit.h>

@implementation NSString (CompatibleMehod)
- (BOOL)containsStringDiffFromVersion:(NSString *)str
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        NSRange ran = [self rangeOfString:str];
        if((ran.location != NSNotFound) && (ran.length  >0))
        {
            return YES;
        }
    }
    else
    {
        return  [self containsString:str];
    }
    
    return NO;
}
@end
