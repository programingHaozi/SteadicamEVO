//
//  TorqueResult.h
//  TorqueSDK
//
//  Created by sunxiaofei on 15/3/4.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TorqueError.h"

/**
 *  返回值对象，用于回调返回
 */
@interface TorqueResult : NSObject

/**
 *  是否成功
 */
@property (nonatomic, assign) BOOL succeed;

/**
 *  结果代码
 */
@property (nonatomic, assign) NSInteger result;

/**
 *  服务器返回信息
 */
@property (nonatomic, strong) NSString *message;

/**
 *  错误对象
 */
@property (nonatomic, strong) NSError *error;

@end
