//
//  WifiConnector.m
//  OBD-DEMO
//
//  Created by zhangjipeng on 1/26/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import "WifiConnector.h"

@implementation WifiConnector

@dynamic connectMode;

+ (instancetype)sharedInstance {
    static WifiConnector *wifiConnector = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        wifiConnector = [WifiConnector new];
    });
    return wifiConnector;
}

- (TorqueDeviceConnetMode)connectMode {
    return TorqueDeviceConnetModeWIFI;
}

- (void)discoverDevice:(void (^)(NSArray *devices))completion {

}

- (void)discoverDeviceNext:(BOOL (^)(NSString *deviceName))next completion:(void (^)(BOOL timeout))completion error:(void (^)(NSError *error))errorBlock {
    
}

- (void)connectDevice:(DeviceInfo *)device withConfidential:(DeviceConfidential *)confidential AndDataProcessor:(DataProcessor *)dataProcessor completion:(void (^)(NSInteger result))completion disconnection:(void (^)(NSError *))disconnection {
    
}

- (void)disconnect {
    
}

- (void)writeCommand:(NSString *)command {
    
}

- (void)sendData:(NSData *)data onFinish:(void(^)(NSError *error))onFinish {
    
}

- (void)sendData:(NSData *)data {
    
}

- (void)reConnectDevicewithConfidential:(DeviceConfidential *)confidential completion:(void (^)(NSInteger))completion disconnection:(void (^)(NSError *))disconnection {

}

@end
