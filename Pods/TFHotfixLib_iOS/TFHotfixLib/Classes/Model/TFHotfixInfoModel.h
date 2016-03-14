//
//  TFHotfixInfoModel.h
//  TFHotfixLib
//
//  Created by Chen Hao 陈浩 on 15/10/22.
//  Copyright © 2015年 Chen Hao 陈浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFHotfixInfoModel : NSObject<NSCoding>

/**
 *  请求的appId
 */
@property (nonatomic, strong) NSString  *app_id;

/**
 *  请求的app
 */
@property (nonatomic, strong) NSString  *app_version;

/**
 *  最新的hotfix脚本版本，需要手动维护，且新版本号不能小于旧版本号
 */
@property (nonatomic, strong) NSString  *shot_version;

/**
 *  热更新文件名
 */
@property (nonatomic, strong) NSString  *shot_name;

/**
 *  平台类型，（ios/android）
 */
@property (nonatomic, strong) NSString  *type;

/**
 *  hotfix脚本地址
 */
@property (nonatomic, strong) NSString  *file_url;

/**
 *  fix说明
 */
@property (nonatomic, strong) NSString  *remark;


/**
 *  存储HotFixInfoModel
 *
 *  @param hotFixInfoModel 需要存储的HotFixInfoModel
 */
+ (void)saveHotfixInfoModel:(TFHotfixInfoModel *)hotFixInfoModel;

/**
 *  返回存储的HotFixInfoModel
 *
 *  @return 存储的HotFixInfoModel
 */
+ (TFHotfixInfoModel *)getHotfixInfoModel;

@end
