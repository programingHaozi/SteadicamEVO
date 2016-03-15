//
//  IAPInfo.h
//  TorqueSDK
//
//  Created by sunxiaofei on 15/8/19.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  IPA版本信息
 */
@interface IAPInfo : NSObject

/**
*  IAP版本描述
*/
@property (nonatomic, strong) NSString *descriptionContent;
/**
 *  IAP名称
 */
@property (nonatomic, strong) NSString *name;
/**
 *  是否有更新标志，YES：有更新，NO：没更新
 */
@property (nonatomic, assign) BOOL needUpdate;
/**
 *  IAP创建时间
 */
@property (nonatomic, strong) NSDate *createTime;
/**
 *  IAP版本号
 */
@property (nonatomic, strong) NSString *version;
/**
 *  IAP所属的硬件版本
 */
@property (nonatomic, strong) NSString *hardWareVersion;
@end
