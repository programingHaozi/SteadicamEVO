//
//  TroubleCode.m
//  TorqueSDK
//
//  Created by sunxiaofei on 6/9/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import "TroubleCode.h"

@implementation TroubleCode

- (id)proxyForJson {
    return @{@"errorCode" : _troubleCode};
}

@end
