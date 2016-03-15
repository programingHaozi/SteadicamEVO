//
//  BaseQueryModel.h
//  TorqueSDK
//
//  Created by sunxiaofei on 5/27/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseQueryModel : NSObject

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *sn;
@property (nonatomic, strong) NSString *vinCode;
@property (nonatomic, strong) NSString *deviceId;
@property (nonatomic, strong) NSString *appId;

/**
 *  查询起始日期
 */
@property (nonatomic, strong) NSString *from;
/**
 *  查询结束日期
 */
@property (nonatomic, strong) NSString *to;

/**
 *  当前页码
 */
@property (nonatomic, assign) NSInteger pageIndex;

/**
 *  获取数据数量
 */
@property (nonatomic, assign) NSInteger count;

@end
