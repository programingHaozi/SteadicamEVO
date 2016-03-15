//
//  DetectionReport.h
//  TorqueSDK
//
//  Created by sunxiaofei on 5/28/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  检测报告实体类
 */
@interface DetectionReport : NSObject

/**
 *  检测报告ID
 */
@property (nonatomic) NSInteger detectionId;
/**
 *  故障码数量
 */
@property (nonatomic) NSInteger errorCodeNumber;
/**
 *  分数
 */
@property (nonatomic) NSInteger score;
/**
 *  检测时间
 */
@property (nonatomic, strong) NSDate *createTime;
/**
 *  结论
 */
@property (nonatomic, strong) NSString *result;
/**
 *  检测报告详情
 */
@property (nonatomic, strong) NSString *detail;


@end
