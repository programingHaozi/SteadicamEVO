//
//  DeviceCheckUpgradeModel.h
//  TorqueSDK
//
//  Created by Chen Hao 陈浩 on 15/7/8.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceCheckUpgradeModel : NSObject

/**
 *  固件描述
 */
@property (nonatomic, strong) NSString *upgradeDescription;

/**
 *  固件名称
 */
@property (nonatomic, strong) NSString *softwareName;

/**
 *  固件创建时间
 */
@property (nonatomic, strong) NSString *createTime;

/**
 *  是否有更新标志，1：有更新；0：无更新
 */
@property (nonatomic, assign) int resultCode;

/**
 *  固件下载地址
 */
@property (nonatomic, strong) NSString *url;

/**
 *  固件版本号
 */
@property (nonatomic, strong) NSString *version;

/**
 *  固件所属的硬件版本
 */
@property (nonatomic, strong) NSString *prdVersion;
@end
