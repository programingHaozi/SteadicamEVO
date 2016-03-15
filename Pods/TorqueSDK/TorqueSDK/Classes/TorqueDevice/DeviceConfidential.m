//
//  DeviceConfidential.m
//  OBD-DEMO
//
//  Created by zhangjipeng on 1/26/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import "DeviceConfidential.h"

@implementation DeviceConfidential

- (instancetype)initWithPassword:(NSString *)password {
    if (self = [super init]) {
        _password = password;
    }
    return self;
}

@end
