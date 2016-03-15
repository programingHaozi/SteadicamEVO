//
//  CarInfoModel+Convert.h
//  TorqueSDK
//
//  Created by huxianchen on 15/3/10.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import "CarInfoModel.h"
#import "CarInfo.h"

@interface CarInfoModel (Convert)

- (CarInfoModel *)transferByObject:(CarInfo *)info;


@end
