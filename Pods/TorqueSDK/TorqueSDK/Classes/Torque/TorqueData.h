//
//  TorqueData.h
//  TorqueSDK
//
//  Created by zhangjipeng on 1/29/15.
//  Copyright (c) 2015 chexiang. All rights reserved.
//

#import "Torque.h"
#import "OBDDataItem.h"
#import "OBDDataStream.h"
#import "OBDDeviceSelfDefineType.h"


@interface TorqueData : Torque

- (instancetype)initWithDataStream:(OBDDataStream *)stream;
- (instancetype)initWithArray:(NSArray *)items;

@end
