//
//  HistoryTripInfo.m
//  TorqueSDK
//
//  Created by zhangjipeng on 2/26/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import "HistoryTripInfo.h"
#import "OBDDataStream.h"
#import "OBDDataItem.h"

@implementation HistoryTripInfo

- (instancetype)initWithArray:(NSArray *)items {
    if (self = [super init]) {
        OBDDataItem *item = items[0];
        _index = item.value.integerValue;
        
        item = items[1];
        _count = item.value.integerValue;
    }
    return self;
}

@end
