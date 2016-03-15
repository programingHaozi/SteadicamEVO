//
//  TorqueResult.m
//  TorqueSDK
//
//  Created by sunxiaofei on 15/3/4.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import "TorqueResult.h"

@implementation TorqueResult

- (instancetype)init {
    if (self = [super init]) {
        _succeed = NO;
        _result = -1;
    }
    return self;
}

@end
