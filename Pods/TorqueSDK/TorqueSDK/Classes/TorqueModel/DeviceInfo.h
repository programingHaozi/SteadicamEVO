//
//  DeviceInfo.h
//  OBD-DEMO
//
//  Created by zhangjipeng on 1/23/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TorqueTypeDefine.h"
#import "BaseQueryModel.h"

@interface DeviceInfo : NSObject
/**
 *  用户id
 */
@property (nonatomic, strong) NSString *userId;
/**
 *  设备序列号
 */
@property (nonatomic, strong) NSString *sn;
/**
 *  鉴权码
 */
@property (nonatomic, strong) NSString *passwd;
/**
 *  设备名称
 */
@property (nonatomic, strong) NSString *name;
/**
 *  车辆vin码
 */
@property (nonatomic, strong) NSString *vinCode;
/**
 *  obd硬件连接方式
 */
@property (nonatomic, assign) TorqueDeviceConnetMode mode;
/**
 *
 */
@property (nonatomic, strong) NSString *deviceId;
/**
 *
 */
@property (nonatomic) NSUInteger mileage;

/**
 *  设备硬件版本
 */
@property (nonatomic, strong) NSString *hardwareVersion;
/**
 *  设备软件版本
 */
@property (nonatomic, strong) NSString *softwareVersion;
/**
 *  发售渠道id
 */
@property (nonatomic, assign) int       channelId;
/**
 *  发售渠道类型
 */
@property (nonatomic, assign) int       channelType;
/**
 *  电池电压
 */
@property (nonatomic, assign) int       batteryVoltage;
/**
 *  流量余额
 */
@property (nonatomic, assign) int       flowBalance;
/**
 *  运营商, 0 移动，1 联通，2 电信
 */
@property (nonatomic, assign) int       serviceProvider;
/**
 *  发动机转速 （rpm)
 */
@property (nonatomic, assign) int       theCharges;
/**
 *  status 1 正常 ,2 欠费* ,3 未激活 ,4 低电压
 */
@property (nonatomic, assign) int       status;
/**
 *  手机号
 */
@property (nonatomic, strong) NSString *phoneNum;
/**
 *  sim卡编号
 */
@property (nonatomic, strong) NSString *simcardNum;


@end

@interface DeviceUserQueryModel : BaseQueryModel

@property (nonatomic, strong) NSString *smsCode;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, assign) NSInteger type;

@end
