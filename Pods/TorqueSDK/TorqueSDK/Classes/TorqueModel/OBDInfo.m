//
//  OBDInfo.m
//  OBD-DEMO
//
//  Created by zhangjipeng on 1/23/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import "OBDInfo.h"
#import "OBDDataItem.h"

@implementation OBDInfo

- (instancetype)initWithArray:(NSArray *)items {
    if (self = [super init]) {
        OBDDataItem *item = items[0];
#if USE_EST527
        _protocol = item.value;
        
        item = items[1];
        _sn = item.value;
        
        item = items[2];
        _name = item.value;
        
        item = items[3];
        _hardwareVersion = item.value;
        
        item = items[4];
        _softwareVersion = item.value;
        
#elif USE_EST530
        _sn = item.value;
        
        item = items[1];
        _softwareVersion = item.value;
        
        item = items[2];
        _hardwareVersion = item.value;
    
#endif
    }
    return self;
}

@end
