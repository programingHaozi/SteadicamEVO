//
//  AccTestStatisticInfo.h
//  TorqueSDK
//
//  Created by zhangjipeng on 6/11/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccTestStatisticInfo : NSObject

@property (nonatomic) NSUInteger curTime;       // 本次所用时间 ms
@property (nonatomic) NSUInteger bestTime;      // 个人最好成绩 ms
@property (nonatomic) NSUInteger officialTime;  // 官方成绩 ms
@property (nonatomic) NSUInteger allTime;      // 全国车友平均成绩 ms

@end
