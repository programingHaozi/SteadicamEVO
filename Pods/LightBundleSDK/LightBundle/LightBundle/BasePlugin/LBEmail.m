//
//  LBEmail.m
//  LightBundle
//
//  Created by Hu Dan 胡丹 on 15/11/3.
//  Copyright © 2015年 Ren Wenchao 任文超. All rights reserved.
//

#import "LBEmail.h"
#import <MessageUI/MessageUI.h>

@interface LBEmail()<MFMailComposeViewControllerDelegate,
                     UINavigationControllerDelegate>

@property (nonatomic,retain)NSArray *arrayToRecipient;
@property (nonatomic,retain)NSArray *arrayCCRecipient;
@property (nonatomic,retain)NSString *title;
@property (nonatomic,retain)NSString *content;

@end

@implementation LBEmail

/**
 *  发送邮件
 *
 *  @param arrayToRecipient 发送人数组
 *  @param arrayCCRecipient 抄送人数组
 *  @param title            邮件主题
 *  @param content          邮件内容 (html字符串)
 */
- (void)jsCallFunction
{
    _arrayToRecipient = [self.paramers objectForKey:LB_RET_RECEIVER];
    _arrayCCRecipient = [self.paramers objectForKey:LB_RET_CC];
    _title = [self.paramers objectForKey:LB_RET_TITLE];
    _content = [self.paramers objectForKey:LB_RET_TEXT];
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil && !LB_SIMULATOR)
    {
        if ([mailClass canSendMail])
        {
            [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
            if (self.navigationBarBgImage)
            {
                [[UINavigationBar appearance] setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
            }
            if (self.navigationBarShadowImage)
            {
                [[UINavigationBar appearance] setShadowImage:nil];
            }
            
            MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
            picker.delegate = self;
            picker.mailComposeDelegate = self;
            // 发送人
            if (_arrayToRecipient)
            {
                [picker setToRecipients:_arrayToRecipient];
            }
            // 抄送人
            if (_arrayCCRecipient)
            {
                [picker setCcRecipients:_arrayCCRecipient];
            }
            // 主题
            [picker setSubject:_title];
            // 内容
            [picker setMessageBody:_content isHTML:YES];
            
            NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIColor blackColor],
                                        UITextAttributeTextColor,
                                        [UIFont systemFontOfSize:18],
                                        UITextAttributeFont, nil];
            [picker.navigationBar setTitleTextAttributes:attributes];
            [picker.navigationBar setTintColor:COLOR_SYSTEM_DEFAULT];
            
            if (self.viewController)
            {
                [self.viewController presentViewController:picker animated:YES completion:nil];
            }
            else
            {
                [[UINavigationBar appearance] setBarTintColor:self.navBgColor];
                [self callbackJsSdk:@"" errorCode:LBErrorCodeFail msg:kLBMsgEmailFail];
                [self alertNoVc];
            }
        }
        else
        {
            NSMutableString *mailUrl = [[NSMutableString alloc] init];
            NSArray *toRecipients = _arrayToRecipient;
            [mailUrl appendFormat:@"mailto:%@", [toRecipients componentsJoinedByString:@","]];
            //添加抄送
            NSArray *ccRecipients = _arrayCCRecipient;
            [mailUrl appendFormat:@"?cc=%@", [ccRecipients componentsJoinedByString:@","]];
            //添加主题
            [mailUrl appendString:[NSString stringWithFormat:@"&subject=%@", _title]];
            //添加邮件内容
            [mailUrl appendString:[NSString stringWithFormat:@"&body=%@", _content]];
            NSString* email = [mailUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString:email]];
        }
    }
    else
    {
        [self showAlert:@"当前系统版本不支持应用内发送邮件功能"];
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.windowTintColor)
    {
        [[[UIApplication sharedApplication] delegate] window].tintColor = nil;
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (self.windowTintColor)
    {
        [[[UIApplication sharedApplication] delegate] window].tintColor = self.windowTintColor;
    }
    
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
            // 发送邮件成功
        case MFMailComposeResultSent:
        {
            [self callbackJsSdk:@"" errorCode:LBErrorCodeSuccess msg:kLBMsgEmailSuccess];
            break;
        }
            // 发送邮件失败
        case MFMailComposeResultFailed:
        {
            [self callbackJsSdk:@"" errorCode:LBErrorCodeFail msg:kLBMsgEmailFail];
            break;
        }
            // 取消发送邮件
        case MFMailComposeResultCancelled:
            // 保存邮件
        case MFMailComposeResultSaved:
        {
            [self callbackJsSdk:@"" errorCode:LBErrorCodeCancel msg:kLBMsgEmailCancel];
            break;
        }
        default:
        {
            break;
        }
    }
}

@end
