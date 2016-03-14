//
//  TFBaseUtil+Camera.m
//  TFBaseLib
//
//  Created by xiayiyong on 15/10/16.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "TFBaseUtil+Camera.h"

BOOL tf_hasCamera(void)
{
    return [TFBaseUtil hasCamera];
}

BOOL tf_isCameraAvailable(void)
{
    return [TFBaseUtil isCameraAvailable];
}

BOOL tf_isFrontCameraAvailable(void)
{
    return [TFBaseUtil isFrontCameraAvailable];
}

BOOL tf_canTakePhoto(void)
{
    return [TFBaseUtil canTakePhoto];
}

BOOL tf_isPhotoLibraryAvailable(void)
{
    return [TFBaseUtil isPhotoLibraryAvailable];
}

BOOL tf_canPickPhotosFromPhotoLibrary(void)
{
    return [TFBaseUtil canPickPhotosFromPhotoLibrary];
}

BOOL tf_canPickVideosFromPhotoLibrary(void)
{
    return [TFBaseUtil canPickVideosFromPhotoLibrary];
}

@implementation TFBaseUtil (Camera)

+ (BOOL)hasCamera
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

/*!
 * @brief 判断是否有后置摄像头
 * @return YES表示有后置摄像头，否则表示没有有后置摄像头
 */
+ (BOOL)isCameraAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

/*!
 * @brief 判断是否有前置摄像头
 * @return YES表示有前置摄像头，否则表示没有有前置摄像头
 */
+ (BOOL)isFrontCameraAvailable
{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

/*!
 * @brief 判断是否支持拍照功能
 * @return YES表示支持拍照功能，否则表示不支持拍照功能
 */
+ (BOOL)canTakePhoto
{
    return [self isCameraSupportMedia:(__bridge NSString *)kUTTypeImage
                           sourceType:UIImagePickerControllerSourceTypeCamera];
}

/*!
 * @brief 判断是否允许使用相册
 * @return YES表示允许使用相册，否则表示不允许使用相册
 */
+ (BOOL)isPhotoLibraryAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}

/*!
 * @brief 判断是否允许用户从相册中选择图片
 * @return YES表示允许用户从相册中选择图片，否则表示不允许用户从相册中选择图片
 */
+ (BOOL)canPickPhotosFromPhotoLibrary
{
    return [self isCameraSupportMedia:(__bridge NSString *)kUTTypeImage
                           sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

/*!
 * @brief 判断是否允许用户从相册中选择音频/视频
 * @return YES表示允许用户从相册中选择音频/视频，否则表示不允许用户从相册中选择音频/视频
 */
+ (BOOL)canPickVideosFromPhotoLibrary
{
    return [self isCameraSupportMedia:(__bridge NSString *)kUTTypeMovie
                           sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma mark - Private Methods
+ (BOOL)isCameraSupportMedia:(NSString *)mediaType sourceType:(UIImagePickerControllerSourceType)sourceType {
    __block BOOL result = NO;
    if ([mediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:mediaType]){
            result = YES;
            *stop = YES;
        }
    }];
    return result;
}

@end
