//
//  DataStreamFactory.h
//  TorqueSDK
//
//  Created by zhangjipeng on 1/28/15.
//  Copyright (c) 2015 chexiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OBDDeviceSelfDefineType.h"
#import "OBDDataStream.h"

@interface DataStreamFactory : NSObject

+ (OBDDataStream *)dataStreamForType:(OBDDataStreamType)type;

@end
