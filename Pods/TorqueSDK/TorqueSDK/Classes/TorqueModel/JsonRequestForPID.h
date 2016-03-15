//
//  JsonRequest+PID.h
//  TorqueSDK
//
//  Created by sunxiaofei on 6/5/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import "JsonRequest.h"

/**
 *  PID扩展请求类
 */
@interface JsonRequestForPID : JsonRequest
/**
 *  检测ID
 */
@property (nonatomic, strong) NSString *examId;
@end
