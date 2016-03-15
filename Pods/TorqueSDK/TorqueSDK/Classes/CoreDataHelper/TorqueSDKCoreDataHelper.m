//
//  TorqueSDKCoreDataHelper.m
//  TorqueSDK
//
//  Created by huxianchen on 15/3/8.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import "TorqueSDKCoreDataHelper.h"


@implementation TorqueSDKCoreDataHelper

+ (TorqueSDKCoreDataHelper *)sharedInstance {
    static TorqueSDKCoreDataHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TorqueSDKCoreDataHelper alloc] initWithResourceInfo:kResource
                                                           extensionName:kExtension
                                                              sqliteName:kSqliteName
                                                               useBundle:YES];
    });

    return instance;
}


@end
