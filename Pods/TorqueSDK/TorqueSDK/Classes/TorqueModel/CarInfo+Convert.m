//
//  CarInfo+Convert.m
//  TorqueSDK
//
//  Created by huxianchen on 15/3/13.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import "CarInfo+Convert.h"

@implementation CarInfo (Convert)

- (CarInfo *)transferByModel:(CarInfoModel*)model
{
    self.vinCode = model.vinCode;
    self.brand = model.brand.intValue;
    self.manufacturer = model.manufacturer.intValue;
    self.plateNumber = [model.plateNumber stringValue];
    self.series = model.series.intValue;
    self.type = model.type.intValue;
    self.year = model.year;
    
    return self;
}

@end
