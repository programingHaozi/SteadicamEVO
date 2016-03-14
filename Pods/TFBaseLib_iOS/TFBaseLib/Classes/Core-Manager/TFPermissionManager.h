//
//  TFPermissionManager.h
//  TFBaseLib
//
//  Created by xiayiyong on 16/3/2.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

/**
 @brief 获取各种设备、资源权限
 注：app运行期间设置里面更改相关权限，会导致app崩溃是系统造成的，待测试捕获异常看是否会仍然会导致app崩溃。
 
 ref:https://github.com/jlaws/JLPermissions
 */
#import <Foundation/Foundation.h>

@interface TFPermissionManager : NSObject

/**
 @brief 前往本app权限系统设置界面，需要ios8之后
 */
+ (void)openPermissionSetting;

/**
 @brief 获取相机权限
 @param completion 返回block，allowed:YES表示有权限，NO表示无权限
 */
+ (void)getCameraPermission:(nonnull void(^)(BOOL allowed))completion;

/**
 @brief 获取相册权限
 @param completion 返回block，allowed:YES表示有权限，NO表示无权限
 */
+ (void)getPhotoPermission:(nonnull void(^)(BOOL allowed))completion;


//麦克风权限

//推送权限

//通讯录权限

//日历权限

//健康权限

//HomeKit权限

//蓝牙权限

//GPS权限

@end
