//
//  LBTel.m
//  LightBundle
//
//  Created by Hu Dan 胡丹 on 15/11/3.
//  Copyright © 2015年 Ren Wenchao 任文超. All rights reserved.
//

#import "LBTel.h"

@interface LBTel()<UIAlertViewDelegate>

@property (nonatomic,retain)NSString *phone;

@end

@implementation LBTel

/**
 *  打电话
 */
- (void)jsCallFunction
{
    _phone = [self.paramers objectForKey:LB_RET_TEXT];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:[NSString stringWithFormat:@"是否拨打%@",_phone]
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"呼叫", nil];
    [alert show];
}

/**
 *  alert view delegate
 *
 *  @param alertView
 *  @param buttonIndex index
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", _phone]]];
        [self callbackJsSdk:@"" errorCode:LBErrorCodeSuccess msg:kLBMsgTelSuccess];
    }
    else
    {
        [self callbackJsSdk:@"" errorCode:LBErrorCodeCancel msg:kLBMsgTelCancel];
    }
}

@end
