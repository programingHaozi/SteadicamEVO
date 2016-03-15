//
//  TorqueUtility.h
//  TorqueSDK
//
//  Created by sunxiaofei on 15/3/19.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TorqueReachability.h"
#import "CrpytHeader.h"

/**
 *  SDK工具类
 */
@interface TorqueUtility : NSObject

+ (instancetype)sharedInstance;

/**
 *  从Bundle中读取指定文件内容
 *
 *  @param resourceName bundle名称
 *  @param fileName     要读取的文件名称
 *  @param fileType     要读取的文件扩展名类型
 *
 *  @return 返回文件内容
 */
+ (NSData *)readFileFromBundle:(NSString *)resourceName fileName:(NSString *)fileName fileType:(NSString *)fileType;

/**
 *  检测网络连接状态，【不能使用sharedInstance初始化的对象来调用，必须使用init方法初始化的对象来调用】
 *
 *  @param reachableBlock   有网络时回调
 *  @param unreachableBlock 无网络时回调
 */
- (void)motionNetwork:(void(^)(TorqueReachability *reach))reachableBlock unreachableBlock:(void(^)())unreachableBlock;
/**
 *  停止监听网络连接状态，【不能使用sharedInstance初始化的对象来调用，必须使用init方法初始化的对象来调用】
 */
- (void)stopMotionNetwork;
@end
