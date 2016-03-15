//
//  TroubleCode.h
//  TorqueSDK
//
//  Created by sunxiaofei on 6/9/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  异常码模型
 */
@interface TroubleCode : NSObject

/**
 *  异常码
 */
@property (nonatomic, strong) NSString *troubleCode;
/**
 *  相关描述
 */
@property (nonatomic, strong) NSString *descriptionContent;

@end
