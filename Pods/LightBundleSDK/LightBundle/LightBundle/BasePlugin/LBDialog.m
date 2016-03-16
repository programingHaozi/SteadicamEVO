//
//  LBDialog.m
//  LightBundle
//
//  Created by Hu Dan 胡丹 on 15/11/3.
//  Copyright © 2015年 Ren Wenchao 任文超. All rights reserved.
//

#import "LBDialog.h"
#import "LBUIAlertView+Blocks.h"
#import "LBUIActionSheet+Blocks.h"
#import "LBUIAlertController+Blocks.h"

#define ButtonsCount 3

@interface LBDialog()<UIAlertViewDelegate,UIActionSheetDelegate>

@property (nonatomic,retain)NSString *title;
@property (nonatomic,retain)NSString *message;
@property (nonatomic,retain)NSArray *buttons;

@end

@implementation LBDialog

/**
 *  对话框
 */
- (void)jsCallFunction
{
    self.title = [self.paramers objectForKey:LB_RET_TITLE];
    self.message = [self.paramers objectForKey:LB_RET_TEXT];
    self.buttons = [self.paramers objectForKey:LB_RET_BTNARRAY];
    
    if (self.buttons.count < ButtonsCount)
    {
        
        //系统小于8.0则使用uialertview,
        //大于8.0则使用uialertController
        if (LB_SYSTEM_VERSION < 8.0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:_title
                                                           message:_message
                                                          delegate:self
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:nil];
            
            for (NSDictionary *btnDic in self.buttons)
            {
                for (NSString *key in btnDic)
                {
                    
                    LBRIButtonItem *btn = [LBRIButtonItem itemWithLabel:btnDic[key] action:^{
                        [self callbackJsSdk:[NSString stringWithFormat:@"%lu",(unsigned long)[_buttons indexOfObject:btnDic]] errorCode:LBErrorCodeSuccess msg:kLBMsgDialogSuccess];
                        NSLog(@"%@",[NSString stringWithFormat:@"%lu",(unsigned long)[_buttons indexOfObject:btnDic]]);
                        
                    }];
                    [alert addButtonItem:btn];
                }
            }
            [alert show];
        }
        else
        {
            NSMutableArray *titleArr = [[NSMutableArray alloc]init];
            for (NSDictionary *btnDic in self.buttons)
            {
                for (NSString *key in btnDic)
                {
                    [titleArr addObject:btnDic[key]];
                }
            }
            
            [UIAlertController showInViewController:self.viewController
                                          withTitle:self.title
                                            message:self.message
                                     preferredStyle:UIAlertControllerStyleAlert
                                  cancelButtonTitle:nil
                             destructiveButtonTitle:nil
                                  otherButtonTitles:titleArr
                 popoverPresentationControllerBlock:nil
                                           tapBlock:^(UIAlertController * _Nonnull controller,
                                               UIAlertAction * _Nonnull action,
                                               NSInteger buttonIndex) {
                                                    // cancel的index默认为0，des默认为1，所以-2
                                                    [self callbackJsSdk:[NSString stringWithFormat:@"%d",(int)(buttonIndex-2)]
                                          errorCode:LBErrorCodeSuccess
                                                msg:kLBMsgDialogSuccess];
            }];
        }
    }
    else
    {
        if (LB_SYSTEM_VERSION < 8.0)
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:_title
                                                                    delegate:self
                                                           cancelButtonTitle:nil
                                                      destructiveButtonTitle:nil
                                                           otherButtonTitles:nil];
            for (NSDictionary *btnDic in self.buttons)
            {
                for (NSString *key in btnDic)
                {
                    LBRIButtonItem *btn = [LBRIButtonItem itemWithLabel:btnDic[key] action:^{
                        [self callbackJsSdk:[NSString stringWithFormat:@"%lu",(unsigned long)[self.buttons indexOfObject:btnDic]] errorCode:LBErrorCodeSuccess msg:kLBMsgDialogSuccess];
                        NSLog(@"%@",[NSString stringWithFormat:@"%lu",(unsigned long)[self.buttons indexOfObject:btnDic]]);
                        
                    }];

                    [actionSheet addButtonItem:btn];
                }
            }
            [actionSheet showInView:self.viewController.view];
            
        }
        else
        {
        
            NSMutableArray *titleArr = [[NSMutableArray alloc]init];
            for (NSDictionary *btnDic in self.buttons)
            {
                for (NSString *key in btnDic)
                {
                    [titleArr addObject:btnDic[key]];
                }
            }
            [UIAlertController showInViewController:self.viewController
                                          withTitle:self.title
                                            message:self.message
                                     preferredStyle:UIAlertControllerStyleActionSheet
                                  cancelButtonTitle:nil
                             destructiveButtonTitle:nil
                                  otherButtonTitles:titleArr
                 popoverPresentationControllerBlock:nil
                                           tapBlock:^(UIAlertController * _Nonnull controller,
                                                      UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                     //cancel的index默认为0，des默认为1，所以-2
                     [self callbackJsSdk:[NSString stringWithFormat:@"%d",(int)(buttonIndex-2)]
                               errorCode:LBErrorCodeSuccess
                                     msg:kLBMsgDialogSuccess];
                 }];
        }
    }
}

@end
