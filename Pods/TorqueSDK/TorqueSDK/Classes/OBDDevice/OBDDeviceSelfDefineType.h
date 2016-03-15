//
//  OBDDeviceSelfDeineType.h
//  TorqueSDK
//
//  Created by zhangjipeng on 1/28/15.
//  Copyright (c) 2015 chexiang. All rights reserved.
//

#ifndef TorqueSDK_OBDDeviceSelfDefineType_h
#define TorqueSDK_OBDDeviceSelfDefineType_h

#import "TorqueFeature.h"

#define kOBDUpgradeHandshake          (0x7F)    // App发送的握手信号，
#define kOBDUpgradePackageSendEnd     (0xAE)    // App发送给设备，表示所有包已发送完毕
#define kOBDUpgradeBinFileSendEnd     (0xAF)    // App发送给设备，表示BIN文件已发送完毕

#define kReadDataStreamTimeout          (2)     // 读取数据流超时时间（s）
#define kAdjustTotalDistanceTimeout     (2)     // 校准总里程超时时间 (s)
#define kATBackCallTimer                (5)     //发出指令后，接收到盒子返回的最大间隔时间

#if USE_QualityChecking_Mode
#define kScanPeripheralTimeoutSeconds   (10)    // 搜索设备时超时时间（s）
#else
#define kScanPeripheralTimeoutSeconds   (20)    // 搜索设备时超时时间（s）
#endif

#define kPowerOnReasonTimeout           (2)     // 设备启动原因超时时间 （s）
#define kEngineIdlingTimeout            (5)     // 判断是否进入怠速状态超时时间 （s）
#define kAutoUploadWaitTime             (5)     // 网络符合上传条件后，自动上传的等待时间间隔 (s)
#define kAutoUploadTimer                (60.0 * 10) //自动上传行程时间间隔(s)

#if USE_QualityChecking_Mode
#define kAuthenticationTimes            (3)     // 鉴权重试次数
#else
#define kAuthenticationTimes            (6)     // 鉴权重试次数
#endif

#define kAuthenticationTimeinterval     (1.5)   // 鉴权重试时间间隔 (s)
#define kAuthenticationTimeout          ((kAuthenticationTimes + 1) * kAuthenticationTimeinterval)   // 鉴权超时时间 （s）

#define kbinFileName                    @"EST530_V2.0"
#define kUpgradeWaitReconnectTime       (10)    // 进入固件升级模式后，等待设备重启的时间间隔 （s）
#define kUpgradeResendHandshake         (0.2)   // 进入固件升级模式后，重发握手信号的超时时间 （s）
#define kUpgradeWaitReadyTimeout        (10)    // 固件升级模式中，握手完成后等待设备就绪的超时时间 （s）

#define kBluetoothValueSplit          @"\r\n"

#define kEST530HardwareVersion    @"V20150201"       // 530硬件版本号
#define kEST530MaxTripCount    (1024)             // 530最大行程记录条数
#define kEST530BatchTripCount  (1)                // 530批量读取行程count
#define kEST531HardwareVersion    @"V2.0"       // 531硬件版本号
#define kEST531MaxTripCount    (4096)             // 531最大行程记录条数
#define kEST531BatchTripCount  (128)              // 531批量读取行程count

#define kDeviceDisConnectedString @"与设备断开连接"

#define kTorqueNetworkReachabilityStatusON  @"TorqueNetworkReachabilityStatusON"
#define kTorqueNetworkReachabilityStatusOFF @"TorqueNetworkReachabilityStatusOFF"
#define kNotifactionDisConnectedInSDK       @"NotifactionDisConnected_sdk"

#if USE_EST527
#define kDeviceName               @"EST527"
#define kBLEServiceUUID           @"18F0"
#define kBLECharacteristicNofiy   @"2AF0"
#define kBLECharacteristicWrite   @"2AF1"
#define kBLENamePrefix            @"OBD"

#elif USE_EST530
#define kDeviceName               @"EST530"
#define kBLEServiceUUID           @"FFF0"
#define kBLECharacteristicNofiy   @"FFF1"
#define kBLECharacteristicWrite   @"FFF2"
#define kBLENamePrefix            @"torque"

#endif

