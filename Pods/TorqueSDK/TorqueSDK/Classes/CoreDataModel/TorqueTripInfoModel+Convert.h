//
//  TorqueTripInfoModel+Convert.h
//  TorqueSDK
//
//  Created by huxianchen on 15/3/10.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import "TorqueTripInfoModel.h"
#import "TorqueTripInfo.h"

@interface TorqueTripInfoModel (Convert)


- (TorqueTripInfoModel *)transferByObject:(TorqueTripInfo *)info;

- (TorqueTripInfo *)transferToObject;

- (NSMutableDictionary *)transferToDict;

@end
