//
//  LBUrlParam.h
//  LightBundle
//
//  Created by Ren Wenchao 任文超 on 15/10/30.
//  Copyright © 2015年 Ren Wenchao 任文超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBUrlParamModel : NSObject

// 用户id（加密）
@property (strong, nonatomic) NSString *uid;
// 用户id（不加密）
@property (strong, nonatomic) NSString *userId;
// token（不加密）
@property (strong, nonatomic) NSString *userToken;
// 城市名（不加密）
@property (strong, nonatomic) NSString *locCity;
// 经度（不加密）
@property (strong, nonatomic) NSString *locLong;
// 纬度（不加密）
@property (strong, nonatomic) NSString *locLat;

@end
