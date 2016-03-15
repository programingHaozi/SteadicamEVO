//
//  JsonRequest.m
//  TorqueSDK
//
//  Created by sunxiaofei on 5/28/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import "JsonRequest.h"

@implementation JsonRequest
- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (id)proxyForJson {
    return @{@"jsonString" : _jsonString,
             @"userId" : self.userId ? self.userId : @"",
             @"sn" : self.sn ? self.sn : @"",
             @"vinCode" : self.vinCode ? self.vinCode : @"",
             @"deviceId" : self.deviceId ? self.deviceId : @"",
             @"appId" : self.appId ? self.appId : @"" ,
             @"carId" :_carId ? _carId : @""};
}

@end
