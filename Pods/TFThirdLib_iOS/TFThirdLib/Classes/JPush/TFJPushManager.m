//
//  TFJPushManager.m
//  TFBaseLib
//
//  Created by xiayiyong on 15/9/17.
//  Copyright © 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFJPushManager.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "JPUSHService.h"
#import "Aspects.h"

@implementation TFJPushManager

typedef void (^CompletionHandlerBlock)(UIBackgroundFetchResult result);

+ (void)load
{
    [super load];
    [TFJPushManager sharedInstance];
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static TFJPushManager *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TFJPushManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self observeAllNotifications];
        [self checkAppDelegate];
        [self trackAppDelegate];
    }
    return self;
}

- (void)dealloc
{
    [self unObserveAllNotifications];
}

- (void)observeAllNotifications
{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidSetup:)
                          name:kJPFNetworkDidSetupNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidClose:)
                          name:kJPFNetworkDidCloseNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidRegister:)
                          name:kJPFNetworkDidRegisterNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidReceiveMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(serviceError:)
                          name:kJPFServiceErrorNotification
                        object:nil];
}

- (void)unObserveAllNotifications
{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidSetupNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidCloseNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidRegisterNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidLoginNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidReceiveMessageNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFServiceErrorNotification
                           object:nil];
}

- (void)checkAppDelegate
{
    id applictionDelegate = [UIApplication sharedApplication].delegate;
    
    Class cls=NSClassFromString(@"AppDelegate");
    
    SEL cmd1 = @selector(application:didRegisterForRemoteNotificationsWithDeviceToken:);
    SEL cmd2 = @selector(application:didReceiveRemoteNotification:);
    SEL cmd3 = @selector(application:didReceiveRemoteNotification:fetchCompletionHandler:);
    SEL cmd4 = @selector(applicationDidBecomeActive:);
    
    Method method1 = class_getInstanceMethod(cls, cmd1);
    Method method2 = class_getInstanceMethod(cls, cmd2);
    Method method3 = class_getInstanceMethod(cls, cmd3);
    Method method4 = class_getInstanceMethod(cls, cmd4);
    
    if (!method1)
    {
        class_addMethod(cls, cmd1, (IMP)dynamicMethod1_tfjpush , "v@:@@");
    }
    
    if (!method2)
    {
        class_addMethod(cls, cmd2, (IMP)dynamicMethod2_tfjpush, "v@:@@");
    }

    if (!method3)
    {
        class_addMethod(cls, cmd3, (IMP)dynamicMethod3_tfjpush , "v@:@@@");
    }
    
    if (!method4)
    {
        class_addMethod(cls, cmd4, (IMP)dynamicMethod4_tfjpush , "v@:@");
    }
}

void dynamicMethod1_tfjpush(id _self, SEL cmd,UIApplication *application ,NSData *deviceToken)
{
    
}

void dynamicMethod2_tfjpush(id _self, SEL cmd,UIApplication *application ,NSDictionary *userInfo)
{
    
}

void dynamicMethod3_tfjpush(id _self, SEL cmd,UIApplication *application ,NSDictionary *userInfo, CompletionHandlerBlock completionHandler)
{
}

void dynamicMethod4_tfjpush(id _self, SEL cmd,UIApplication *application)
{
}

- (void)trackAppDelegate
{
    [NSClassFromString(@"AppDelegate")
     aspect_hookSelector:@selector(application:didFinishLaunchingWithOptions:)
     withOptions:AspectPositionAfter
     usingBlock:^(id<AspectInfo> aspectInfo, id application,id launchOptions){
         // Required
         if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
             //可以添加自定义categories
             [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                            UIUserNotificationTypeSound |
                                                            UIUserNotificationTypeAlert)
                                                categories:nil];
         } else {
             //categories 必须为nil
             [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                            UIRemoteNotificationTypeSound |
                                                            UIRemoteNotificationTypeAlert)
                                                categories:nil];
         }
         
         // Required
         NSString *appKey=[[self class]_appKey];
         NSString *channel=[[self class]_channel];
         NSString *apsForProduction=[[self class]_apsForProduction];
         if (appKey!=nil&&appKey.length>0)
         {
             [JPUSHService setupWithOption:launchOptions appKey:appKey channel:channel apsForProduction:apsForProduction];
         }
     }
     error:NULL];
    
    [NSClassFromString(@"AppDelegate")
     aspect_hookSelector:@selector(application:didRegisterForRemoteNotificationsWithDeviceToken:)
     withOptions:AspectPositionAfter
     usingBlock:^(id<AspectInfo> aspectInfo, id application,id deviceToken){
         // Required
         [JPUSHService registerDeviceToken:deviceToken];
     }
     error:NULL];
    
    [NSClassFromString(@"AppDelegate")
     aspect_hookSelector:@selector(application: didReceiveRemoteNotification:)
     withOptions:AspectPositionAfter
     usingBlock:^(id<AspectInfo> aspectInfo, id application,id userInfo){
         // Required
         [JPUSHService handleRemoteNotification:userInfo];
     }
     error:NULL];
    
    [NSClassFromString(@"AppDelegate")
     aspect_hookSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)
     withOptions:AspectPositionAfter
     usingBlock:^(id<AspectInfo> aspectInfo, id application,id userInfo,CompletionHandlerBlock completionHandler){
         // IOS 7 Support Required
         [JPUSHService handleRemoteNotification:userInfo];
         completionHandler(UIBackgroundFetchResultNewData);
         [[[self class]sharedInstance] processAPNSNotification:application notification:userInfo];
         [[self class] resetBadge];
     }
     error:NULL];
    
    [NSClassFromString(@"AppDelegate")
     aspect_hookSelector:@selector(applicationDidBecomeActive:)
     withOptions:AspectPositionAfter
     usingBlock:^(id<AspectInfo> aspectInfo, id application){
         // Required
         [[self class] resetBadge];
     }
     error:NULL];
    
}

