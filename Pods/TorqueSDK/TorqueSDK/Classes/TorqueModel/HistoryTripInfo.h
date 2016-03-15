//
//  HistoryTripInfo.h
//  TorqueSDK
//
//  Created by zhangjipeng on 2/26/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import "TorqueData.h"

@interface HistoryTripInfo : TorqueData

/**
 *  当前写地址序号
 */
@property (nonatomic, assign, readonly) NSUInteger index;

/**
 *  OBD已保存的行程统计记录数
 */
@property (nonatomic, assign, readonly) NSUInteger count;

@end
