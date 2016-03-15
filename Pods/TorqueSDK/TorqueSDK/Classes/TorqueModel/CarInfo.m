//
//  CarInfo.m
//  OBD-DEMO
//
//  Created by zhangjipeng on 1/23/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import "CarInfo.h"

@implementation EditCarModel : NSObject

//xyy
- (id)copy {
    EditCarModel *carInfo = [EditCarModel new];
    carInfo.car_id = self.car_id;
    carInfo.model_id = self.model_id;
    carInfo.user_id = self.user_id;
    carInfo.device_id = self.device_id;
    
    return carInfo;
}
@end

@implementation CarInfo

- (id)copy {
    CarInfo *carInfo = [CarInfo new];
    carInfo.userId = self.userId;
    carInfo.vinCode = self.vinCode;
    carInfo.sn = self.sn;
    carInfo.brand = self.brand;
    carInfo.brandName = self.brandName;
    carInfo.brandCoverImgUrl = self.brandCoverImgUrl;
    carInfo.manufacturer = self.manufacturer;
    carInfo.series = self.series;
    carInfo.seriesName = self.seriesName;
    carInfo.modelId = self.modelId;
    carInfo.modelName = self.modelName;
    carInfo.modelCoverImgUrl = self.modelCoverImgUrl;
    carInfo.type = self.type;
    carInfo.plateNumber = self.plateNumber;
    carInfo.year = self.year;
    carInfo.oem =self.oem;
    carInfo.fueTankCapacity = self.fueTankCapacity;
    carInfo.mileage = self.mileage;
    carInfo.buyDate = self.buyDate;
    carInfo.licensePlate = self.licensePlate;
    carInfo.fuelType = self.fuelType;
    carInfo.mileage = self.mileage;
    carInfo.vinSource = self.vinSource;
    
    return carInfo;
}

@end


@implementation CarUserQueryModel

@end