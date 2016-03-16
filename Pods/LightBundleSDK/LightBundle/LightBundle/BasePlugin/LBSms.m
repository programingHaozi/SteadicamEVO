//
//  LBSms.m
//  LightBundle
//
//  Created by Hu Dan 胡丹 on 15/11/3.
//  Copyright © 2015年 Ren Wenchao 任文超. All rights reserved.
//

#import "LBSms.h"
#import <MessageUI/MessageUI.h>

@interface LBSms()<MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic,retain)NSArray *phones;
@property (nonatomic,retain)NSString *title;
@property (nonatomic,retain)NSString *body;

@end

@implementation LBSms

/**
 *  发送短信
 *
 *  @param phones 电话
 *  @param title  标题
 *  @param body   内容
 */
- (void)jsCallFunction
{
    self.phones = @[[self.paramers objectForKey:LB_RET_TEL]];
    self.title = @"";
    self.body = [self.paramers objectForKey:LB_RET_TEXT];
    if ([MFMessageComposeViewController canSendText] && !LB_SIMULATOR) {
        [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
        if (self.navigationBarBgImage)
        {
            [[UINavigationBar appearance] setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
        }
        if (self.navigationBarShadowImage)
        {
            [[UINavigationBar appearance] setShadowImage:nil];
        }
        
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = self.phones;
        controller.body = self.body;
        controller.delegate = self;
        controller.messageComposeDelegate = self;
        if (self.viewController)
        {
            [self.viewController presentViewController:controller animated:YES completion:nil];
        }
        else
        {
            [[UINavigationBar appearance] setBarTintColor:self.navBgColor];
            [self callbackJsSdk:@"" errorCode:LBErrorCodeFail msg:kLBMsgSmsFail];
            [self alertNoVc];
        }
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], UITextAttributeTextColor, [UIFont systemFontOfSize:18], UITextAttributeFont, nil];
        [controller.navigationBar setTitleTextAttributes:attributes];
        [controller.navigationBar setTintColor:COLOR_SYSTEM_DEFAULT];
        //修改短信界面标题
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:_title];
    }
    else
    {
        [self showAlert:@"当前系统版本不支持应用内发送短信功能"];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    if (controller)
    {
        [self.viewController dismissViewControllerAnimated:YES completion:nil];
    }
    
    [[UINavigationBar appearance] setBarTintColor:self.navBgColor];
    if (self.navigationBarBgImage)
    {
        [[UINavigationBar appearance] setBackgroundImage:self.navigationBarBgImage forBarMetrics:UIBarMetricsDefault];
    }
    if (self.navigationBarShadowImage)
    {
        [[UINavigationBar appearance] setShadowImage:self.navigationBarShadowImage];
    }
    
    switch (result)
    {
            // 发送短信成功
        case MessageComposeResultSent:
        {
            [self callbackJsSdk:@"" errorCode:LBErrorCodeSuccess msg:kLBMsgSmsSuccess];
            break;
        }
            // 发送短信失败
        case MessageComposeResultFailed:
        {
            [self callbackJsSdk:@"" errorCode:LBErrorCodeFail msg:kLBMsgSmsFail];
            break;
        }
            // 取消发送短信
        case MessageComposeResultCancelled:
        {
            [self callbackJsSdk:@"" errorCode:LBErrorCodeCancel msg:kLBMsgSmsCancel];
            break;
        }
        default:
        {
            break;
        }
    }
}

@end
