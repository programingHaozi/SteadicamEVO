//
//  Torque+Private.m
//  OBD-DEMO
//
//  Created by zhangjipeng on 1/23/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import "Torque+Private.h"
#import <objc/runtime.h>

@implementation Torque (Private)

@dynamic obdDevice;

- (OBDDevice *)obdDevice {
    //return objc_getAssociatedObject(self, @selector(obdDevice));
    return [OBDDevice sharedInstance];
}



@end
