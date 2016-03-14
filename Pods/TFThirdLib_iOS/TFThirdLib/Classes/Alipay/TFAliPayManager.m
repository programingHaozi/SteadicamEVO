//
//  TFAlipayManager.m
//  TFThirdLib
//
//  Created by xiayiyong on 15/9/19.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFAliPayManager.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "Aspects.h"

#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"

@implementation TFAliPayReq

@end;

@interface Order : NSObject

@property(nonatomic, copy) NSString * partner;
@property(nonatomic, copy) NSString * seller;
@property(nonatomic, copy) NSString * tradeNO;
@property(nonatomic, copy) NSString * productName;
@property(nonatomic, copy) NSString * productDescription;
@property(nonatomic, copy) NSString * amount;
@property(nonatomic, copy) NSString * notifyURL;

@property(nonatomic, copy) NSString * service;
@property(nonatomic, copy) NSString * paymentType;
@property(nonatomic, copy) NSString * inputCharset;
@property(nonatomic, copy) NSString * itBPay;
@property(nonatomic, copy) NSString * showUrl;


@property(nonatomic, copy) NSString * rsaDate;//可选
@property(nonatomic, copy) NSString * appID;//可选

@property(nonatomic, readonly) NSMutableDictionary * extraParams;

@end


@implementation Order

- (NSString *)description {
    NSMutableString * discription = [NSMutableString string];
    if (self.partner) {
        [discription appendFormat:@"partner=\"%@\"", self.partner];
    }
    
    if (self.seller) {
        [discription appendFormat:@"&seller_id=\"%@\"", self.seller];
    }
    if (self.tradeNO) {
        [discription appendFormat:@"&out_trade_no=\"%@\"", self.tradeNO];
    }
    if (self.productName) {
        [discription appendFormat:@"&subject=\"%@\"", self.productName];
    }
    
    if (self.productDescription) {
        [discription appendFormat:@"&body=\"%@\"", self.productDescription];
    }
    if (self.amount) {
        [discription appendFormat:@"&total_fee=\"%@\"", self.amount];
    }
    if (self.notifyURL) {
        [discription appendFormat:@"&notify_url=\"%@\"", self.notifyURL];
    }
    
    if (self.service) {
        [discription appendFormat:@"&service=\"%@\"",self.service];//mobile.securitypay.pay
    }
    if (self.paymentType) {
        [discription appendFormat:@"&payment_type=\"%@\"",self.paymentType];//1
    }
    
    if (self.inputCharset) {
        [discription appendFormat:@"&_input_charset=\"%@\"",self.inputCharset];//utf-8
    }
    if (self.itBPay) {
        [discription appendFormat:@"&it_b_pay=\"%@\"",self.itBPay];//30m
    }
    if (self.showUrl) {
        [discription appendFormat:@"&show_url=\"%@\"",self.showUrl];//m.alipay.com
    }
    if (self.rsaDate) {
        [discription appendFormat:@"&sign_date=\"%@\"",self.rsaDate];
    }
    if (self.appID) {
        [discription appendFormat:@"&app_id=\"%@\"",self.appID];
    }
    for (NSString * key in [self.extraParams allKeys]) {
        [discription appendFormat:@"&%@=\"%@\"", key, [self.extraParams objectForKey:key]];
    }
    return discription;
}

@end

@implementation TFAliPayManager

static const void *TFAliPayManagerSuccessBlockKey     = &TFAliPayManagerSuccessBlockKey;
static const void *TFAliPayManagerFailureBlockKey     = &TFAliPayManagerFailureBlockKey;
static const void *TFAliPayManagerCancelBlockKey     = &TFAliPayManagerCancelBlockKey;

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
        class_addMethod(cls, cmd1, (IMP)dynamicMethod1_tfalipay , "v@:@@");
    }
    
    if (!method2)
    {
        class_addMethod(cls, cmd2, (IMP)dynamicMethod2_tfalipay , "v@:@@@@");
    }
}

BOOL dynamicMethod1_tfalipay(id _self, SEL cmd,UIApplication *application ,NSURL *url)
{
    return YES;
}

BOOL dynamicMethod2_tfalipay(id _self, SEL cmd,UIApplication *application ,NSURL *url, NSString *sourceApplication,id annotation)
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
         //跳转支付宝钱包进行支付，处理支付结果
         [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
             NSLog(@"result = %@",resultDic);
             [[[self class]sharedManager] alipayCallback:resultDic];
         }];
     }
     error:NULL];
    
    [NSClassFromString(@"AppDelegate")
     aspect_hookSelector:@selector(application:openURL:sourceApplication:annotation:)
     withOptions:AspectPositionAfter
     usingBlock:^(id<AspectInfo> aspectInfo, id application, id url,id sourceApplication,id annotation){
         // Required
         //跳转支付宝钱包进行支付，处理支付结果
         [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
             NSLog(@"result = %@",resultDic);
             [[[self class]sharedManager] alipayCallback:resultDic];
         }];
     }
     error:NULL];
}

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static TFAliPayManager *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TFAliPayManager alloc] init];
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

