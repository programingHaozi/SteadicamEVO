//
//  TFBaseUtil+Tel.h
//  TFBaseLib
//
//  Created by xiayiyong on 15/10/16.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFBaseUtil.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  是否可以打电话
 *
 *  @return 可以返回YES
 */
BOOL tf_canTel(void);

/**
 *  打电话
 *
 *  @param phoneNumber phoneNumber
 */
void tf_tel(NSString* phoneNumber);

/**
 *  打电话
 *
 *  @param phoneNumber phoneNumber
 */
void tf_telprompt(NSString* phoneNumber);

@interface TFBaseUtil (Tel)

/**
 *  是否可以打电话
 *
 *  @return 可以返回YES
 */
+ (BOOL)canTel;

/**
 *  打电话
 *
 *  @param phoneNumber phoneNumber
 */
+ (void)tel:(NSString*)phoneNumber;

/**
 *  打电话
 *
 *  @param phoneNumber phoneNumber
 */
+ (void)telprompt:(NSString*)phoneNumber;

@end
