//
//  TFPushNotificationView.h
//  TFNotifier
//
//  Created by xiayiyong on 15/5/21.
//  Copyright (c) 2015年 xiayiyong. All rights reserved.
//  from https://github.com/shaojiankui/JKNotifier
//

#import <UIKit/UIKit.h>
@class TFPushNotificationView;

typedef void(^TFPushNotificationViewTouchBlock)(NSString *name,NSString *detail,TFPushNotificationView *notifier);

@interface TFPushNotificationView : UIWindow

+(TFPushNotificationView*)showWithMessage:(NSString*)message block:(TFPushNotificationViewTouchBlock)block;

+(TFPushNotificationView*)showWithMessage:(NSString*)message
                         dismissAfter:(NSTimeInterval)delay
                                block:(TFPushNotificationViewTouchBlock)block;

+(TFPushNotificationView*)showWithMessage:(NSString*)message
                             appName:(NSString*)appName
                             appIcon:(UIImage*)appIcon
                     dismissAfter:(NSTimeInterval)delay
                            block:(TFPushNotificationViewTouchBlock)block;

+ (void)dismiss;

+ (void)dismissAfter:(NSTimeInterval)delay;

- (void)dismiss;

@end
