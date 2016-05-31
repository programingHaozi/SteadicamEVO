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

#define kBTConnectManager ([BTConnectManager shareInstance])

/**
 *  蓝牙设备Model
 */
@property (nonatomic, strong) BTDeviceModel *deviceModel;

/**
 *  返回信息
 */
@property (nonatomic, strong) NSString *notifyInfoStr;

/**
 *  单例方法
 *
 *  @return BTConnectManager
 */
+ (BTConnectManager *)shareInstance;

@end
