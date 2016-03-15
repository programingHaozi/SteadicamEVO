//
//  CarInfo.h
//  OBD-DEMO
//
//  Created by zhangjipeng on 1/23/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseQueryModel.h"

//xyy
@interface EditCarModel : NSObject
@property (nonatomic, strong) NSString  *car_id;
@property (nonatomic, strong) NSNumber  *model_id;
@property (nonatomic, strong) NSNumber  *user_id;
@property (nonatomic, strong) NSString  *device_id;
@end

@interface CarInfo : NSObject

@property (nonatomic, strong) NSString  *userId;
@property (nonatomic, strong) NSString  *vinCode;
@property (nonatomic, strong) NSString  *sn;
@property (nonatomic, strong) NSString  *carId;
/**
 *  品牌ID
 */
@property (nonatomic        ) NSInteger brand;
/**
 *  品牌名称
 */
@property (nonatomic, strong) NSString  *brandName;
/**
 *  品牌图片
 */
@property (nonatomic, strong) NSURL  *brandCoverImgUrl;
/**
 *  制造商
 */
@property (nonatomic        ) NSInteger manufacturer;
/**
 *  车系ID
 */
@property (nonatomic        ) NSInteger series;
/**
 *  车系名称
 */
@property (nonatomic, strong) NSString  *seriesName;
/**
 *  车型ID
 */
@property (nonatomic        ) NSInteger modelId;
/**
 *  车型名称
 */
@property (nonatomic, strong) NSString  *modelName;
/**
 *  车型图片
 */
@property (nonatomic, strong) NSURL  *modelCoverImgUrl;
/**
 *  车款
 */
@property (nonatomic        ) NSInteger type;
/**
 *  车牌
 */
@property (nonatomic, strong) NSString  *plateNumber;
/**
 *  年款
 */
@property (nonatomic, strong) NSString  *year;
@property (nonatomic, strong) NSString  *oem;
/**
 *  油箱容积
 */
@property (nonatomic) NSInteger fueTankCapacity;
/**
 *  当前里程数
 */
@property (nonatomic) NSInteger mileage;
/**
 *  购车日期(yyyy-MM-dd)
 */
@property (nonatomic, strong) NSString *buyDate;
/**
 *  车牌号
 */
@property (nonatomic, copy) NSString *licensePlate;
/**
 *  油号
 */
@property (nonatomic, copy) NSString *fuelType;
/**
 *  vin码来源
 */
@property (nonatomic, copy) NSString *vinSource;

@end

/**
 *  车/用户查询对象
 */
@interface CarUserQueryModel : BaseQueryModel

/**
 *  用户ID列表，用’,‘分隔多个用户ID
 */
@property (nonatomic, strong) NSString *userIds;

@end