//
//  CarInfoModel.h
//  TorqueSDK
//
//  Created by sunxiaofei on 15/3/10.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TorqueContextModel, UserInfoModel;

@interface CarInfoModel : NSManagedObject

@property (nonatomic, retain) NSNumber * brand;
@property (nonatomic, retain) NSNumber * manufacturer;
@property (nonatomic, retain) NSNumber * plateNumber;
@property (nonatomic, retain) NSNumber * series;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * vinCode;
@property (nonatomic, retain) NSString * year;
@property (nonatomic, retain) UserInfoModel *userInfo;
@property (nonatomic, retain) TorqueContextModel *torqueContext;

@end
