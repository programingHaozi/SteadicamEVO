//
//  DataSync.h
//  TorqueSDK
//
//  Created by huxianchen on 15/3/8.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataSync : NSObject

/**
 *  本次同步多少条信息
 */
@property (nonatomic, readonly) NSInteger count;

/**
 *  本次同步大约需要多上时间, 精确到 秒.毫秒
 */
@property (nonatomic, readonly) float  costDate;

@end
