//
//  TFPermissionManager.m
//  TFBaseLib
//
//  Created by xiayiyong on 16/3/2.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFPermissionManager.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@implementation TFPermissionManager

+ (void)getCameraPermission:(nonnull void(^)(BOOL allowed))completion
{
    
    //ios7之前系统没有设置权限
    if([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
        completion(YES);
        return;
    }
    
    AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    /*
     typedef NS_ENUM(NSInteger, AVAuthorizationStatus) {
     AVAuthorizationStatusNotDetermined = 0,
     AVAuthorizationStatusRestricted,
     AVAuthorizationStatusDenied,
     AVAuthorizationStatusAuthorized
     } NS_AVAILABLE_IOS(7_0) __TVOS_PROHIBITED;
     */
    switch (authorizationStatus)
    {
        case AVAuthorizationStatusAuthorized:
            if (completion)
            {
                completion(YES);
            }
            break;
        case AVAuthorizationStatusRestricted:
        case AVAuthorizationStatusDenied:
            if (completion)
            {
                completion(NO);
            }
            break;
        case AVAuthorizationStatusNotDetermined:
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                     completionHandler:^(BOOL granted) {
                                         if (completion)
                                         {
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 completion(granted);
                                             });
                                         }
                                     }];
        }
            break;
        default:
            if (completion)
            {
                completion(NO);
            }
            break;
    }
}

+ (void)getPhotoPermission:(nonnull void(^)(BOOL allowed))completion
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
    {
        ALAuthorizationStatus authorizationStatus = [ALAssetsLibrary authorizationStatus];
        
        switch (authorizationStatus)
        {
            case ALAuthorizationStatusAuthorized:
                completion(YES);
                break;
            case ALAuthorizationStatusRestricted:
            case ALAuthorizationStatusDenied:
                completion(NO);
                break;
            case ALAuthorizationStatusNotDetermined:
            {
                ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                
                [library enumerateGroupsWithTypes:ALAssetsGroupAll
                                       usingBlock:^(ALAssetsGroup *assetGroup, BOOL *stop) {
                                           if (*stop)
                                           {
                                               completion(YES);
                                           }
                                           else
                                           {
                                               *stop = YES;
                                           }
                                       }
                                     failureBlock:^(NSError *error) {
                                         
                                         completion(NO);
                                     }];
            }
                break;
                
            default:
                break;
        }
        
    }
    else
    {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
            if (status ==  PHAuthorizationStatusAuthorized)
            {
                completion(YES);
            }
            else
            {
                completion(NO);
            }
        }];
    }
}

+ (void)openPermissionSetting
{
    if (UIApplicationOpenSettingsURLString != NULL)
    {
        NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:appSettings];
    }
}

@end
