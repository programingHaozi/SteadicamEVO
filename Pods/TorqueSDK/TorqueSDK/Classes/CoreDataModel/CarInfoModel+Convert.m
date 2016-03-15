//
//  CarInfoModel+Convert.m
//  TorqueSDK
//
//  Created by huxianchen on 15/3/10.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import "CarInfoModel+Convert.h"

@implementation CarInfoModel (Convert)

- (CarInfoModel *)transferByObject:(CarInfo *)info
{
 
    [self setBrand:@(info.brand)];
    [self setManufacturer:@(info.manufacturer)];
    [self setPlateNumber:@([info.plateNumber intValue])];
    [self setSeries:@(info.series)];
    [self setType:@(info.type)];
    [self setVinCode:info.vinCode];
    [self setYear:info.year];
    
    return self;
}

@end
