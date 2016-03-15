//
//  TorqueCarDetection.h
//  TorqueSDK
//
//  Created by zhangjipeng on 1/29/15.
//  Copyright (c) 2015 chexiang. All rights reserved.
//

#import "TorqueEquipment.h"
#import "DetectionReport.h"
#import "DetectReportPage.h"

@interface TorqueCarDetection : TorqueEquipment
+ (instancetype)sharedInstance;

/**
 *  开始检测
 *
 *  @param userId               用户Id
 *  @param deviceId             设备Id
 *  @param carId                车辆Id
 *  @param percentageCompletion 检测进度百分比 [percentage]:检测进度百分比、[itemName]:当前检测项名称
 *  @param completion           检测完成的回调 [itemCount]:检测项数量 [troubleCodeCount]:异常码数量
 */
- (void)doDetection:(NSString *)userId
              deviceId:(NSString *)deviceId
                 carId:(NSString *)carId
  percentageCompletion:(void(^)(CGFloat percentage, NSString *itemName))percentageCompletion
            completion:(void (^)(NSInteger itemCount, NSInteger troubleCodeCount, NSString *examId, TorqueResult *result))completion;

/**
 *  退出并取消检测
 *
 *  @param completion 操作完成的回调
 */
- (void)exitDetection:(void (^)(TorqueResult *result))completion;
/**
 *  获取检测报告列表
 *
 *  @param userId     用户Id
 *  @param deviceId   设备Id
 *  @param carId      车辆Id
 *  @param pageIndex  查询页码
 *  @param count      获取数量
 *  @param completion 完成后的回调
 */
- (void)getDetectionReports:(NSString *)userId
                   deviceId:(NSString *)deviceId
                      carId:(NSString *)carId
                       pageIndex:(NSInteger)pageIndex
                      count:(NSInteger)count
                 completion:(void (^)(DetectReportPage *page, TorqueResult *result))completion;
/**
 *  获取上次车辆检测报告
 *
 *  @param vinCode    carId
 *  @param completion 完成后回调
 */
- (void)requestLastDetectTime:(NSString *)carId withUserId:(NSNumber *)userid completion:(void(^)(DetectionReport *report, TorqueResult *result))completion ;
@end
