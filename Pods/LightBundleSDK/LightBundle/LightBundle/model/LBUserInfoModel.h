//
//  userInfoModel.h
//  LightBundle
//
//  Created by Ren Wenchao 任文超 on 15/10/29.
//  Copyright © 2015年 Ren Wenchao 任文超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBUserInfoModel : NSObject

// 用户UID
@property (strong, nonatomic) NSString *UID;
// 用户名
@property (strong, nonatomic) NSString *username;
// 电话
@property (strong, nonatomic) NSString *tel;
// 是否认证会员
@property (strong, nonatomic) NSString *isAuth;
// 用户token
@property (strong, nonatomic) NSString *token;
// 用户车辆信息
@property (strong, nonatomic) NSString *carMdmId;
@property (strong, nonatomic) NSString *assetId;
@property (strong, nonatomic) NSString *carYear;

@end
