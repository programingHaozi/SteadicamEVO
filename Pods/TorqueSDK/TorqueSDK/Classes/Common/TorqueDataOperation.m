//
//  TorqueDataOperation.m
//  TorqueSDK
//
//  Created by huxianchen on 15/3/9.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import "TorqueDataOperation.h"
#import "TorqueContextModel.h"
#import "TorqueSDKCoreDataHelper.h"
#import "DeviceInfoModel+Convert.h"
#import "UserInfoModel+Convert.h"
#import "CarInfoModel+Convert.h"
#import "DeviceInfo+Convert.h"
#import "CarInfo+Convert.h"
#import "TorqueGlobal.h"
#import "ActionLog.h"

static TorqueDataOperation *instance = nil;

@implementation TorqueDataOperation

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [TorqueDataOperation new];
        
    });
    return instance;
}

- (void)resetCarInfo:(NSArray *)array
{
    CarInfo *currCar = [self getCurrentCar];
    //先删除所有的设备信息
    [[TorqueSDKCoreDataHelper sharedInstance] deleteObjectsByEntityName:@"CarInfo" predicateWithFormat:currCar ? [NSString stringWithFormat:@"vinCode != '%@'", currCar.vinCode] : nil error:nil];
    
    if (array && array.count) {
        for (CarInfo *info in array) {
            CarInfoModel *model = [[TorqueSDKCoreDataHelper sharedInstance] newByEntityName:@"CarInfo"];
            [model transferByObject:info];
        }
        
        [[TorqueSDKCoreDataHelper sharedInstance] saveContext];
    }
}

- (void)resetDevicesInfo:(NSArray *)array
{
    DeviceInfo *deviceInfo = [self getCurrentDeviceInfo];
    //先删除所有的设备信息
    [[TorqueSDKCoreDataHelper sharedInstance] deleteObjectsByEntityName:@"DeviceInfo" predicateWithFormat:deviceInfo ? [NSString stringWithFormat:@"sn != '%@'", deviceInfo.sn] : nil error:nil];
    
    if (array && array.count) {
        //开始保存
        for (DeviceInfo *info in array) {
            DeviceInfoModel *model = [[TorqueSDKCoreDataHelper sharedInstance] newByEntityName:@"DeviceInfo"];
            [model transferByObject:info];
        }
        
        [[TorqueSDKCoreDataHelper sharedInstance] saveContext];
        [self setCurrentDevice:(DeviceInfo *)array[0]];
    }
 }


- (TorqueContextModel *)getTorqueContext
{
    NSArray *array = [[TorqueSDKCoreDataHelper sharedInstance] fetchedObjectsByEntityName:@"TorqueContext" predicateWithFormat:nil error:nil];
    
    if (array && array.count) {
        return array[0];
    }else{
        TorqueContextModel *model = [[TorqueSDKCoreDataHelper sharedInstance] newByEntityName:@"TorqueContext"];
        
        return model;
    }
}

- (void)setCurrentDevice:(DeviceInfo *)deviceInfo
{
    if (deviceInfo) {
        TorqueContextModel *model = [self getTorqueContext];
        
        if (!model.currDevice) {
            model.currDevice = [[TorqueSDKCoreDataHelper sharedInstance] newByEntityName:@"DeviceInfo"];
        }
        
        [model.currDevice transferByObject:deviceInfo];
        
        [[TorqueSDKCoreDataHelper sharedInstance] saveContext];
    }
}

- (void)setCurrentUser:(UserInfo *)userInfo
{
    if (userInfo) {
        TorqueContextModel *model = [self getTorqueContext];
        
        if (!model.currUser) {
            model.currUser = [[TorqueSDKCoreDataHelper sharedInstance] newByEntityName:@"UserInfo"];
        }
        
        [model.currUser transferByObject:userInfo];
        
        [[TorqueSDKCoreDataHelper sharedInstance] saveContext];
    }
}

- (void)setCurrentCar:(CarInfo *)carInfo
{
    if (carInfo) {
        TorqueContextModel *model = [self getTorqueContext];
        
        if (!model.currCar) {
            model.currCar = [[TorqueSDKCoreDataHelper sharedInstance] newByEntityName:@"CarInfo"];
        }
        [model.currCar transferByObject:carInfo];
        
        [[TorqueSDKCoreDataHelper sharedInstance] saveContext];
    }
}

-(CarInfo *)getCurrentCar
{
    TorqueContextModel *model = [self getTorqueContext];
    
    if (model.currCar) {
        
        CarInfo *carInfo = [CarInfo new];
        [carInfo transferByModel:model.currCar];
        [carInfo setSn:[TorqueGlobal sharedInstance].deviceInfo.sn];
        [carInfo setUserId:[TorqueGlobal sharedInstance].user.userId];
        
        return carInfo;
        
    }
    
    return nil;
    
}