+ (void) pay:(TFAliPayReq*)data
     success:(TFAliPayManagerSuccessBlock)successBlock
     failure:(TFAliPayManagerFailureBlock)failureBlock
      cancel:(TFAliPayManagerCancelBlock)cancelBlock
{
    [[[self class] sharedManager]pay:data success:successBlock failure:failureBlock cancel:cancelBlock];
}

+ (void) payWithBoxedInfo:(NSString *)payInfoStr scheme:(NSString *)scheme
   success:(TFAliPayManagerSuccessBlock)successBlock
   failure:(TFAliPayManagerFailureBlock)failureBlock
    cancel:(TFAliPayManagerCancelBlock)cancelBlock
{
    [[[self class] sharedManager] payWithBoxedInfo:payInfoStr scheme:scheme success:successBlock failure:failureBlock cancel:cancelBlock];
}

- (void) pay:(TFAliPayReq*)data
     success:(TFAliPayManagerSuccessBlock)successBlock
     failure:(TFAliPayManagerFailureBlock)failureBlock
      cancel:(TFAliPayManagerCancelBlock)cancelBlock
{
    Order *order = [[Order alloc] init];
    order.partner = data.partner;
    order.seller = data.seller;
    order.tradeNO = data.tradeNO; //订单ID（由商家自行制定）
    order.productName = data.productName; //商品标题
    order.productDescription = data.productDescription; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",data.price]; //商品价格
    order.notifyURL = data.notifyURL; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = data.appScheme;
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(data.rsa_private_key);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil)
    {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [self setSuccessBlock:successBlock];
        [self setFailureBlock:failureBlock];
        [self setCancelBlock:cancelBlock];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            [[[self class]sharedManager] alipayCallback:resultDic];
        }];
    }
}

- (void) payWithBoxedInfo:(NSString *)payInfoStr scheme:(NSString *)scheme
     success:(TFAliPayManagerSuccessBlock)successBlock
     failure:(TFAliPayManagerFailureBlock)failureBlock
      cancel:(TFAliPayManagerCancelBlock)cancelBlock
{
    [self setSuccessBlock:successBlock];
    [self setFailureBlock:failureBlock];
    [self setCancelBlock:cancelBlock];
    
    [[AlipaySDK defaultService] payOrder:payInfoStr fromScheme:scheme callback:^(NSDictionary *resultDic) {
        NSLog(@"result = %@",resultDic);
        [[[self class]sharedManager] alipayCallback:resultDic];
    }];
}

- (void)alipayCallback:(NSDictionary*)resultDic
{
    NSString *resultStatus=[resultDic objectForKey:@"resultStatus"];
    int errorCode=[resultStatus intValue];
    
    switch (errorCode)
    {
        case 9000:
        {
            NSLog(@"支付成功");
            TFAliPayManagerSuccessBlock block = self.successBlock;
            if (block)
            {
                block();
            }
            break;
        }
        case 6001:
        {
            NSLog(@"用户中途取消");
            TFAliPayManagerCancelBlock block = self.cancelBlock;
            if (block)
            {
                block();
            }
            break;
        }
        case 6002:
        {
            NSLog(@"网络连接出错");
            TFAliPayManagerFailureBlock block = self.failureBlock;
            if (block)
            {
                block(errorCode, @"网络连接出错");
            }
            break;
        }
        default:
        {
            NSLog(@"支付失败");
            TFAliPayManagerFailureBlock block = self.failureBlock;
            if (block)
            {
                block(errorCode, @"支付失败");
            }
            break;
        }
    }
}

#pragma mark- Block setting/getting methods

- (void)setSuccessBlock:(TFAliPayManagerSuccessBlock)block
{
    objc_setAssociatedObject(self, TFAliPayManagerSuccessBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (TFAliPayManagerSuccessBlock)successBlock
{
    return objc_getAssociatedObject(self, TFAliPayManagerSuccessBlockKey);
}

- (void)setFailureBlock:(TFAliPayManagerFailureBlock)block
{
    objc_setAssociatedObject(self, TFAliPayManagerFailureBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (TFAliPayManagerFailureBlock)failureBlock
{
    return objc_getAssociatedObject(self, TFAliPayManagerFailureBlockKey);
}

- (void)setCancelBlock:(TFAliPayManagerCancelBlock)block
{
    objc_setAssociatedObject(self, TFAliPayManagerCancelBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (TFAliPayManagerCancelBlock)cancelBlock
{
    return objc_getAssociatedObject(self, TFAliPayManagerCancelBlockKey);
}

@end
