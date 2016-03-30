//
//  TFNotificationView.h
//  TFNotifier
//
//  Created by xiayiyong on 15/5/21.
//  Copyright (c) 2015年 xiayiyong. All rights reserved.
//  from https://github.com/shaojiankui/JKNotifier
//

#import <UIKit/UIKit.h>
@class TFNotificationView;

typedef void(^TFNotificationViewClickBlock)(NSString *name,NSString *detail,TFNotificationView *notifier);

@interface TFNotificationView : UIWindow

+(TFNotificationView*)showNotiferRemain:(NSString*)note block:(TFNotificationViewClickBlock)notifierBarClickBlock;

+(TFNotificationView*)showNotiferRemain:(NSString*)note
                                   name:(NSString*)appName
                                  block:(TFNotificationViewClickBlock)notifierBarClickBlock;

+(TFNotificationView*)showNotifer:(NSString*)note block:(TFNotificationViewClickBlock)notifierBarClickBlock;

+(TFNotificationView*)showNotifer:(NSString *)note
                     dismissAfter:(NSTimeInterval)delay
                            block:(TFNotificationViewClickBlock)notifierBarClickBlock;

+(TFNotificationView*)showNotifer:(NSString*)note
                             name:(NSString*)appName
                             icon:(UIImage*)appIcon
                            block:(TFNotificationViewClickBlock)notifierBarClickBlock;

+(TFNotificationView*)showNotifer:(NSString*)note
                             name:(NSString*)appName
                             icon:(UIImage*)appIcon
                     dismissAfter:(NSTimeInterval)delay
                            block:(TFNotificationViewClickBlock)notifierBarClickBlock;

+ (void)dismiss;

+ (void)dismissAfter:(NSTimeInterval)delay;

- (void)dismiss;

@end
