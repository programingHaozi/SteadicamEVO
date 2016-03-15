//
//  TorqueGlobal.m
//  TorqueSDK
//
//  Created by sunxiaofei on 15/3/9.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import "TorqueGlobal.h"
#import "TorqueDataOperation.h"
#import "TorqueUtility.h"

@interface TorqueGlobal()

/**
 *  工具类对象
 */
@property (nonatomic, strong) TorqueUtility *utility;

@end
@implementation TorqueGlobal

+ (instancetype)sharedInstance {
    static TorqueGlobal *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [TorqueGlobal new];
        instance.is3GAllow = YES;
        instance.utility = [TorqueUtility new];
    });
    
    return instance;
}

- (void)setUser:(UserInfo *)user
{
    _user = user;
    
    [[TorqueDataOperation sharedInstance] setCurrentUser:user];
}

- (void)setDeviceInfo:(DeviceInfo *)deviceInfo
{
    [[TorqueDataOperation sharedInstance] setCurrentDevice:deviceInfo];
}

- (void)setCarInfo:(CarInfo *)carInfo
{
    [[TorqueDataOperation sharedInstance] setCurrentCar:carInfo];
}


- (CarInfo *)carInfo
{
    return [[TorqueDataOperation sharedInstance] getCurrentCar];
}

- (NSArray *)allCarArray {
    return [[TorqueDataOperation sharedInstance] getAllCarArray];
}

- (DeviceInfo *)deviceInfo
{
    return [[TorqueDataOperation sharedInstance] getCurrentDeviceInfo];
}

- (void)motionNetwork {
    __weak TorqueGlobal *this = self;
    [self.utility motionNetwork:^(TorqueReachability *reach) {
        if (reach.isReachableViaWiFi ||
            reach.isReachableViaWWAN) {
            this.networkStatus = reach.currentReachabilityStatus;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kAutoUploadWaitTime * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
                // 上传数据
                [[TorqueDataUpload sharedInstance] startDataUploadGCD:[TorqueGlobal sharedInstance].is3GAllow completion:^(TorqueResult *result) {
                    
                }];
            });
            // POST网络开启消息
            [[NSNotificationCenter defaultCenter] postNotificationName:kTorqueNetworkReachabilityStatusON object:nil];
        }
    } unreachableBlock:^{
        self.networkStatus = TorqueNotReachable;
        // POST网络断开消息
        [[NSNotificationCenter defaultCenter] postNotificationName:kTorqueNetworkReachabilityStatusOFF object:nil];
    }];
}

+ (NSInteger)switchActionTypeFromLocal:(ActionLogType)actionType {
    NSInteger result = ActionLogTypeUnknown;
    switch (actionType) {
        case ActionLogTypeActionResetTotalDistance:
            result = 6;
            break;
            
        default:
            result = actionType;
            break;
    }

    return result;
}

@end
