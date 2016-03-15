//
//  BTConnectManager.h
//  SteadicamEVO
//
//  Created by Chen Hao 陈浩 on 16/3/15.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTConnectInterFace.h"
#import "BTDeviceModel.h"

/**
 *  BTConnectManager
 */
@interface BTConnectManager : NSObject <BTConnectInterFace>

/**
 *  蓝牙设备Model
 */
@property (nonatomic, strong) BTDeviceModel *deviceModel;

/**
 *  单例方法
 *
 *  @return BTConnectManager
 */
+ (BTConnectManager *)shareInstance;

@end
