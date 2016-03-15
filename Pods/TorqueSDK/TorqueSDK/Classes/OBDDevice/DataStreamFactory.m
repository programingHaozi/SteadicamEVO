//
//  DataStreamFactory.m
//  TorqueSDK
//
//  Created by zhangjipeng on 1/28/15.
//  Copyright (c) 2015 chexiang. All rights reserved.
//

#import "DataStreamFactory.h"


@implementation DataStreamFactory

+ (OBDDataStream *)dataStreamForType:(OBDDataStreamType)type {
    static OBDDataStream *stream = nil;
    if (!stream || stream.type != type) {
        stream = [[OBDDataStream alloc] initWithType:type];
    }
    return stream;
}

@end
