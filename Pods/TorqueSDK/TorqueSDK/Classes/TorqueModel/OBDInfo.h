//
//  OBDInfo.h
//  OBD-DEMO
//
//  Created by zhangjipeng on 1/23/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TorqueData.h"

@interface OBDInfo : TorqueData

#if USE_EST527
@property (nonatomic, strong) NSString *protocol;         // ECU 通讯协议
@property (nonatomic, strong) NSString *name;             // 蓝牙名称
#endif


@property (nonatomic, strong) NSString *sn;               // 设备序列号
@property (nonatomic, strong) NSString *hardwareVersion;  // 硬件版本号
@property (nonatomic, strong) NSString *softwareVersion;  // 固件版本号

@end
