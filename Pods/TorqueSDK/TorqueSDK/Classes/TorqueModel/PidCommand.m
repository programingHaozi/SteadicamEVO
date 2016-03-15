//
//  PidCommand.m
//  TorqueSDK
//
//  Created by sunxiaofei on 5/28/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import "PidCommand.h"

@implementation PidCommand
- (id)proxyForJson {
    return @{@"pid" : _pid,
             @"name" : _name,
             @"descriptionContent" : _descriptionContent,
             @"explain" : _explain };
}
@end
@implementation PidModel
- (id)proxyForJson {
    return @{@"pid" : _pid};
}
@end
