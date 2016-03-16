//
//  TFUserDefaults+SCE.h
//  SteadicamEVO
//
//  Created by Chen Hao 陈浩 on 16/3/16.
//  Copyright © 2016年 haozi. All rights reserved.
//

@interface TFUserDefaults (SCE)

#define kSCEUserDefaults  ([TFUserDefaults standardUserDefaults])

/**
 *  上个app版本号
 */
@property (nonatomic, strong) NSString *lastAPPVersion;

/**
 *  账号
 */
@property (nonatomic, strong) NSString *account;

/**
 *  密码
 */
@property (nonatomic, strong) NSString *password;

@end
