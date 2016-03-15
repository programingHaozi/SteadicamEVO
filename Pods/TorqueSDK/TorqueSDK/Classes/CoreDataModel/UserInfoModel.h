//
//  UserInfoModel.h
//  TorqueSDK
//
//  Created by sunxiaofei on 15/3/10.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CarInfoModel, DeviceInfoModel, TorqueContextModel;

@interface UserInfoModel : NSManagedObject

@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSSet *carInfo;
@property (nonatomic, retain) DeviceInfoModel *deviceInfo;
@property (nonatomic, retain) TorqueContextModel *torqueContext;
@end

@interface UserInfoModel (CoreDataGeneratedAccessors)

- (void)addCarInfoObject:(CarInfoModel *)value;
- (void)removeCarInfoObject:(CarInfoModel *)value;
- (void)addCarInfo:(NSSet *)values;
- (void)removeCarInfo:(NSSet *)values;

@end
