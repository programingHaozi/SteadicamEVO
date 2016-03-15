//
//  TorqueDataSync.h
//  TorqueSDK
//
//  Created by huxianchen on 15/3/2.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import "TorqueEquipment.h"
#import "DataSync.h"

@interface TorqueDataSync : TorqueEquipment


/**
 *  获取本地同步时间
 *
 *  @return 返回上次同步时间
 */
- (NSDate *)getLastDataSyncTime;

/**
 * 获取同步信息
 *
 *  @return 返回同步数据条数及预计需要时间
 */
- (void)getDataSyncInfo:(void(^)(DataSync *dataSync))dataSyncCompletion;


/**
 *  数据同步
 *
 *  @param backgroundSync       是否后台静默同步
 *  @param syncInfoCompletion   同步统计信息
 *  @param percentageCompletion 进度百分比
 *  @param completion           同步完成后的 回调
 */
- (void)dataSync:(int(^)(long count, float costTime))syncInfoCompletion
percentageCompletion:(void(^)(CGFloat percentage))percentageCompletion
      completion:(void(^)(TorqueResult *result))completion;


@end
