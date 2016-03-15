//
//  ReleaseNote.h
//  TorqueSDK
//
//  Created by sunxiaofei on 15/3/18.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  SDK版本对象
 */
@interface ReleaseNote : NSObject
/**
 *  版本号
 */
@property (nonatomic, strong) NSString *version;
/**
 *  是否为紧急版本，需要立即更新
 */
@property (nonatomic, assign) BOOL mandatory;
/**
 *  发布时间
 */
@property (nonatomic, strong) NSDate *publishDate;
/**
 *  更新细节
 */
@property (nonatomic, strong) NSString *logDescription;

@end
