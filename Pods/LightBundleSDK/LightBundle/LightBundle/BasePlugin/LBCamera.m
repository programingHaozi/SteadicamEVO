//
//  LBCamera.m
//  LightBundle
//
//  Created by Hu Dan 胡丹 on 15/11/3.
//  Copyright © 2015年 Ren Wenchao 任文超. All rights reserved.
//

#import "LBCamera.h"
#import "LBAESCrypt.h"
#import "LBNSData+Base64.h"

@interface LBCamera()< UIActionSheetDelegate,
                       UINavigationControllerDelegate,
                       UIImagePickerControllerDelegate>

// 相册选择vc
@property (nonatomic, strong) UIImagePickerController *imagePickerController;

@end

@implementation LBCamera

/**
 *  相机相册
 */
- (void)jsCallFunction
{
    UIActionSheet *actionSheet;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    }
    else if (LB_SIMULATOR)
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:@"从模拟器相册选择", nil];
    }
    else
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:@"从相册选择", nil];
    }
    
    [actionSheet showInView:self.viewController.view];
}

/**
 *  完成选择图片
 *
 *  @param picker
 *  @param info
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.image"])
    {
        UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        // 图片压缩1：若图片宽度超过640的 以640为宽等比压缩
        if (originalImage.size.width > 640)
        {
            originalImage = [self imageWithImage:originalImage scaledToSize:CGSizeMake(640, 640*originalImage.size.height/originalImage.size.width)];
        }
        
        // 保存照片到本地 (测试状态生效)
        if (LB_DEBUG_APP)
        {
            NSData *data = UIImageJPEGRepresentation(originalImage, 0.7);
            NSString*path = [NSString stringWithFormat:@"%@/tmp/avatar.jpg", NSHomeDirectory()];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager createFileAtPath:path contents:data attributes:nil];
        }
        
        // 图片压缩2：质量70% 格式jpg
        NSString *base64 = [UIImageJPEGRepresentation(originalImage, 0.7) base64EncodedString];
        [self callbackJsSdk:base64 errorCode:LBErrorCodeSuccess msg:kLBMsgCameraSuccess];
    }
    
    [[UINavigationBar appearance] setBarTintColor:self.navBgColor];
    [picker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:self.statusBarStyle];
    }];
}

/**
 *  取消选择图片
 *
 *  @param picker
 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[UINavigationBar appearance] setBarTintColor:self.navBgColor];
    [self callbackJsSdk:@"" errorCode:LBErrorCodeCancel msg:kLBMsgCameraCancel];
    [picker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:self.statusBarStyle];
    }];
}

/**
 *  actionSheet delegate
 *
 *  @param actionSheet
 *  @param buttonIndex index
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    // 判断是否支持相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        switch (buttonIndex)
        {
            case 0:
            {
                // 选择相机
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            }
            case 1:
            {
                // 选择相册
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            }
            case 2:
            {
                // 取消
                [self callbackJsSdk:@"" errorCode:LBErrorCodeCancel msg:kLBMsgCameraCancel];
                return;
                break;
            }
            default:
            {
                break;
            }
        }
    }
    else {
        switch (buttonIndex)
        {
            case 0:
            {
                // 选择相册
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            }
            case 1:
            {
                // 取消
                [self callbackJsSdk:@"" errorCode:LBErrorCodeCancel msg:kLBMsgCameraCancel];
                return;
                break;
            }
            default:
            {
                break;
            }
        }
    }
    // 跳转到相机或相册页面
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.delegate = self;
    self.imagePickerController.allowsEditing = NO;
    self.imagePickerController.sourceType = sourceType;
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], UITextAttributeTextColor, [UIFont systemFontOfSize:18], UITextAttributeFont, nil];
    [self.imagePickerController.navigationBar setTitleTextAttributes:attributes];
    [self.imagePickerController.navigationBar setTintColor:COLOR_SYSTEM_DEFAULT];
    if (self.navigationBarBgImage)
    {
        [self.imagePickerController.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    }
    if (self.navigationBarShadowImage)
    {
        [self.imagePickerController.navigationBar setShadowImage:nil];
    }
    
    if (self.viewController)
    {
        [self.viewController presentViewController:self.imagePickerController animated:YES completion:nil];
    }
    else
    {
        [self callbackJsSdk:@"" errorCode:LBErrorCodeFail msg:kLBMsgCameraFail];
        [self alertNoVc];
    }
}

/**
 *  navigationController delegate
 *  将要显示
 *
 *  @param navigationController
 *  @param viewController
 *  @param animated
 */
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}

/**
 *  navigationController delegate
 *  已经显示
 *
 *  @param navigationController
 *  @param viewController
 *  @param animated
 */
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}

/**
 *  设置UIImage尺寸
 *
 *  @param image
 *  @param newSize 新的尺寸
 *
 *  @return
 */
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
