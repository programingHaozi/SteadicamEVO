//
//  DeviceConfidential.h
//  OBD-DEMO
//
//  Created by zhangjipeng on 1/26/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceConfidential : NSObject

/**
 *  连接设备时用于鉴权。 BT 盒子sn后6位， WIFI 待定
 */
@property (nonatomic, strong, readonly) NSString *password;

- (instancetype)initWithPassword:(NSString *)password;

@end
