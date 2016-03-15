//
//  OBDDataItem.m
//  TorqueSDK
//
//  Created by zhangjipeng on 1/27/15.
//  Copyright (c) 2015 chexiang. All rights reserved.
//

#import "OBDDataItem.h"

@implementation OBDDataItem

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        _index = [[dic objectForKey:@"index"] integerValue];
        _splitString = [NSString stringWithString:[dic objectForKey:@"split"]];
        _itemName = [NSString stringWithString:[dic objectForKey:@"itemName"]];
        _unit = [NSString stringWithString:[dic objectForKey:@"unit"]];
    }
    return self;
}

@end
