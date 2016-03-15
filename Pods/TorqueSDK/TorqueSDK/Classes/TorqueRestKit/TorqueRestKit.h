//
//  TorqueRestKit.h
//  TorqueSDK
//
//  Created by zhangjipeng on 2/4/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import "Torque.h"
#import "TorqueNetworkConfig.h"
#import "HttpHeader.h"

@interface TorqueRestKit : Torque


- (void)setHeader:(HttpHeader *)header;

- (void)config;


@end
