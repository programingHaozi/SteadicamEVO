//
//  BTConnectInterFace.h
//  SteadicamEVO
//
//  Created by Chen Hao 陈浩 on 16/3/15.
//  Copyright © 2016年 haozi. All rights reserved.
//

@protocol BTConnectInterFace <NSObject>

@optional

#pragma mark - - - - - - - - - - - - - - - 连接相关 - - - - - - - - - - - - - - -

/**
 *  连接设备
 *
 *  @param completion    连接结束回调
 *  @param disconnection 断开连接回调
 */
- (void)connectWithDevice:(void(^)(TorqueResult *result))completion
           disconnection:(void (^)(NSError *error))disconnection;

/**
 *  连接设备 (直连)
 *
 *  @param completion    连接结束回调 
 *  @param disconnection 断开连接回调
 */
- (void)connectWithMode:(void (^)(TorqueResult *result))completion
        disconnection:(void (^)(NSError *error))disconnection;

/**
 *  断开与OBD设备的连接
 */
- (void)disconnectOBDDevice;

@end
