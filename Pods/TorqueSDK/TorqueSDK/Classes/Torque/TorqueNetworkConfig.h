//
//  TorqueNetworkConfig.h
//  TorqueSDK
//
//  Created by zhangjipeng on 2/3/15.
//  Copyright (c) 2015 chexiang. All rights reserved.
//

#ifndef TorqueSDK_TorqueNetworkConfig_h
#define TorqueSDK_TorqueNetworkConfig_h

#define TorqueSDK_NetWorkFailed -1  //无网络 网络请求失败
#define  TorqueSDK_NerWorkOther -2  //网络请求成功，但参数或某些条件不满足，不返回数据

#import "TorqueError.h"


//SIT
#define kHostSIT  @"https://box.dds.com"

//PRD
#define kHostPRD  @"https://box.chexiang.com"


#define kPort  @""
#define kBaseURL(isPrd)  [NSString stringWithFormat:@"%@%@",(isPrd)?kHostPRD:kHostSIT,([kPort length] ? [NSString stringWithFormat:@":%@",kPort] : @"")]


// 注册设备 path  post
#define kTorqueDeviceRegister @"registerDevice"

// 获取用户名下设备列表 path  get
#define kTorqueDeviceGetListPath @"getDeviceList"
// 获取用户名下设备列表 params
#define kTorqueDeviceGetListParams(userId) @{@"user_id" : userId}

// 获取固件更新 path  get
#define kCheckDeviceUpgradePath @"firmware/checkFirmwareUpdate"
// 获取固件更新 params
#define kCheckDeviceUpgradeParams(sn, sdkVersion)  @{@"sn" : sn, @"sdk_version" : sdkVersion}

// 上传固件更新 path  post
#define kUploadDeviceUpgradeInfoPath @"firmware/otaResult"
// 上传固件更新 params
#define kUploadDeviceUpgradeInfoParams(sn, prdVersion, softwareVersion, userId)  @{@"sn" : sn, @"prd_version" : prdVersion, @"version" : softwareVersion, @"user_id" : userId}

// 获取IPA信息  get
#define kCheckIAPNeedUpgradePath @"/firmware/checkIapUpdate"
// 获取IPA信息 params
#define kCheckIAPNeedUpgradeParams(sn)  @{@"sn" : sn}

// 注册车辆信息 path post
#define kTorqueDeviceRegisterCar @"registerCar"

// 获取用户名下车辆列表 path  get
#define kTorqueDeviceGetCarListPath @"getCarList"
// 获取用户名下车辆列表 params
#define kTorqueDeviceGetCarListParams(userId) @{@"user_id" : userId}


//数据同步
#define kTorqueDeviceDataSyncPath   @"syncdata"
#define kTorqueDeviceDataSyncPathParams(jsonStr   , type, token)   @{@"jsonStr" : jsonStr, @"type" : type, @"token" : token}


/************************************
 * 解绑设备
 * by 孙晓飞 2015.3.3
 ************************************/
// 通过BOX的SN获取用户信息
#define kTorqueDeviceGetUserInfoBySn                @"getUserInfoBySn"
#define kTorqueDeviceGetUserInfoBySnParams(sn)      @{@"sn" : sn}

// 解绑设备
#define kTorqueDeviceUnregisterDevice               @"unregisterDevice"
// 请求验证码
#define kTorqueDeviceGetSmsCode                     @"getSmsCode"

// 获取行程摘要信息
#define kGetTripSummary @"trip/tripSummery"
#define kGetTripSummaryParams(userIds, vinCode, from, to) @{@"user_ids":userIds, @"vin_code":vinCode, @"start_time":from, @"end_time":to}

//获取行程月份数据
#define kGetTripSummaryByMonths @"trip/tripSummaryByMonth"
#define kGetTripSummaryByMonthParams(months, userId, vincode) @{@"months":months, @"user_id":userId,@"vin_code":vinCode}

// 获取行程数据列表
#define kGetTripList @"trip/getTripList"
#define kGetTripListParams(userId, vinCode, from, count) @{@"user_id":userId, @"vin_code":vinCode, @"from":from, @"count":count}

// 获取二维码
#define kGetBarCode                     @"getBarCode"
#define kGetBarCodeParams(sn,userId)    @{@"sn" : sn, @"user_id" : userId}

// 记录Action log
#define kActionLog  @"deviceConnect"

// 获取品牌信息
#define kGetBrandInfoList @"car/brandInfoList"

// 获取车系信息
#define kGetSeriesInfoList @"car/seriesInfoList"
#define kGetSeriesInfoListParams(brandId) @{@"brandId":brandId}

// 获取车型信息
#define kGetModelInfoList @"car/modelInfoList"
#define kGetModelInfoListParams(seriesId) @{@"seriesId":seriesId}

// 验证VIN码格式是否合法
#define kValidateVinCode @"validateVin"
#define kValidateVinParams(vinCode) @{@"vin":vinCode}

// 校准总里程
#define kSyncMileage  @"car/syncMileage"

// 获取检测报告数据列表
#define kGetExamReports @"pid/getExamReports"
#define kGetExamReportsParams(userId/*, deviceId*/, carId, index, count) @{@"userId":userId/*, @"deviceId":deviceId*/, @"carId":carId, @"page_num":index, @"page_size":count, @"is_page" : @(1)}
// 获取车辆所支持的PID指令集
#define kGetSupportPIDs @"/pid/getSupportPIDs"
// 获取PID指令的具体含义
#define kGetDetailPID @"/pid/getDetailPID"
// 获取故障码
#define kGetErrorCode @"/pid/getErrorCode"

// 上传百公里测试结果 (post)
#define kUploadAccTestResult @"acc/save"

// 获取百公里测试统计信息 path
#define kGetAccTestStatisticInfo @"/acc/getAccTestResult"
// 获取百公里测试统计信息 params
#define kGetAccTestStatisticInfoParams(userId,carId) @{@"user_id":userId, @"car_id":@(carId)}
// 获取百公里测试本次统计信息 params
#define kGetAccTestCurrStatisticInfoParams(accTestRecordId) @{@"acc_id":@(accTestRecordId)}

// 获取百公里加速测试历史 path
#define kGetAccTestHistoryRecords @"acc/history"
// 获取百公里加速测试历史 params
#define kGetAccTestHistoryRecordsParams(userId, deviceId, carId, isPage, pageSize, pageIndex) @{@"user_id":userId, @"device_id":deviceId, @"car_id":carId, @"is_page":@(isPage), @"page_size":@(pageSize), @"page_num":@(pageIndex)}

// 获取百公里加速检测详情 path
#define kGetAccTestRecordDetail @"acc/detail"
// 获取百公里加速检测详情 params
#define kGetAccTestRecordDetailParams(accTestRecordId) @{@"acc_id":@(accTestRecordId)}

// 获取百公里加速测试PK信息 path
#define kGetAccTestPKInfo @"acc/pk"
// 获取百公里加速测试PK信息 params
#define kGetAccTestPKInfoParams(accTestRecordId) @{@"acc_id":@(accTestRecordId)}

// 获取上次检测报告
#define KGetLastExamReport @"/pid/getLastExamReport"
#if 0
#define KGetLastExamReportParams(vinCode) @{@"carId":carId}
#else
#define KGetLastExamReportParams(carId,userId) @{@"carId":carId,@"userId":userId}
#endif

// 上传PID数据流和异常码
#define kSavePidAndErrorcode @"/pid/savePidAndErrorcode"

//xyy
#define kEditCarModelPath @"car/editCarModel"

#endif
