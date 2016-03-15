//
//  Connector.h
//  OBD-DEMO
//
//  Created by zhangjipeng on 1/26/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TorqueTypeDefine.h"
#import "DeviceConfidential.h"
#import "DeviceInfo.h"


@class DataProcessor;

@protocol Connector <NSObject>

@property (nonatomic) TorqueDeviceConnetMode connectMode;

/**
 *  搜索设备
 *
 *  @param completion 返回设备列表
 */
- (void)discoverDevice:(void (^)(NSArray *devices))completion;

/**
 *  逐个搜索设备
 *
 *  @param next   搜索到的一个设备的name
 *  @param completion 搜索是否超时
 *  @param errorBlock 错误处理block
 */
- (void)discoverDeviceNext:(BOOL (^)(NSString *deviceName))next completion:(void (^)(BOOL timeout))completion error:(void (^)(NSError *error))errorBlock;

/**
 *  连接设备
 *
 *  @param device        盒子的相关信息，包含sn、蓝牙名称
 *  @param confidential  连接时需要提供的鉴权信息
 *  @param dataProcessor 数据处理，解析device返回的数据
 *  @param completion    连接完成时的回调block， result： 0 成功，1 未发现设备，2 失败
 */
- (void)connectDevice:(DeviceInfo *)device withConfidential:(DeviceConfidential *)confidential AndDataProcessor:(DataProcessor *)dataProcessor completion:(void (^)(NSInteger result))completion disconnection:(void (^)(NSError *error))disconnection;

- (void)reConnectDevicewithConfidential:(DeviceConfidential *)confidential completion:(void (^)(NSInteger result))completion disconnection:(void (^)(NSError *error))disconnection;
/**
 *  断开连接
 */
- (void)disconnect;

/**
 *  向设备写AT命令
 *
 *  @param command AT命令
 */
- (void)writeCommand:(NSString *)command;

/**
 *  向设备写二进制数据
 *
 *  @param data 需要写入设备的数据
 */
//- (void)sendData:(NSData *)data onFinish:(void(^)(NSError *error))onFinish;

/**
 *  向设备写二进制数据
 *
 *  @param data 需要写入设备的数据
 */
- (void)sendData:(NSData *)data;
@end
