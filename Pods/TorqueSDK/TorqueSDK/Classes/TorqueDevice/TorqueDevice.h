//
//  TorqueDevice.h
//  OBD-DEMO
//
//  Created by zhangjipeng on 1/23/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TorqueEquipment.h"
#import "TorqueTypeDefine.h"
#import "CarInfo.h"
#import "UserInfo.h"
#import "DeviceInfo.h"
#import "OBDInfo.h"
#import "DeviceCheckUpgradeModel.h"
#import "IAPInfo.h"

@interface TorqueDevice : TorqueEquipment

@property (nonatomic, readonly) BOOL deviceIsConnected;              // 是否已连接
@property (nonatomic, readonly) BOOL needResetTotalDistance;   // 是否需要校准总里程
@property (nonatomic) TorqueDeviceConnetMode connectMode;


/**
 *  发现设备，app每次启动时需要调用该函数
 *
 *  @param user       用户信息
 *  @param mode       连接模式
 *  @param completion 检查结果，succeed:YES[成功]/NO[失败] result：-1 失败, 0 注册过的设备已连接，1 未注册设备，2 未发现已注册设备，请检查硬件是否正确插入，3 盒子插拔过， 4 蓝牙初始化失败(蓝牙未开启)
 */
- (void)discoverDeviceForUser:(UserInfo *)user WithMode:(TorqueDeviceConnetMode)mode completion:(void (^)(TorqueResult *result))completion disconnection:(void (^)(NSError *error))disconnection;

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
 *  获取用户名下的所有设备
 *
 *  @param user       用户
 *  @param completion 回调 succeed:YES[成功]/NO[失败] result：-1, 失败, 0 成功
 */
- (void)getDevicesForUser:(UserInfo *)user compeltion:(void (^)(NSArray *devices, TorqueResult *result))completion;

/**
 *  注册设备
 *
 *  @param device 设备信息
 *  @param completion 注册完成时的回调block，succeed:YES[成功]/NO[失败] result：-1, 失败, 0 成功，1 未绑定手机号，2 该设备已被其他账号绑定，3 该设备已被该账号绑定，4 用户id不能为空，5 设备不存在，请联系客服确认
 */
- (void)registerDevice:(DeviceInfo *)device forUser:(UserInfo *)user completion:(void (^)(TorqueResult *result))completion;

/**
 *  解绑设备
 *
 *  @param device 设备信息
 *  @param completion 解绑完成时的回调block，succeed:YES[成功]/NO[失败] result： ，-1, 失败 0 成功，1 用户id不能为空/sn不能为空，2 没找到设备, 3 验证码错误
 */
- (void)unregisterDevice:(DeviceUserQueryModel *)device completion:(void (^)(TorqueResult *result))completion;

/**
 *  连接设备，调用注册设备接口之后调用
 *
 *  @param mode       连接模式
 *  @param completion 连接完成时的回调block， result： 0 成功，1 未发现设备，2 失败, 3 密码鉴权失败， 4 蓝牙初始化失败(蓝牙未开启)
 */
- (void)connectWithMode:(TorqueDeviceConnetMode)mode completion:(void (^)(NSInteger result))completion disconnection:(void (^)(NSError *error))disconnection;

#if USE_ANONYMOUS_MODE

/**
 *  发现设备，app每次启动时需要调用该函数
 *
 *  @param mode       连接模式，0 BT, 1 WIFI
 *  @param completion 检查结果，result：0 已连接，1 未发现设备，请检查硬件是否正确插入，2 失败
 */
- (void)discoverDeviceWithMode:(TorqueDeviceConnetMode)mode completion:(void (^)(NSInteger result))completion disconnection:(void (^)(NSError *error))disconnection;


#endif

/**
 *  连接设备，调用注册设备接口之后调用
 *
 *  @param device    需要连接的设备
 *  @param completion succeed:YES[成功]/NO[失败] result：-1 失败, 0 注册过的设备已连接，1 未注册设备，2 未发现已注册设备，请检查硬件是否正确插入，3 盒子插拔过， 4 蓝牙初始化失败(蓝牙未开启)
 */
- (void)connectWithDevice:(DeviceInfo *)device completion:(void (^)(TorqueResult *result))completion disconnection:(void (^)(NSError *error))disconnection;

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
- (void)reConnectWithMode:(TorqueDeviceConnetMode)mode completion:(void (^)(NSInteger result))completion disconnection:(void (^)(NSError *error))disconnection;
#endif

/**
 *  识别车辆
 *
 *  @param completion 完成时的回调block succeed:YES[成功]/NO[失败] result： -1, 失败,读取车辆VIN码失败，需要手动输入VIN码,  0 成功，1 盒子插拔过，但没有换车，仅需要校准总里程，2 盒子插拔过，该车是已有车辆，需要恢复出厂设置并校准总里程, 3 盒子插拔过，该车尚未注册，需要注册车辆、恢复出厂设置并校准总里程
 */
- (void)recognizeCar:(void (^)(NSString *vinCode, TorqueResult *result))completion;

/**
 *  获取用户名下的所有车辆
 *
 *  @param user       用户
 *  @param completion 回调 succeed:YES[成功]/NO[失败]
 */
- (void)getCarsForUser:(UserInfo *)user compeltion:(void (^)(NSArray *cars, TorqueResult *result))completion;

/**
 *  设置车辆信息
 *
 *  @param car 车辆信息
 *  @param completion 设置完成时的回调block，succeed:YES[成功]/NO[失败] result：-1 失败, 0 成功，1 该车已在其他账号使用，2 vin获取失败，3 车辆已被注册(vin)
 */
