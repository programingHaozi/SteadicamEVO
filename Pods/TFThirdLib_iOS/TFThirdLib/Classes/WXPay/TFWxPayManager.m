//
//  TFWXPayManager.m
//  TFThirdLib
//
//  Created by xiayiyong on 15/10/21.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFWxPayManager.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "Aspects.h"

#import <objc/runtime.h>

#define WXAPPKEY @"wxb4ba3c02aa476ea1"  //test appid

@implementation TFWxPayReq

@end

@implementation TFWxPayManager

static const void *TFWxPayManagerSuccessBlockKey     = &TFWxPayManagerSuccessBlockKey;
static const void *TFWxPayManagerFailureBlockKey     = &TFWxPayManagerFailureBlockKey;
static const void *TFWxPayManagerCancelBlockKey     = &TFWxPayManagerCancelBlockKey;

+ (void)load
{
    [super load];
    [[self class] checkAppDelegate];
    [[self class] trackAppDelegate];
}

+ (void)checkAppDelegate
{
    Class cls=NSClassFromString(@"AppDelegate");
    
    SEL cmd1 = @selector(application:handleOpenURL:);
    SEL cmd2 = @selector(application:openURL:sourceApplication:annotation:);
    
    Method method1 = class_getInstanceMethod(cls, cmd1);
    Method method2 = class_getInstanceMethod(cls, cmd2);
    
    if (!method1)
    {
        class_addMethod(cls, cmd1, (IMP)dynamicMethod1_tfwxpay, "v@:@@");
    }
    
    if (!method2)
    {
        class_addMethod(cls, cmd2, (IMP)dynamicMethod2_tfwxpay, "v@:@@@@");
    }
}

BOOL dynamicMethod1_tfwxpay(id _self, SEL cmd,UIApplication *application ,NSURL *url)
{
    return YES;
}

BOOL dynamicMethod2_tfwxpay(id _self, SEL cmd,UIApplication *application ,NSURL *url, NSString *sourceApplication,id annotation)
{
    return YES;
}

+ (void)trackAppDelegate
{
    [NSClassFromString(@"AppDelegate")
     aspect_hookSelector:@selector(application:didFinishLaunchingWithOptions:)
     withOptions:AspectPositionBefore
     usingBlock:^(id<AspectInfo> aspectInfo, id application,id launchOptions){
         // Required
         NSString *appid=[[self class]_wxappid];
         if (appid==nil || [appid length]<=0)
         {
             return;
         }
         
         [WXApi registerApp:appid];
     }
     error:NULL];
    
    [NSClassFromString(@"AppDelegate")
     aspect_hookSelector:@selector(application:handleOpenURL:)
     withOptions:AspectPositionBefore
     usingBlock:^(id<AspectInfo> aspectInfo, id application, id url){
         // Required
         [WXApi handleOpenURL:url delegate:[[self class]sharedManager]];
     }
     error:NULL];
    
    [NSClassFromString(@"AppDelegate")
     aspect_hookSelector:@selector(application:openURL:sourceApplication:annotation:)
     withOptions:AspectPositionBefore
     usingBlock:^(id<AspectInfo> aspectInfo, id application, id url,id sourceApplication,id annotation){
         // Required
         [WXApi handleOpenURL:url delegate:[[self class]sharedManager]];
     }
     error:NULL];
}

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static TFWxPayManager *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TFWxPayManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark -
#pragma mark WXApiDelegate

- (void)onResp:(BaseResp *)resp
{
    if([resp isKindOfClass:[PayResp class]])
    {
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode)
        {
            case WXSuccess:
            {
                NSLog(@"支付成功");
                TFWxPayManagerSuccessBlock block = self.successBlock;
                if (block)
                {
                    block();
                }
            
                break;
            }
            case WXErrCodeUserCancel:
            {
                NSLog(@"支付取消");
                TFWxPayManagerFailureBlock block = self.failureBlock;
                if (block)
                {
                    block(resp.errCode,resp.errStr);
                }
                
                break;
            }
            default:
            {
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                TFWxPayManagerCancelBlock block = self.cancelBlock;
                if (block)
                {
                    block();
                }

                break;
            }
        }
    }
}

