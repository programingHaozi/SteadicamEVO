//
//  JsonRequest+PID.m
//  TorqueSDK
//
//  Created by sunxiaofei on 6/5/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import "JsonRequestForPID.h"
#import "NSString+Date.h"

@implementation JsonRequestForPID

- (instancetype)init {
    if (self = [super init]) {
        //_examId = [[NSUUID UUID] UUIDString];
    }
    return self;
}

- (NSString *)examId {
    if (!_examId && self.carId) {
        _examId = [NSString stringWithFormat:@"%@_%@", self.carId, [NSString stringFromDate:[NSDate date] ForDateFormatter:@"yyyyMMddHHmmss"]];
    }
    return _examId;
}

@end
