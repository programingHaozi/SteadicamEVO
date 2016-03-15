//
//  CarInfo+Convert.h
//  TorqueSDK
//
//  Created by huxianchen on 15/3/13.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import "CarInfo.h"
#import "CarInfoModel.h"
@interface CarInfo (Convert)

- (CarInfo *)transferByModel:(CarInfoModel*)model;

@end
