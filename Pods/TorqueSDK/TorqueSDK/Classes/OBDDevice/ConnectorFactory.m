//
//  ConnectorFactory.m
//  TorqueSDK
//
//  Created by zhangjipeng on 1/26/15.
//  Copyright (c) 2015 chexiang. All rights reserved.
//

#import "ConnectorFactory.h"
#import "BlueToothConnector.h"
#import "WifiConnector.h"

@implementation ConnectorFactory

+ (id<Connector>)connectorForMode:(TorqueDeviceConnetMode)mode {
    if (mode == TorqueDeviceConnetModeBT) {
        return [BlueToothConnector sharedInstance];
    } else if (mode == TorqueDeviceConnetModeWIFI) {
        return [WifiConnector sharedInstance];
    } else {
        NSLog(@"error : torque device connect mode is error!");
        return nil;
    }
}

@end
