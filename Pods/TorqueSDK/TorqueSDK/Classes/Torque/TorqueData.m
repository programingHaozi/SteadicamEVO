//
//  TorqueData.m
//  TorqueSDK
//
//  Created by zhangjipeng on 1/29/15.
//  Copyright (c) 2015 chexiang. All rights reserved.
//

#import "TorqueData.h"


@implementation TorqueData

- (instancetype)initWithDataStream:(OBDDataStream *)stream {
    return [self initWithArray:stream.items];
}

- (instancetype)initWithArray:(NSArray *)items {
    return nil;
}

@end