+ (void)setAlias:(NSString*)alias
{
    [JPUSHService setTags:[NSSet set] alias:alias callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:[TFJPushManager sharedInstance]];
}

+ (void)resetBadge
{
    [JPUSHService resetBadge];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

#pragma mark -
#pragma mark APNS
/*
 在jpush 发送通知收到processAPNSNotification
 在后台 发送通知先networkDidReceiveMessage 后收到processAPNSNotification
 
 格式
 {
 "_j_msgid" = 2271973133;
 aps =     {
 alert = "\U8be5\U8d26\U53f7\U5df2\U5728\U5176\U4ed6\U8bbe\U5907\U4e0a\U767b\U5f55";
 badge = 1;
 sound = happy;
 };
 customData = "markType:9999,token:96481b0d4a944fb9bb008582ff02211d-796273";
 notificationId = 55137;
 userId = 796273;
 }
 */
- (void)processAPNSNotification:(UIApplication*)application notification:(NSNotification *)notification
{
    
}

#pragma mark -
#pragma mark CallBack
- (void)networkDidSetup:(NSNotification *)notification
{
    NSLog(@"jpush--networkDidSetup");
    [[self class] resetBadge];
}

- (void)networkDidClose:(NSNotification *)notification
{
    NSLog(@"jpush--networkDidClose");
}

- (void)networkDidRegister:(NSNotification *)notification
{
    NSLog(@"jpush--networkDidRegister");
}

- (void)networkDidLogin:(NSNotification *)notification
{
    NSLog(@"jpush--networkDidLogin");
}

/*
 格式
 {
 content = "\U8be5\U8d26\U53f7\U5df2\U5728\U5176\U4ed6\U8bbe\U5907\U4e0a\U767b\U5f55";
 extras =     {
 customData = "markType:9999,token:96481b0d4a944fb9bb008582ff02211d-796273";
 notificationId = 55136;
 userId = 796273;
 };
 title = "\U6d88\U606f";
 }}
 */
- (void)networkDidReceiveMessage:(NSNotification *)notification
{
    NSLog(@"jpush--networkDidReceiveMessage");
}

- (void)serviceError:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSString *error = [userInfo valueForKey:@"error"];
    NSLog(@"%@", error);
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet *)tags alias:(NSString *)alias
{
    
}

#pragma mark -
#pragma mark -私有方法

+(NSString*)_appKey
{
    return [self _umeng:@"APP_KEY"];
}

+(NSString*)_channel
{
    return [self _umeng:@"CHANNEL"];
}

+(NSString*)_apsForProduction
{
    return [self _umeng:@"APS_FOR_PRODUCTION"];
}

+(NSString*)_umengWXUrl
{
    return [self _umeng:@"WX_URL"];
}

+(NSString*)_umeng:(NSString*)key
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ThirdConfig" ofType:@"plist"];
    NSDictionary *rootDict = [NSDictionary dictionaryWithContentsOfFile:path];
    if (rootDict==nil)
    {
        return nil;
    }
    
    NSDictionary *configDict=[rootDict objectForKey:@"JPush"];
    if (configDict==nil)
    {
        return nil;
    }
    
    NSString *tt=[configDict objectForKey:key];
    if (tt==nil || [tt length]<=0)
    {
        return nil;
    }
    
    return tt;
}

@end
