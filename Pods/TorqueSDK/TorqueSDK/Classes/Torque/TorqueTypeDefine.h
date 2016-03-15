//
//  TorqueTypeDefine.h
//  OBD-DEMO
//
//  Created by zhangjipeng on 1/26/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#ifndef OBD_DEMO_TorqueTypeDefine_h
#define OBD_DEMO_TorqueTypeDefine_h

/**
 *  连接obd硬件设备连接的方式
 */
typedef NS_ENUM(NSUInteger, TorqueDeviceConnetMode){
    /**
     *  通过蓝牙
     */
    TorqueDeviceConnetModeBT = 1,
    /**
     *  通过WIFI
     */
    TorqueDeviceConnetModeWIFI = 2,
};


/**
 *  数据同步类型
 */
typedef NS_ENUM(NSUInteger, TorqueDataSyncType){
    
    /**
     *  动作
     */
    TorqueDataSyncTypeAction = 1,
    
    /**
     *  行程
     */
    TorqueDataSyncTypeTrips = 2,
    
    
    /**
     *  加速测试
     */
    TorqueDataSyncTypeSpeedUp = 3,
    
    /**
     *  检测报告
     */
    TorqueDataSyncTypeExamReport = 4,
    
};

#define KBaffleData       0 //是否开启挡板数据
#define TorqueErrorDomain @"com.chexiang.torque"
typedef NS_ENUM(NSInteger, TorqueDeviceError) {
    TorqueDeviceErrorSuccess = 0,
    TorqueDeviceErrorFailure = 1,
    
    TorqueDeviceErrorGetVinFailed = 2,
    TorqueDeviceErrorPullOut = 3,
    TorqueDeviceErrorNewCar = 4,
    TorqueDeviceErrorCarchanged = 5,
};



/**
 *  数据同步类型
 */
typedef NS_ENUM(NSInteger, ActionLogType){
    
    
    /**
     *  未知类型
     */
    ActionLogTypeUnknown  = 0,
    
    /**
     *  上次同步时间
     */
    ActionLogTypeLastSyncTime = 1,
    
    /**
     *  上次上传时间
     */
    ActionLogTypeLastUploadTime = 2,
    
    /**
     *  里程校准
     *  需要调用[TorqueGlobal switchActionTypeFromLocal:ActionLogTypeActionResetTotalDistance]转换为服务器端运作类型值
     */
    ActionLogTypeActionResetTotalDistance = 106
};
#define kMessage_notFound                       @"未找到"
#define kMessage_userIdNotNull                  @"用户id为空"
#define kMessage_appidNotNull                   @"appId不能为空"
#define kMessage_torkenNotNull                  @"torken不能为空"
#define kMessage_deviceIdNotNull                @"设备Id不能为空"
#define kMessage_deviceNameNotNull              @"设备名称不能为空"
#define kMessage_smsNotNull                     @"短信验证码不能为空"
#define kMessage_deviceSnNotNull                @"sn不能为空"
//#define kMessage_deviceNotFound                 @"sn不能为空"
#define kMessage_phoneNumberNotNull             @"手机号码不能为空"
#define kMessage_vinCodeNotNull                 @"vinCode不能为空"
#define kMessage_carIdNotNull                   @"车辆Id不能为空"
#define kMessage_fromNotNull                    @"查询起始时间不能为空"
#define kMessage_modelIdNotNull                 @"model不能为空"
#define kMessage_distanceIsZero                 @"里程不能小于1"
#define kMessage_devicePWDNotNull               @"设备签权码不能为空"
#define kMessage_BLEError                       @"手机蓝牙未开启"
#define kMessage_connectSucceed                 @"连接成功"
#define kMessage_connectFailed                  @"连接失败，请稍后再试"
#define kMessage_unRegist                       @"您还未注册车享宝盒"
#define kMessage_deviceNotFound                 @"未发现已注册设备,请检查硬件是否正确插入"
#define kMessage_BoxUnPluged                    @"盒子插拔过"
#define kMessage_NeedProof                      @"系统检测到您插拔过宝盒，为保证车辆数据准确，请校准里程"
#define kMessage_NeedResetFactoryAndProof       @"盒子插拔过，该车是已有车辆,需要恢复出厂设置并校准总里程"
#define kMessage_NeedRegAndResetFactoryAndProof @"系统检测到您更换了一辆新车，请完善车型信息"
#define kMessage_ReadVinFailed                  @"读取车辆VIN码失败"
#define kMessage_pidNotNull                     @"pid不能为空"
#define kMessage_troubleCodeNotNull             @"异常码不能为空"
#define kMessage_sdkVersionNotNull              @"sdk版本不能为空"
#define kMessage_prdVersionNotNull              @"硬件版本不能为空"
#define kMessage_softwareVersionNotNull         @"固件版本不能为空"
#endif
