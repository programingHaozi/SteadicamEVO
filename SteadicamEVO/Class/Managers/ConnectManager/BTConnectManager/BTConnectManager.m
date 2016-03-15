//
//  BTConnectManager.m
//  SteadicamEVO
//
//  Created by Chen Hao 陈浩 on 16/3/15.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import "BTConnectManager.h"

@implementation BTConnectManager

+(BTConnectManager *)shareInstance
{
    static BTConnectManager *manager;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [[BTConnectManager alloc]init];
    });
    
    return manager;
}

#pragma mark - - - - - - - - - - - - - - - 连接相关 - - - - - - - - - - - - - - -

/**
 *  连接设备
 *
 *  @param completion    连接结束回调
 *  @param disconnection 断开连接回调
 */
- (void)connectWithDevice:(void(^)(TorqueResult *result))completion
            disconnection:(void (^)(NSError *error))disconnection
{
    __block void (^completionBlock)()    = completion;
    __block void (^disconnectionBlock)() = disconnection;
    
    DeviceInfo *info = [self getOBDDeviceWithBTDevice:self.deviceModel];
    
    [kTorqueDevice connectWithDevice:info completion:^(TorqueResult *result) {
        
        DDLogDebug(@"discoverDeviceForUser result:%ld, message:%@",
                   (long)result.result, result.message);
        
        if (result.succeed)
        {
            DDLogDebug(@"连接成功");
            
            [[NSNotificationCenter defaultCenter]postNotificationName:kNotifactionConnectFinished object:nil];
            
            __block TorqueResult *_result = [TorqueResult new];
            _result.succeed = result.succeed;
            
            
        }
        else
        {
            if (completionBlock)
            {
                completionBlock(result);
                completionBlock = nil;
            }
        }
    } disconnection:^(NSError *error) {
        
        DDLogDebug(@"disconnection error:%@", error.localizedDescription);
        
        if (disconnection)
        {
            disconnection(error);
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifactionDisConnected object:nil];
        
    }];
}

/**
 *  连接设备(直连)
 *
 *  @param completion    连接完成时的回调block， result： 0 成功，1 未发现设备，2 失败, 3 密码鉴权失败
 *  @param disconnection 连接断开回调
 */
- (void)connectDevice:(void (^)(TorqueResult *result))completion
        disconnection:(void (^)(NSError *error))disconnection
{
    
    __block void (^connectBlock)(TorqueResult *result) = completion;
    __block void (^disconnectBolck)(NSError *error) = disconnection;
    
    DeviceInfo *info = [self getOBDDeviceWithBTDevice:self.deviceModel];
    
    // 断开已有连接
    [self disconnectOBDDevice];
    
    // 设置要连接的设备并连接设备
    kTorqueDevice.obdDevice.deviceInfo = info;
    
    [kTorqueDevice connectWithMode:info.mode completion:^(NSInteger result) {
        
        if (connectBlock)
        {
            TorqueResult *connectResult = [TorqueResult new];
            connectResult.result        = result;
            
            if (connectBlock)
            {
                connectBlock(connectResult);
                connectBlock = nil;
            }
            
        }
    } disconnection:^(NSError *error) {
        
        if (disconnectBolck)
        {
            if (disconnectBolck)
            {
                disconnectBolck(error);
                disconnectBolck = nil;
            }
            
            connectBlock = nil;
        }
    }];
}

/**
 *  断开与OBD设备的连接
 */
- (void)disconnectOBDDevice
{
    [kTorqueDevice disconnect];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifactionDisConnected
                                                        object:nil];
}

#pragma mark - - - - - - - - - - - - - - -  Model Conversion - - - - - - - - - - - - - - -

/**
 *  车享宝盒子模型与SDK模型转换
 *
 *  @param cxDevice 车享宝盒子数据模型
 *
 *  @return SDK盒子数据模型
 */
- (DeviceInfo *)getOBDDeviceWithBTDevice:(BTDeviceModel *)BTDevice
{
    DeviceInfo *info     = [[DeviceInfo alloc] init];
//    info.userId          = cxDevice.userId;
//    info.sn              = cxDevice.sn;
//    info.vinCode         = cxDevice.vin;
    info.passwd          = BTDevice.password;
    info.name            = BTDevice.name;
    info.mode            = TorqueDeviceConnetModeBT;
//    info.deviceId        = cxDevice.deviceId;
//    info.hardwareVersion = cxDevice.hardwareVersion;
//    info.softwareVersion = cxDevice.firmwareVersion;
    
    return info;
}

@end
