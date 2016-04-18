//
//  BTConnectInterFace.h
//  SteadicamEVO
//
//  Created by Chen Hao 陈浩 on 16/3/15.
//  Copyright © 2016年 haozi. All rights reserved.
//

@protocol BTConnectInterFace <NSObject>

@optional

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
- (void)discoverDeviceNext:(BOOL (^)(NSString *deviceName))next
                completion:(void (^)(BOOL timeout))completion
                     error:(void (^)(NSError *error))errorBlock;

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
