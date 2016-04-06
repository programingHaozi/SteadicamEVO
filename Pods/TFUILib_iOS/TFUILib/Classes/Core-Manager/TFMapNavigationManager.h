//
//  TFMapNavigationManager.h
//  LocationBlock
//
//  Created by xiayiyong on 16/1/11.
//  Copyright © 2016年 xiayiyong. All rights reserved.
//  提供一个调用外部地图APP的例子

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface TFMapNavigationManager : NSObject<UIActionSheetDelegate,CLLocationManagerDelegate>

+ (instancetype) sharedManager;

/**
 *  从指定地导航到指定地
 *
 *  @param locaiontBlock locaiontBlock description
 */
+ (void)navigationFromLatitude:(double)fromLatitude fromLongitute:(double)fromLongitute toLatitude:(double)toLatitude toLongitute:(double)toLongitute toName:(NSString *)name;

/**
 *  从目前位置导航到指定地
 *
 *  @param locaiontBlock locaiontBlock description
 */
+ (void)navigationtoLatitude:(double)toLatitude toLongitute:(double)toLongitute toName:(NSString *)name;


@end
