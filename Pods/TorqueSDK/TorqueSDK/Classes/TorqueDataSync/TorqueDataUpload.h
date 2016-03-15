//
//  TorqueDataUpload.h
//  TorqueSDK
//
//  Created by huxianchen on 15/3/9.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import "TorqueEquipment.h"

@interface TorqueDataUpload : TorqueEquipment


/**
 *  定时重复上传
 *  @param allow3G 是否允许3G情况下上传数据
 */
- (void)startDataUploadGCD:(BOOL)allow3G
                completion:(void(^)(TorqueResult *result))completion;


/**
 *  上次上传时间
 *
 *  @return 返回上次上传时间
 */
- (NSDate *)getLastDataUpdateTime;


/**
 *  数据上传
 *
 *
 *  @param percentageCompletion 进度
 *  @param completion           完成后的回调, 其中result.resut 301:用户userId为空 
 *                                                          302:车辆信息vin码为空 303:设备信息sn为空 304:appId为空
 */
- (void)uploadData:(void(^)(CGFloat percentage))percentageCompletion
        completion:(void(^)(TorqueResult *result))completion;


@end
