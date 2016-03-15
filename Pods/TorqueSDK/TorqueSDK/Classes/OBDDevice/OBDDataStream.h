//
//  OBDDataStream.h
//  TorqueSDK
//
//  Created by zhangjipeng on 1/28/15.
//  Copyright (c) 2015 chexiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OBDDeviceSelfDefineType.h"

@interface OBDDataStream : NSObject //<NSCoding>

@property (nonatomic, assign, readonly) OBDDataStreamType type;
@property (nonatomic, strong, readonly) NSString *name;                 // 数据流名称，例如：实时数据流
@property (nonatomic, strong, readonly) NSString *command;              // AT命令
@property (nonatomic, strong, readonly) NSString *dataHead;             // 返回数据的头标志
@property (nonatomic, strong, readonly) NSArray *items;                 // 返回数据流里包含的数据项
@property (nonatomic, strong, readonly) NSString *splitString;          // 数据项之间的分隔符
@property (nonatomic, assign, readonly) BOOL disposable;                // 是否是一次性的，例如：一发一收方式的AT命令都是YES，实时数据流为NO

- (instancetype)initWithType:(OBDDataStreamType)type;

@end
