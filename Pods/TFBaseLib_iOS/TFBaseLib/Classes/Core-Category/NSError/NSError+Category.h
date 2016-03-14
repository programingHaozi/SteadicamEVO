//
//  NSError+Category.h
//  Treasure
//
//  Created by xiayiyong on 15/3/2.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

/**
 * 加密算法错误Error Domin
 */
extern NSString * const kCommonCryptoErrorDomain;

/**
 * 常规错误Error Domin
 */
extern NSString * const kRegularErrorDomain;

@interface NSError (Category)

/**
 * 根据加密算法状态，生成错误对象
 */
+ (NSError *)errorWithCCCryptorStatus:(CCCryptorStatus)status;

/**
 *  根据errorCode创建error
 *
 *  @param errorCode errorCode
 *
 *  @return error
 */
+ (instancetype)errWithErrorCode:(NSInteger )errorCode;

/**
 *  根据errorCode和errorMessage创建error
 *
 *  @param errorCode    errorCode
 *  @param errorMessage errorMessage
 *
 *  @return error
 */
+ (instancetype)errWithErrorCode:(NSInteger )errorCode errorMessage:(NSString*)errorMessage;

@end
