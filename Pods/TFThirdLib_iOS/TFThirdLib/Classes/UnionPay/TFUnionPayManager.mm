//
//  TFUnionPayManager.m
//  TFThirdLib
//
//  Created by xiayiyong on 15/10/21.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "TFUnionPayManager.h"

#import <objc/runtime.h>
#import "Aspects.h"

@implementation TFUnionPayReq

@end

@implementation TFUnionPayManager

static const void *TFUnionPayManagerSuccessBlockKey     = &TFUnionPayManagerSuccessBlockKey;
static const void *TFUnionPayManagerFailureBlockKey     = &TFUnionPayManagerFailureBlockKey;
static const void *TFUnionPayManagerCancelBlockKey     = &TFUnionPayManagerCancelBlockKey;

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
        class_addMethod(cls, cmd1, (IMP)dynamicMethod1_tfuppay , "v@:@@");
    }
    
    if (!method2)
    {
        class_addMethod(cls, cmd2, (IMP)dynamicMethod2_tfuppay , "v@:@@@@");
    }
}

BOOL dynamicMethod1_tfuppay(id _self, SEL cmd,UIApplication *application ,NSURL *url)
{
    return YES;
}

BOOL dynamicMethod2_tfuppay(id _self, SEL cmd,UIApplication *application ,NSURL *url, NSString *sourceApplication,id annotation)
{
    return YES;
}

+ (void)trackAppDelegate
{
    [NSClassFromString(@"AppDelegate")
     aspect_hookSelector:@selector(application:handleOpenURL:)
     withOptions:AspectPositionBefore
     usingBlock:^(id<AspectInfo> aspectInfo, id application, id url){
         // Required
         
     }
     error:NULL];
    
    [NSClassFromString(@"AppDelegate")
     aspect_hookSelector:@selector(application:openURL:sourceApplication:annotation:)
     withOptions:AspectPositionAfter
     usingBlock:^(id<AspectInfo> aspectInfo, id application, id url,id sourceApplication,id annotation){
         // Required
         [[UPPaymentControl defaultControl]handlePaymentResult:url
                                                 completeBlock:^(NSString *code, NSDictionary *data) {
                                                     [[[self class]sharedManager] UPPayPluginResult:code];
                                                 }];
     }
     error:NULL];
}

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static TFUnionPayManager *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TFUnionPayManager alloc] init];
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

+ (void) pay:(TFUnionPayReq*)data
     success:(TFUnionPayManagerSuccessBlock)successBlock
     failure:(TFUnionPayManagerFailureBlock)failureBlock
      cancel:(TFUnionPayManagerCancelBlock)cancelBlock
{
    [[[self class] sharedManager] pay:data success:successBlock failure:failureBlock cancel:cancelBlock];
}

- (void) pay:(TFUnionPayReq*)data
     success:(TFUnionPayManagerSuccessBlock)successBlock
     failure:(TFUnionPayManagerFailureBlock)failureBlock
      cancel:(TFUnionPayManagerCancelBlock)cancelBlock
{
    NSString *tt=@"00";
    if(data.model==0)
    {
        tt=@"00";
    }
    else
    {
        tt=@"01";
    }
    
    [self setSuccessBlock:successBlock];
    [self setFailureBlock:failureBlock];
    [self setCancelBlock:cancelBlock];
    
    [[UPPaymentControl defaultControl]startPay:data.tn fromScheme:data.appScheme mode:tt viewController:data.viewController];
}

#pragma mark -
#pragma mark UPPayPluginResult

- (void)UPPayPluginResult:(NSString *)result
{
    NSString* msg = [NSString stringWithFormat:@"支付结果：%@", result];
    NSLog(@"%@",msg);
    
    if ([result isEqualToString:@"success"])
    {
        TFUnionPayManagerSuccessBlock block=self.successBlock;
        if (block)
        {
            block();
        }
    }
    else if ([result isEqualToString:@"fail"])
    {
        TFUnionPayManagerFailureBlock block=self.failureBlock;
        if (block)
        {
            block(-1000,result);
        }
    }
    else if ([result isEqualToString:@"cancel"])
    {
        TFUnionPayManagerCancelBlock block=self.cancelBlock;
        if (block)
        {
            block();
        }
    }
}

#pragma mark- Block setting/getting methods

- (void)setSuccessBlock:(TFUnionPayManagerSuccessBlock)block
{
    objc_setAssociatedObject(self, TFUnionPayManagerSuccessBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (TFUnionPayManagerSuccessBlock)successBlock
{
    return objc_getAssociatedObject(self, TFUnionPayManagerSuccessBlockKey);
}

- (void)setFailureBlock:(TFUnionPayManagerFailureBlock)block
{
    objc_setAssociatedObject(self, TFUnionPayManagerFailureBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (TFUnionPayManagerFailureBlock)failureBlock
{
    return objc_getAssociatedObject(self, TFUnionPayManagerFailureBlockKey);
}

- (void)setCancelBlock:(TFUnionPayManagerCancelBlock)block
{
    objc_setAssociatedObject(self, TFUnionPayManagerCancelBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (TFUnionPayManagerCancelBlock)cancelBlock
{
    return objc_getAssociatedObject(self, TFUnionPayManagerCancelBlockKey);
}


@end
