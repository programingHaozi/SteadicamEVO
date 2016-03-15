//
//  validateVinCode.h
//  TorqueSDK
//
//  Created by sunxiaofei on 15/5/13.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TorqueVelModel.h"

typedef enum : NSUInteger {
    /**
     *  验证通过
     */
    ValidateStatusPassed = 1,
    /**
     *  格式不正确
     */
    ValidateStatusErrorFormat = 0,
    /**
     *  不能识别
     */
    ValidateStatusNotrecognize = -1,
} ValidateStatus;

@interface ValidateVinCode : NSObject

@property (nonatomic, assign) ValidateStatus status;
@property (nonatomic, strong) TorqueVelModel *model;

@end
