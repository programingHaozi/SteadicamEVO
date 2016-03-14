//
//  TFWXPayManager.h
//  TFThirdLib
//
//  Created by xiayiyong on 15/10/21.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
// sdk version 1.6.2
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface TFWxPayReq : NSObject

/**
 *  商户号-微信支付分配的商户号
 */
@property(nonatomic, copy) NSString * partnerId;

/**
 *  预支付交易会话ID-微信返回的支付交易会话ID
 */
@property(nonatomic, copy) NSString * prepayId;

/**
 *  随机串，防重发
 */
@property(nonatomic, copy) NSString * nonceStr;

/**
 *  时间戳，防重发
 */
@property(nonatomic, copy) NSString * timeStamp;

/**
 *  商家根据微信开放平台文档对数据做的签名
 */
@property(nonatomic, copy) NSString * sign;

@end

/**
 *  微信支付管理类
 */
@interface TFWxPayManager : NSObject

/**
 * 支付成功回调
 */
typedef void (^TFWxPayManagerSuccessBlock) (void);

/**
 * 支付失败回调
 */
typedef void (^TFWxPayManagerFailureBlock) (int errorCode, NSString *errorMessage);

/**
 * 取消支付回调
 */
typedef void (^TFWxPayManagerCancelBlock) (void);

/**
 *  微信支付接口
 *
 *  @param data         req
 *  @param successBlock 支付成功回调
 *  @param failureBlock 支付失败回调
 *  @param cancelBlock  取消支付回调
 */
+ (void)pay:(TFWxPayReq*)data
    success:(TFWxPayManagerSuccessBlock)successBlock
    failure:(TFWxPayManagerFailureBlock)failureBlock
     cancel:(TFWxPayManagerCancelBlock)cancelBlock;

@end