- (void)onReq:(BaseReq *)req
{
    //DLog(@"req:%@",req)
}

- (NSString *)genTimeStamp
{
    return [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
}

+ (void)pay:(TFWxPayReq*)data
    success:(TFWxPayManagerSuccessBlock)successBlock
    failure:(TFWxPayManagerFailureBlock)failureBlock
     cancel:(TFWxPayManagerCancelBlock)cancelBlock
{
    [[[self class]sharedManager]pay:data success:successBlock failure:failureBlock cancel:cancelBlock];
}

- (void)pay:(TFWxPayReq*)data
    success:(TFWxPayManagerSuccessBlock)successBlock
    failure:(TFWxPayManagerFailureBlock)failureBlock
     cancel:(TFWxPayManagerCancelBlock)cancelBlock
{
    //
    if (![WXApi isWXAppInstalled]||![WXApi isWXAppSupportApi])
    {
        if (failureBlock)
        {
            failureBlock(-1000,@"您还没有安装微信客户端,或者版本太低");
        }
        
        return;
    }
    
    [self setSuccessBlock:successBlock];
    [self setFailureBlock:failureBlock];
    [self setCancelBlock:cancelBlock];
    
    PayReq *request   = [[PayReq alloc] init];
    request.sign = data.sign;
    request.package   = @"Sign=WXPay";
    request.timeStamp = data.timeStamp.intValue;
    request.nonceStr = data.nonceStr;
    request.prepayId = data.prepayId;
    request.partnerId = data.partnerId;
    [WXApi sendReq:request];
}

#pragma mark- Block setting/getting methods

- (void)setSuccessBlock:(TFWxPayManagerSuccessBlock)block
{
    objc_setAssociatedObject(self, TFWxPayManagerSuccessBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (TFWxPayManagerSuccessBlock)successBlock
{
    return objc_getAssociatedObject(self, TFWxPayManagerSuccessBlockKey);
}

- (void)setFailureBlock:(TFWxPayManagerFailureBlock)block
{
    objc_setAssociatedObject(self, TFWxPayManagerFailureBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (TFWxPayManagerFailureBlock)failureBlock
{
    return objc_getAssociatedObject(self, TFWxPayManagerFailureBlockKey);
}

- (void)setCancelBlock:(TFWxPayManagerCancelBlock)block
{
    objc_setAssociatedObject(self, TFWxPayManagerCancelBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (TFWxPayManagerCancelBlock)cancelBlock
{
    return objc_getAssociatedObject(self, TFWxPayManagerCancelBlockKey);
}

#pragma mark -other

- (void)setAssociatedBlock:(void(^)())block usingKey:(NSString *)key {
    objc_setAssociatedObject(self, (__bridge void *)(key), block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)())getAssociatedBlockForKey:(NSString *)key {
    return (__bridge void (^)())((__bridge void *)(objc_getAssociatedObject(self, (__bridge void *)(key))));
}

- (void)executeBlockIfExistForKey:(NSString *)key {
    void(^block)() = [self getAssociatedBlockForKey:key];
    if (block) {
        block();
    }
}

+(NSString*)_wxappid
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ThirdConfig" ofType:@"plist"];
    NSDictionary *rootDict = [NSDictionary dictionaryWithContentsOfFile:path];
    if (rootDict==nil)
    {
        return nil;
    }
    
    NSDictionary *configDict=[rootDict objectForKey:@"WeChat"];
    if (configDict==nil)
    {
        return nil;
    }
    
    NSString *appid=[configDict objectForKey:@"APP_ID"];
    if (appid==nil || [appid length]<=0)
    {
        return nil;
    }
    
    return appid;
}

@end
