//
//  LBToast.m
//  LightBundle
//
//  Created by Hu Dan 胡丹 on 15/11/3.
//  Copyright © 2015年 Ren Wenchao 任文超. All rights reserved.
//

#import "LBToast.h"
#import "LBUIView+Toast.h"

@implementation LBToast

/**
 *  toast
 *
 */
- (void)jsCallFunction
{
    if (self.viewController)
    {
        UIView *toastView = [self.viewController.view toastForMessage:[self.paramers objectForKey:LB_RET_TEXT] oldToast:[self.viewController.view viewWithTag:LBGrapeToastTag]];
        [self.viewController.view insertSubview:toastView atIndex:2];
        [self.viewController.view showToast:toastView];
        [self callbackJsSdk:@"" errorCode:LBErrorCodeSuccess msg:kLBMsgToastSuccess];
    }
    else
    {
        [self alertNoVc];
    }
}


@end