- (NSArray *)getAllCarArray {
    NSArray *array = [[TorqueSDKCoreDataHelper sharedInstance] fetchedObjectsByEntityName:@"CarInfo" predicateWithFormat:nil error:nil];
    NSMutableArray *carArray = [NSMutableArray new];
    if (array && array.count) {
        for (CarInfoModel *model in array) {
            CarInfo *carInfo = [CarInfo new];
            [carInfo transferByModel:model];
            [carInfo setSn:[TorqueGlobal sharedInstance].deviceInfo.sn];
            [carInfo setUserId:[TorqueGlobal sharedInstance].user.userId];
            
            [carArray addObject:carInfo];
        }
    }
    
    return [carArray mutableCopy];
}

- (DeviceInfo *)getCurrentDeviceInfo
{
    
    TorqueContextModel *model = [self getTorqueContext];
    
    if (model.currDevice) {
        
        DeviceInfo *deviceInfo = [DeviceInfo new];
        [deviceInfo transferByModel:model.currDevice];
        
        return deviceInfo;
        
    }
    
    return nil;
}

/**
 *  是否允许3G上传
 */
- (void)setIs3GAllow:(BOOL)is3gAllow {
    TorqueContextModel *model = [self getTorqueContext];
    model.uploadBy3g = @(is3gAllow);;
    
    [[TorqueSDKCoreDataHelper sharedInstance] saveContext];
}

- (ActionLog *)getActionLogModelWithType:(ActionLogType)type {
    NSArray *array = [[TorqueSDKCoreDataHelper sharedInstance] fetchedObjectsByEntityName:@"ActionLog" predicateWithFormat:type > 0 ? [NSString stringWithFormat:@"opType=%lu", (unsigned long)type] : nil error:nil];
    
    if (array && array.count) {
        return array[array.count - 1];
    }
    return nil;
}


/**
 *  设置上次同步时间
 */
- (void)setLastSyncTime:(NSDate *)lastSyncTime {
    ActionLog *actionLog = [[TorqueSDKCoreDataHelper sharedInstance] newByEntityName:@"ActionLog"];
    
    actionLog.opType = @(ActionLogTypeLastSyncTime);
    actionLog.opDate = lastSyncTime;
    
    [[TorqueSDKCoreDataHelper sharedInstance] saveContext];
}
/**
 *  设置上次上传时间
 */
- (void)setLastUpdateTime:(NSDate *)lastUpdateTime {
    
    ActionLog *actionLog = [[TorqueSDKCoreDataHelper sharedInstance] newByEntityName:@"ActionLog"];
    
    actionLog.opType = @(ActionLogTypeLastUploadTime);
    actionLog.opDate = lastUpdateTime;
    
    [[TorqueSDKCoreDataHelper sharedInstance] saveContext];
}


- (NSDate *)getLastSyncTime
{
    ActionLog *actionLog = [self getActionLogModelWithType:ActionLogTypeLastSyncTime];
    
    return actionLog.opDate;
}


- (NSDate *)getLastUpdateTime
{
    ActionLog *actionLog = [self getActionLogModelWithType:ActionLogTypeLastUploadTime];
    
    return actionLog.opDate;
}



- (NSArray *)getTorqueTripInfo
{
    NSArray *array = [[TorqueSDKCoreDataHelper sharedInstance] fetchedObjectsByEntityName:@"TorqueTripInfo" predicateWithFormat:[NSString stringWithFormat:@"isUploaded == FALSE and userId == \'%@\'", [TorqueGlobal sharedInstance].user.userId] error:nil];
    
    
    return array;
}
- (BOOL)tripInfoExist:(TorqueTripInfo *)trip {
    NSArray *array = [[TorqueSDKCoreDataHelper sharedInstance] fetchedObjectsByEntityName:@"TorqueTripInfo" predicateWithFormat:[NSString stringWithFormat:@"isUploaded == FALSE and userId == \'%@\' and startDate == \'%@\' and endDate == \'%@\' and mileage == %f", [TorqueGlobal sharedInstance].user.userId, trip.startDate, trip.endDate, trip.mileage] error:nil];
    return (array && array.count > 0);
}

- (void)setResetTotalDistanceDate:(NSDate *)resetTotalDistanceDate {
    ActionLog *actionLog = [[TorqueSDKCoreDataHelper sharedInstance] newByEntityName:@"ActionLog"];
    
    actionLog.opType = @(ActionLogTypeActionResetTotalDistance);
    actionLog.opDate = resetTotalDistanceDate;
    
    [[TorqueSDKCoreDataHelper sharedInstance] saveContext];
}

- (NSDate *)getLastResetTotalDistanceDate {
    ActionLog *actionLog = [self getActionLogModelWithType:ActionLogTypeActionResetTotalDistance];
    
    return actionLog.opDate;
}

@end
