//
//  TorqueCommon.h
//  TorqueSDK
//
//  Created by sunxiaofei on 15/3/9.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TorqueSDK.h"
#import "ReleaseNote.h"
#import "ValidateVinCode.h"

/**
 *  通用方法类
 */
@interface TorqueCommon : TorqueEquipment

/**
 *  当前SDK版本信息
 */
@property (nonatomic, strong, readonly) ReleaseNote *version;


/**
 *  是否允许3G模式下上传
 *
 *  @param allow YES 允许, NO 不允许
 */
- (void)isAllow3GUpload:(BOOL)allow;

/**
 *  初始化TorqueSDK，在app每次启动后必须调用该方法用以初始化用户信息、appId信息和token
 *
 *  @param userInfo     用户信息，包含用户Id和手机号
 *  @param appId        appid ［车享宝appId为1]
 *  @param token        token
 *  @param isPRDMode    是否为生产环境
 *  @param completion   操作完成的回调
 */
- (void)initTorqueSDK:(UserInfo *)userInfo appId:(NSString *)appId serverUrl:(NSString *)serverUrl token:(NSString *)token compeltion:(void (^)(TorqueResult *result))completion;

/**
 *  通过设备SN获取当前绑定车辆VIN码
 *
 *  @param deviceSN   设备SN
 *  @param completion 注册完成时的回调block，succeed:YES[成功]/NO[失败] result：-1, 失败, 0 成功, 1 未找到
 */
- (void)getCurrentVinCodeByDeviceSN:(NSString *)deviceSN compeltion:(void (^)(NSString *vinCode, TorqueResult *result))completion;
/**
 *  通过用户ID和设备SN获取二维码加密字符串
 *
 *  @param userId     用户id
 *  @param deviceSN   设备SN
 *  @param completion 注册完成时的回调block，succeed:YES[成功]/NO[失败] result：-1, 失败, 0 成功
 */
- (void)getQRCodeStringByUserId:(NSString *)userId deviceSN:(NSString *)deviceSN compeltion:(void (^)(NSString *codeString, TorqueResult *result))completion;
/**
 *  验证vin码合法性
 *
 *  @param vinCode    VIN码对应的品牌、车系、车款对象，如未匹配的话该对象为空
 *  @param completion 完成后回调
 */
- (void)validateVinCode:(NSString *)vinCode compeltion:(void (^)(ValidateVinCode *validateVinCode, TorqueResult *result))completion;

/**
 *  获取所有品牌信息
 *
 *  @param completion 完成时的回调block，succeed:YES[成功]/NO[失败], array为品牌信息列表
 */
- (void)getBrandInfoList:(void (^)(NSArray *array, TorqueResult *result))completion;
/**
 *  通过品牌ID查询车系信息
 *
 *  @param brandId    品牌ID
 *  @param completion 完成时的回调block，succeed:YES[成功]/NO[失败], array为车系信息列表
 */
- (void)getSeriesInfoListByBrandId:(NSNumber *)brandId completion:(void (^)(NSArray *array, TorqueResult *result))completion;
/**
 *  通过车系ID查询车型信息
 *
 *  @param seriesId    车系ID
 *  @param completion 完成时的回调block，succeed:YES[成功]/NO[失败], array为车型信息列表
 */
- (void)getModelInfoListBySeriesId:(NSNumber *)seriesId completion:(void (^)(NSArray *array, TorqueResult *result))completion;

@end