typedef NS_ENUM(NSInteger, OBDDataStreamType) {
    OBDDataStreamTypeNone                  = -1,

    OBDDataStreamTypeRT                    = 0,// 实时数据流
    OBDDataStreamTypeRTOff                 = 1,// 关闭实时数据流，EST530有效
    OBDDataStreamTypeRTON                  = 2,// 打开实时数据流，EST530有效

    OBDDataStreamTypeAMT                   = 3,// 车辆统计数据流，EST527有效
    OBDDataStreamTypeAMTOff                = 4,// 关闭车辆统计数据流 EST527有效

    OBDDataStreamTypeVIN                   = 5,// 读取车辆vin码 EST527有效

    OBDDataStreamTypeStart                 = 6,// ECU建立连接
    OBDDataStreamTypeStop                  = 7,// ECU断开连接

    OBDDataStreamTypeSleep                 = 8,// 设备休眠

    OBDDataStreamTypeDeviceInfo            = 9,// 当前设备序列号,软件版本号,硬件版本号

    OBDDataStreamTypeGetRTC                = 10,// 获取设备RTC时间
    OBDDataStreamTypeSetRTC                = 11,// 设定设备RTC时间，日期格式必须是:YYYYMMDD hhmmss

    OBDDataStreamTypeGetVIB                = 12,// 获取终端震动唤醒阀值
    OBDDataStreamTypeSetVIB                = 13,// 设置终端震动唤醒阀值

    OBDDataStreamTypeStatus                = 14,// 请求设备启动类型及时间

    OBDDataStreamTypeECUStart              = 15,// 获取设备与 ECU 建立通讯的时间

    OBDDataStreamTypeVI                    = 16,// 获取车辆当前协议类型及 17 位 VIN 码(部分车型支持)

    OBDDataStreamTypeHBT                   = 17,// 获取驾驶习惯数据
    OBDDataStreamTypeDTC                   = 18,// 获取车辆故障码
    OBDDataStreamTypeCDI                   = 19,// 清除当前车辆故障码
    OBDDataStreamTypeADJ                   = 20,// 车辆总里程校准
    OBDDataStreamTypeWST                   = 21,// 重启设备
    OBDDataStreamTypeZ                     = 22,// 恢复出厂设定

    OBDDataStreamTypePIDOn                 = 23,// 进入PID模式
    OBDDataStreamTypePIDOff                = 24,// 退出PID模式
    OBDDataStreamTypePIDCommand            = 1024,// 发送PID指令

    OBDDataStreamTypeACCOn                 = 25,// 进入百公里测试模式
    OBDDataStreamTypeACCStart              = 26,// 开始百公里测试
    OBDDataStreamTypeACCEnd                = 27,// 百公里测试结束
    OBDDataStreamTypeACCOff                = 28,// 退出百公里测试模式

#if 0
    OBDDataStreamTypeACCTerminalNotStart   = 29,// 终止百公里测试模式--不在测试
    OBDDataStreamTypeACCTerminalStarted    = 30,// 终止百公里测试模式--正在测试
    OBDDataStreamTypeACCRestart            = 31,// 重新开始百公里测试
#endif

    OBDDataStreamTypeEnterUpgradeMode      = 32,// 进入固件升级模式
    OBDDataStreamTypeExitUpgradeMode       = 33,// 退出固件升级模式
    OBDDataStreamTypeUpgradeHandshake      = 34,// 固件升级开始时的握手过程
    OBDDataStreamTypeUpgradeReady          = 35,// 固件升级准备就绪
    OBDDataStreamTypeUpgradeSendPackage    = 36,// 固件升级发包数据流
    OBDDataStreamTypeUpgradeSendPackageEnd = 37,// 固件升级发包结束
    OBDDataStreamTypeUpgradeSendBinLength  = 38,// 固件升级发送bin文件长度
    OBDDataStreamTypeUppradeSendBinEnd     = 39,// 固件升级发送bin文件结束

    OBDDataStreamTypeLastTrip              = 40,// 获取最后一次行程统计信息
    OBDDataStreamTypeHistoryTripInfo       = 41,// 获取历史行程统计信息
    OBDDataStreamTypeHistoryTripRecord     = 42,// 获取指定记录行程信息
    OBDDataStreamTypeDeleteHistoryTrip     = 43,// 删除指定行程统计信息
    OBDDataStreamTypeFetchHistoryTripEnd   = 44,// 行程记录到最后一条

    OBDDataStreamTypeReadPullOut           = 50,// 读取设备是否硬件复位过（盒子插拔过）
    OBDDataStreamTypeClearPullOut          = 51,// 清除设备是否硬件复位过（盒子插拔过）
    OBDDataStreamTypeSetLastVin            = 55,// 设置设备上次插在哪个车上（盒子记录车辆VIN）
    OBDDataStreamTypeReadLastVin           = 56,// 读取设备上次插在哪个车上（返回盒子记录的车辆VIN）
    
    OBDDataStreamTypeEngineIdling          = 100,// 车辆是否进入怠速 (0:熄火，1：怠速，2：行驶)

    OBDDataStreamTypeAuthentication        = 110,// 连接之后密码鉴权
    
    OBDDataStreamTypeWriteTrip             = 256,// 写行程（531 beta1.5）

    OBDDataStreamTypeError                 = 0xFF,// 错误消息数据流，处理所有error
};


typedef NS_ENUM(NSInteger, OBDPowerOnReason) {
    OBDPowerOnReasonUnknown                = 0,// 未知
    OBDPowerOnReasonPullOut                = 1,// 硬件复位启动,即用户插拔过盒子
    OBDPowerOnReasonSoftReset              = 2,// 软件复位启动
    OBDPowerOnReasonWatchdog               = 3,// 看门狗复位启动
    OBDPowerOnReasonWakeup                 = 4,// 休眠唤醒启动
};

typedef NS_ENUM(NSInteger, OBDMode) {
    OBDModeNormal                          = 0,// 普通模式
    OBDModePID                             = 1,// PID模式
    OBDModeUpgrade                         = 2,// 升级固件模式
    OBDModeRestore                         = 3,// 固件恢复模式
};

#define OBDErrorDomain @"com.chexiang.obd"
typedef NS_ENUM(NSInteger, OBDError) {
    OBDErrorTimeout                        = -5000,
    OBDErrorReadLastVin,
    OBDErrorDiscoverDeviceFailed,
};

#endif
