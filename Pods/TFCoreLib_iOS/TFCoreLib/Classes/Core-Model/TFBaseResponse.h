//
//  BaseRsp.h
// Treasure
//
//  Created by xiayiyong on 15/7/1.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  返回结果类
 */
@interface TFBaseResponse : NSObject

/**
 *  0为成功 其他为失败错误码
 */
@property (assign, nonatomic) int errorCode;

/**
 * errorCode==0 时的错误描述
 */
@property (strong, nonatomic) NSString* errorMessage;

/**
 * errorCode=0 时的返回结果
 */
@property (strong, nonatomic) id result;

/**
 *  根据错误码来初始化，errorMessage为空字符串
 *
 *  @param errorCode 错误码
 *
 *  @return
 */
-(instancetype)initWithErrorCode:(int)errorCode;

/**
 *  根据错误码和错误描述来初始化
 *
 *  @param errorCode    错误码
 *  @param errorMessage 错误描述
 *
 *  @return
 */
-(instancetype)initWithErrorCode:(int)errorCode errorMessage:(NSString*)errorMessage;

@end
