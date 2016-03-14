//
//  TFAlipayManager.h
//  TFThirdLib
//
//  Created by xiayiyong on 15/9/19.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//  IOS版本号：v15.0.6 修改时间：2016-1-20
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface TFAliPayReq : NSObject

/**
 *  partner  例子 2088911703752573
 */
@property(nonatomic, copy) NSString * partner;

/**
 * 商户账号 54390033@qq.com
 */
@property(nonatomic, copy) NSString * seller;

/**
 *  订单ID
 */
@property(nonatomic, copy) NSString * tradeNO;

/**
 *  商品名称
 */
@property(nonatomic, copy) NSString * productName;

/**
 *  商品描述
 */
@property(nonatomic, copy) NSString * productDescription;

/**
 *  商品价格
 */
@property(nonatomic, assign) CGFloat price;

/**
 *  支付成功回调URL
 */
@property(nonatomic, copy) NSString * notifyURL;

/**
 *  RAS加密的公钥
 */
@property(nonatomic, copy) NSString * rsa_public_key;

/**
 *  RAS加密的私钥
 */
@property(nonatomic, copy) NSString * rsa_private_key;

/**
 *  调用支付的app注册在info.plist中的scheme
 */
@property(nonatomic, copy) NSString * appScheme;

@end

/**
 *  支付宝支付管理类
 */
@interface TFAliPayManager : NSObject

/**
 * 支付成功回调
 */
typedef void (^TFAliPayManagerSuccessBlock) (void);

/**
 * 支付失败回调
 */
typedef void (^TFAliPayManagerFailureBlock) (int errorCode, NSString *errorMessage);

/**
 * 取消支付回调
 */
typedef void (^TFAliPayManagerCancelBlock) (void);

/**
 *  支付宝支付接口
 *
 *  @param data         req
 *  @param successBlock 支付成功回调
 *  @param failureBlock 支付失败回调
 *  @param cancelBlock  取消支付回调
 */
+ (void)pay:(TFAliPayReq*)data
    success:(TFAliPayManagerSuccessBlock)successBlock
    failure:(TFAliPayManagerFailureBlock)failureBlock
     cancel:(TFAliPayManagerCancelBlock)cancelBlock;

/**
 *  支付宝支付接口
 *
 *  @param payInfoStr 
 *  @param scheme  在info.plist中的scheme
 *  @param successBlock 支付成功回调
 *  @param failureBlock 支付失败回调
 *  @param cancelBlock  取消支付回调
 */
+ (void)payWithBoxedInfo:(NSString *)payInfoStr scheme:(NSString *)scheme
    success:(TFAliPayManagerSuccessBlock)successBlock
    failure:(TFAliPayManagerFailureBlock)failureBlock
     cancel:(TFAliPayManagerCancelBlock)cancelBlock;

@end
