//
//  LBDate.m
//  LightBundle
//
//  Created by Hu Dan 胡丹 on 15/11/3.
//  Copyright © 2015年 Ren Wenchao 任文超. All rights reserved.
//

#import "LBDate.h"
#import "LBCustomPicker.h"


@interface LBDate()<LBCustomPickerDelegate>

// 选择日期
@property (nonatomic, strong) LBCustomPicker *customPicker;

@end

@implementation LBDate

/**
 *  停止展示
 */
-(void)stopShowing
{
    [self.customPicker onClickCancel];
}

/**
 *  选择日期
 *
 *  @param type 日期类型
 */
- (void)jsCallFunction
{
    self.customPicker = [[LBCustomPicker alloc] initWithFrame:self.viewController.view.frame type:kDateSelectTypeDate];
    self.customPicker.delegate = self;
    [self.viewController.view addSubview:self.customPicker];
}

/**
 *  LBCustomPicker delegate
 *  选择日期回调
 *
 *  @param ts 时间戳字符串
 */
- (void)selectDate:(NSString *)ts
{
    [self callbackJsSdk:ts errorCode:LBErrorCodeSuccess msg:@""];
}

@end
