//
//  TFUnionPayManager.h
//  TFThirdLib
//
//  Created by xiayiyong on 15/10/21.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
// sdk version 3.3.0
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "UPPaymentControl.h"

/**
 *  支付环境
 */
typedef NS_ENUM(NSInteger, TFUnionPayStyle)
{
    /**
     *  0:正式环境
     */
    TFUnionPayStyleDefault = 0,
    
    /**
     *  1:测试环境
     */
    TFUnionPayStyleDevelop,
};

@interface TFUnionPayReq : NSObject

/**
 *  订单信息
 */
@property(nonatomic, copy) NSString * tn;

/**
 *  支付环境
 */
@property(nonatomic, assign) TFUnionPayStyle model;

/**
 *  启动支付控件的viewController
 */
@property(nonatomic, strong) UIViewController *viewController;

/**
 *  调用支付的app注册在info.plist中的scheme
 */
@property(nonatomic, copy) NSString * appScheme;

@end

/**
 *  银联支付管理类
 */
@interface TFUnionPayManager : NSObject

/**
 * 支付成功回调
 */
typedef void (^TFUnionPayManagerSuccessBlock) (void);

/**
 * 支付失败回调
 */
typedef void (^TFUnionPayManagerFailureBlock) (int errorCode, NSString *errorMessage);

/**
 * 取消支付回调
 */
typedef void (^TFUnionPayManagerCancelBlock) (void);

/**
 *  银联支付接口
 *
 *  @param data         req
 *  @param successBlock 支付成功回调
 *  @param failureBlock 支付失败回调
 *  @param cancelBlock  取消支付回调
 */
+ (void) pay:(TFUnionPayReq*)data
     success:(TFUnionPayManagerSuccessBlock)successBlock
     failure:(TFUnionPayManagerFailureBlock)failureBlock
      cancel:(TFUnionPayManagerCancelBlock)cancelBlock;

@end
