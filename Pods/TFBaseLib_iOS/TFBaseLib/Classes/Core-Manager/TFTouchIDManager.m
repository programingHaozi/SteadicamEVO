//
//  TFTouchIDManager.m
//  TFTouchIDManager
//
//  Created by xiayiyong on 15/7/1.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFTouchIDManager.h"

@implementation TFTouchIDManager

+ (BOOL)checkTouch;
{
    //初始化上下文对象
    LAContext* context = [[LAContext alloc] init];
    
    //错误对象
    NSError* error = nil;
    
    //首先使用canEvaluatePolicy 判断设备支持状态
    BOOL result=[context canEvaluatePolicy: LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    return result;
}

+ (void)startTouchIDWithMessage:(NSString *)localizedReason
                  fallbackTitle:(NSString *)fallbackTitle
                         succes:(void(^)())successBlock
                        failure:(TouchIdValidationFailureBack)failureBlock
{
    //初始化上下文对象
    LAContext* context = [[LAContext alloc] init];
    context.localizedFallbackTitle = fallbackTitle;
    
    //错误对象
    NSError* error = nil;
    
    //首先使用canEvaluatePolicy 判断设备支持状态
   if ([context canEvaluatePolicy: LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error])
   {
       //支持指纹验证
       [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
               localizedReason:localizedReason
                         reply:
        ^(BOOL succes, NSError *error) {
            if (succes)
            {
                //NSLog(@"验证成功");
                dispatch_async(dispatch_get_main_queue(), ^{
                    successBlock(succes);
                });
                
            }
            else
            {
                //NSLog(@"验证失败");
                //NSLog(@"%@",error.localizedDescription);
                dispatch_async(dispatch_get_main_queue(), ^{
                    failureBlock(error.code,error.localizedDescription);
                });
            }
        }];
   }
   else
   {
      // NSLog(@"不支持指纹识别，LOG出错误详情");
      // NSLog(@"%@",error.localizedDescription);
       dispatch_async(dispatch_get_main_queue(), ^{
           failureBlock(error.code,error.localizedDescription);
       });
   }
}

@end
