//
//  TFBaseUtil+Camera.h
//  TFBaseLib
//
//  Created by xiayiyong on 15/10/16.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFBaseUtil.h"

/**
 *  判断当前系统是否有摄像头
 *
 *  @return YES表示有摄像头，否则表示没有置摄像头
 */
BOOL tf_hasCamera(void);

/*
 * 判断是否有后置摄像头
 * @return YES表示有后置摄像头，否则表示没有有后置摄像头
 */
BOOL tf_isCameraAvailable(void);

/*
 * 判断是否有前置摄像头
 * @return YES表示有前置摄像头，否则表示没有有前置摄像头
 */
BOOL tf_isFrontCameraAvailable(void);

/*
 * 判断是否支持拍照功能
 * @return YES表示支持拍照功能，否则表示不支持拍照功能
 */
BOOL tf_canTakePhoto(void);

/*
 * 判断是否允许使用相册
 * @return YES表示允许使用相册，否则表示不允许使用相册
 */
BOOL tf_isPhotoLibraryAvailable(void);

/*
 * 判断是否允许用户从相册中选择图片
 * @return YES表示允许用户从相册中选择图片，否则表示不允许用户从相册中选择图片
 */
BOOL tf_canPickPhotosFromPhotoLibrary(void);

/*
 * 判断是否允许用户从相册中选择音频/视频
 * @return YES表示允许用户从相册中选择音频/视频，否则表示不允许用户从相册中选择音频/视频
 */
BOOL tf_canPickVideosFromPhotoLibrary(void);

@interface TFBaseUtil (Camera)

/**
*  判断当前系统是否有摄像头
*
*  @return YES表示有摄像头，否则表示没有置摄像头
*/
+ (BOOL)hasCamera;

/*
 * 判断是否有后置摄像头
 * @return YES表示有后置摄像头，否则表示没有有后置摄像头
 */
+ (BOOL)isCameraAvailable;

/*
 * 判断是否有前置摄像头
 * @return YES表示有前置摄像头，否则表示没有有前置摄像头
 */
+ (BOOL)isFrontCameraAvailable;

/*
 * 判断是否支持拍照功能
 * @return YES表示支持拍照功能，否则表示不支持拍照功能
 */
+ (BOOL)canTakePhoto;

/*
 * 判断是否允许使用相册
 * @return YES表示允许使用相册，否则表示不允许使用相册
 */
+ (BOOL)isPhotoLibraryAvailable;

/*
 * 判断是否允许用户从相册中选择图片
 * @return YES表示允许用户从相册中选择图片，否则表示不允许用户从相册中选择图片
 */
+ (BOOL)canPickPhotosFromPhotoLibrary;

/*
 * 判断是否允许用户从相册中选择音频/视频
 * @return YES表示允许用户从相册中选择音频/视频，否则表示不允许用户从相册中选择音频/视频
 */
+ (BOOL)canPickVideosFromPhotoLibrary;

@end
