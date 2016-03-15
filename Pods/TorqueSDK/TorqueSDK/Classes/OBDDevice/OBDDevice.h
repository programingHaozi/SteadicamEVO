//
//  OBDDevice.h
//  OBD-DEMO
//
//  Created by zhangjipeng on 1/23/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import "Torque.h"
#import "DeviceInfo.h"
#import "OBDInfo.h"
#import "DataProcessor.h"
#import "OBDDeviceSelfDefineType.h"
#import "Connector.h"
#import "ConnectorFactory.h"
#import "OBDDataItem.h"
#import "OBDDataStream.h"
#import "OBDDeviceFuncMacro.h"


@interface OBDDevice : Torque

@property (nonatomic, readonly) BOOL deviceIsConnected;              // 是否已连接
@property (nonatomic, strong) DeviceInfo *deviceInfo;
@property (nonatomic, assign) TorqueDeviceConnetMode connectMode;
@property (nonatomic, strong) DataProcessor *dataProcessor;
@property (nonatomic, copy) void(^log)(NSString *message);
@property (nonatomic) NSUInteger maxTripCount;
@property (nonatomic) NSUInteger batchTripCount;//批量删或读设置的count
@property (nonatomic) NSUInteger batchTripSuccessCount;//每批成功读取的count 如果批量读取过程中遇到error 则只删除 error之前成功读取的数据

@property (nonatomic) BOOL isReadOBDSucess;

//批量读取的时候 数据流不继续吐数据 响应回调
@property (nonatomic, strong) NSDate *lastDate;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) void (^completionHistory)(NSError *error);
@property (nonatomic, strong) void (^nextHistory)(TorqueData *tripRecord, NSError *error);

/**
 *  是否统一使用批量获取行程算法
 *  说明：盒子固件版本号>=4.0时，530和531盒子获取行程算法统一使用批量读取算法
 */
@property (nonatomic) BOOL useBatchFetch;

/**
 *  搜索设备
 *
 *  @param completion 返回设备列表
 */
- (void)discoverDeviceForMode:(TorqueDeviceConnetMode)mode
                   completion:(void (^)(NSArray *devices))completion;

/**
 *  逐个搜索设备
 *
 *  @param mode   连接模式
 *  @param next   搜索到的一个设备的name
 *  @param completion 搜索是否超时
 *  @param errorBlock 错误处理block
 */
- (void)discoverDeviceForMode:(TorqueDeviceConnetMode)mode
                         next:(BOOL (^)(NSString *deviceName))next
                   completion:(void (^)(BOOL timeout))completion
                        error:(void (^)(NSError *error))errorBlock;
/**
 *  连接设备
 *
 *  @param mode               连接模式
 *  @param needAuthentication 是否需要鉴权
 *  @param completion         连接完成时的回调block， result： 0 成功，1 未发现设备，2 失败，3 密码鉴权超时
 *  @param disconnection      断开连接时的回调
 */
- (void)connectWithMode:(TorqueDeviceConnetMode)mode
     needAuthentication:(BOOL)needAuthentication
             completion:(void (^)(NSInteger result))completion
          disconnection:(void (^)(NSError *error))disconnection;
/**
 *  连接设备
 *
 *  @param mode       连接模式，0 BT, 1 WIFI
 *  @param completion 连接完成时的回调block， result： 0 成功，1 未发现设备，2 失败，3 密码鉴权超时
 */
- (void)connectWithMode:(TorqueDeviceConnetMode)mode
             completion:(void (^)(NSInteger result))completion
          disconnection:(void (^)(NSError *error))disconnection;

/**
 *  车辆是否进入怠速状态
 *
 *  @param completion 回调
 */
- (void)engineIsIdling:(void (^)(BOOL result))completion;

/**
 *  车辆是否进入启动
 *
 *  @param completion 回调
 */
- (void)engineIsIdlingWithMode:(void (^)(NSInteger result))completion;

/**
 *  断开连接
 */
- (void)disconnect;

#if 0
/**
 *  重新连接
 *
 *  @param mode          连接模式
 *  @param completion    连接完成时的回调block， result： 0 成功，1 未发现设备，2 失败，3 密码鉴权失败
 *  @param disconnection 连接断开回调
 */
- (void)reConnectWithMode:(TorqueDeviceConnetMode)mode
               completion:(void (^)(NSInteger result))completion
            disconnection:(void (^)(NSError *error))disconnection;
#endif

/**
 *  校准总里程
 *
 *  @param distance 汽车仪表盘上显示的总里程
 */
- (void)resetTotalDistance:(NSUInteger)distance
                completion:(void (^)(TorqueResult *result))completion;

/**
 *  读取vin码
 *
 *  @param completion 读取vin码的回调block,读取成功error为nil
 */
- (void)readVinCode:(void (^)(NSString *vinCode,TorqueResult *result))completion;


/**
 *  读取obd信息
 *
 *  @param completion 读取结束的回调block,读取成功error为nil
 */
- (void)readObdInfo:(void (^)(OBDInfo *obdInfo,NSError *error))completion;

/**
 *  读取obd RTC日期时间
 *
 *  @param completion
 */
- (void)readObdRTCDate:(void (^)(NSDate *date,NSError *error))completion;

/**
 *  设置obd RTC日期时间
 *
 *  @param date 日期时间
 *  @param completion 设置完成时的回调block， result： 0 成功，1 失败
 */
- (void)setObdRTCDate:(NSDate *)date
           completion:(void (^)(NSInteger result))completion;

/**
 *  恢复出厂设置
 *
 *  @param completion
 */
- (void)restoreFactorySettings:(void (^)(NSError *error))completion;

@end
