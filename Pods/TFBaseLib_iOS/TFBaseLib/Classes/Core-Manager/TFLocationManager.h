//
//  LocationManager.h
//  Treasure
//
//  Created by Hu Dan 胡丹 on 15/8/27.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface LocationModel : NSObject

/**
 *  经度
 */
@property (nonatomic, strong) NSString *longitude;

/**
 *  纬度
 */
@property (nonatomic, strong) NSString *latitude;

/**
 *  当前省份
 */
@property (nonatomic, strong) NSString *province;

/**
 *  当前城市
 */
@property (nonatomic, strong) NSString *city;

@end

#define kTFLocationManager ([TFLocationManager sharedManager])

@interface TFLocationManager : NSObject

@property (nonatomic, assign) BOOL servicesEnabled;
@property (nonatomic, assign) BOOL authorizeEnabled;

/**
 *  经度
 */
@property (nonatomic, strong) NSString *longitude;

/**
 *  纬度
 */
@property (nonatomic, strong) NSString *latitude;

/**
 *  当前省份
 */
@property (nonatomic, strong) NSString *province;

/**
 *  当前城市
 */
@property (nonatomic, strong) NSString *city;

+ (instancetype)sharedManager;

/**
 *  获取定位信息
 *
 *  @param successBlock successBlock
 *  @param failedBlock  failedBlock
 */
+ (void)startLocation:(void (^)(LocationModel* location))successBlock
               failed:(void (^)(NSString *errorMessage))failedBlock;

@end
