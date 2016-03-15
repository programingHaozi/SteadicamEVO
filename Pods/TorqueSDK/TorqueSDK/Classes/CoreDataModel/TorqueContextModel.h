//
//  TorqueContextModel.h
//  TorqueSDK
//
//  Created by huxianchen on 15/3/16.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CarInfoModel, DeviceInfoModel, UserInfoModel;

@interface TorqueContextModel : NSManagedObject

@property (nonatomic, retain) NSNumber * uploadBy3g;
@property (nonatomic, retain) CarInfoModel *currCar;
@property (nonatomic, retain) DeviceInfoModel *currDevice;
@property (nonatomic, retain) UserInfoModel *currUser;

@end
