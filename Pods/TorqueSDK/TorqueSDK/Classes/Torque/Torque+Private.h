//
//  Torque+Private.h
//  OBD-DEMO
//
//  Created by zhangjipeng on 1/23/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import "Torque.h"
#import "OBDDevice.h"

@interface Torque (Private)

@property (nonatomic, strong, readonly) OBDDevice *obdDevice;

@end
