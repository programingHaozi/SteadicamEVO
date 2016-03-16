//
//  LBGeoLocation.m
//  LightBundle
//
//  Created by Hu Dan 胡丹 on 15/11/3.
//  Copyright © 2015年 Ren Wenchao 任文超. All rights reserved.
//

#import "LBGeoLocation.h"
#import "LBLocationManager.h"
#import "LBLoading.h"

@implementation LBGeoLocation

/**
 *  经纬度
 *
 *  @return errorCode 0成功 -1失败
 */
- (void)jsCallFunction
{
    [LBLoading startLoading:self.viewController.view];
    [LBLocationManager startLocationWithUpdateBlock:^(LBLocationModel *location) {
        
        [self callbackJsSdk:location errorCode:LBErrorCodeSuccess msg:kLBMsgGeolocationSuccess];
        [LBLoading stopLoading];
    } failedBlock:^(NSString *errorMessage) {
        [self callbackJsSdk:@"" errorCode:LBErrorCodeFail msg:kLBMsgGeolocationFail];
        [LBLoading stopLoading];
    }];
}

@end
