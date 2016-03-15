//
//  Core.m
//  TFCoreLib
//
//  Created by xiayiyong on 15/9/17.
//  Copyright © 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFCore.h"
#import <UIKit/UIKit.h>
#import "TFBaseService.h"
#import "Aspects.h"

@implementation TFCore

+ (void)load
{
    [super load];
    [TFCore sharedInstance];
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static TFCore *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TFCore alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self trackAppDelegate];
    }
    return self;
}

- (void)trackAppDelegate
{
    [NSClassFromString(@"AppDelegate")
     aspect_hookSelector:@selector(application:didFinishLaunchingWithOptions:)
     withOptions:AspectPositionAfter
     usingBlock:^(id<AspectInfo> aspectInfo, id application,id launchOptions){
         [self getClientIdFromServer];
     } error:NULL];
    
}

/**
 *  从服务器获取用户ID，失败的话2秒后重新获取，直到获取成功为止
 */
-(void)getClientIdFromServer
{
    [TFBaseService regDeviceWithParameter:nil
                       success:^(NSString *clientId) {
                           if (clientId==nil||[clientId length]==0)
                           {
                               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                   [self getClientIdFromServer];
                               });
                           }
                           NSLog(@"");
                       } failure:^(int errorCode, NSString *errorMessage) {
                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                               [self getClientIdFromServer];
                           });
                       }];
    
}

@end