- (void)setCarInfo:(CarInfo *)car completion:(void (^)(TorqueResult *result))completion;

/**
 *  是否需要校准总里程
 *
 *  @param completion 回调
 */
- (void)isNeedAdjustTotalDistance:(void (^)(BOOL result))completion;

/**
 *  校准总里程
 *
 *  @param distance 汽车仪表盘上显示的总里程
 *  @param completion 设置完成时的回调block，succeed:YES[成功]/NO[失败] result：-1 失败, 0 成功
 */
- (void)resetTotalDistance:(NSUInteger)distance completion:(void (^)(TorqueResult *result))completion;

/**
 *  获取上次校准里程日期
 *
 *  @return 上次校准里程日期
 */
- (NSDate *)getLastResetTotalDistanceDate;

/**
 *  读取vin码
 *
 *  @param completion 读取vin码的回调block,读取成功error为nil
 */
- (void)readVinCode:(void (^)(NSString *vinCode,TorqueResult *result))completion;

/**
 *  设置vin码
 *
 *  @param vinCode 要设置的vin码
 *  @param completion 设置vin码的回调block,读取成功error为nil
 */
- (void)setVinCode:(NSString *)vinCode completion:(void (^)(TorqueResult *result))completion;
/**
 *  读取盒子中保存的vin码
 *
 *  @param completion 读取盒子中保存的vin码回调block,读取成功error为nil
 */
- (void)readLastVin:(void (^)(NSString *vinCode, TorqueResult *result))completion;

/**
 *  读取obd信息
 *
 *  @param completion 读取结束的回调block,读取成功error为nil
 */
- (void)readObdInfo:(void (^)(OBDInfo *obdInfo,NSError *error))completion;


/**
 *  恢复出厂设置
 *
 *  @param completion
 */
- (void)restoreFactorySettings:(void (^)(NSError *error))completion;

/**
 *  通过设备SN获取用户信息
 *
 *  @param device     设备对象，需初始化SN属性
 *  @param completion 设置完成时的回调block，succeed:YES[成功]/NO[失败] result： -1 失败, 0 成功，1 用户信息未发现
 */
- (void)getUserInfoBySN:(DeviceInfo *)device completion:(void (^)(UserInfo *userInfo, TorqueResult *result))completion;

/**
 *  发送短信验证码
 *
 *  @param queryModel   包含手机号、SN的查询对象信息
 *  @param completion   设置完成时的回调block，succeed:YES[成功]/NO[失败] result： -1 失败, 0 成功
 */
- (void)getSmsCode:(DeviceUserQueryModel *)queryModel completion:(void (^)(TorqueResult *result))completion;

/**
 *  解析扫描的二维码
 *
 *  @param code 原始二维码
 *
 *  @return 返回对象
 */
- (DeviceInfo *)decodeDeviceQRCode:(NSString *)code;

/**
 *  升级固件
 *
 *  @param softwarePath 固件的路径
 *
 *  @param progressBlock 升级进度回调  progressPercent 进度（小数） message 进度信息
 *
 *  @param completion 升级结束后的回调  result.success: YES 成功，NO 失败    result.result: 2 正在进行初始化倒计时（失败时进行） 0 倒计时结束 1 升级成功
 */
- (void)upgradeWithSoftwarePath:(NSString *)softwarePath progressBlock:(void(^)(float progressPercent, NSString * message))progress completion:(void (^)(OBDInfo *obdInfo, TorqueResult * result))completion;

/**
 *  检查固件升级
 *
 *  @param sn sn号
 *
 *  @param sdkVersion sdk版本（暂时未定，输入任意字符）
 *
 *  @param completion 升级结束后的回调block, succeed:YES[成功]/NO[失败] result.result： 1 有更新, 0 无更新，-1 请求失败
 */
- (void)checkDeviceUpdateWithSdkVersion:(NSString *)sdkVersion sn:(NSString *)sn completion:(void (^)(DeviceCheckUpgradeModel *deviceUpgradeInfo, TorqueResult *result))completion;

/**
 *  下载最新固件
 *
 *  @param path 固件存放文件夹路径
 *
 *  @param urlString 固件下载地址
 *
 *  @param completion 升级结束后的回调block, succeed:YES[成功]/NO[失败] result.success： YES 成功， NO 失败
 */

- (void)downloadSoftwareWithOutputPath:(NSString *)path urlString:(NSString *)urlString completion:(void (^)(NSString *filePath, TorqueResult *result))completion;

/**
 *  上传最新固件信息
 *
 *  @param deviceInfo 固件信息，包括sn，硬件版本，软件版本，userId
 *
 *  @param completion 升级结束后的回调block, succeed:YES[成功]/NO[失败] result.reslut： 0 成功， -1 失败
 */
- (void)uploadUpgradeResultWithobdInfo:(DeviceInfo *)deviceInfo completion:(void (^)(TorqueResult *result))completion;

/**
 *  通过设备SN查询当前设备的IAP是否需要升级
 *
 *  @param deviceSn   设备SN
 *  @param completion 完成后回调, succeed:YES[成功]/NO[失败] result.reslut： 0 成功， -1 失败
 */
- (void)checkIAPUpdateBySn:(NSString *)deviceSn completion:(void (^)(IAPInfo *iapInfo, TorqueResult *result))completion;

/**
 *  清除盒子是否插拔过标记
 *
 *  @param completion
 */
- (void)clearPullOutFlag:(void (^)(BOOL result))completion;

//xyy
- (void)editCarModel:(EditCarModel *)car completion:(void (^)(TorqueResult *result))completion;

@end
