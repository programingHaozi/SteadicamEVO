//
//  LBQrCodeImage.m
//  LightBundle
//
//  Created by Hu Dan 胡丹 on 15/11/3.
//  Copyright © 2015年 Ren Wenchao 任文超. All rights reserved.
//

#import "LBQrCodeImage.h"
#import "LBZXingObjC.h"

@interface LBQrCodeImage()< UIActionSheetDelegate,
                            UINavigationControllerDelegate,
                            UIImagePickerControllerDelegate>

@end

@implementation LBQrCodeImage

- (void)jsCallFunction
{
    NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    // 跳转到相机或相册页面
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];

    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = NO;
    imagePickerController.sourceType = sourceType;

    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], UITextAttributeTextColor, [UIFont systemFontOfSize:18], UITextAttributeFont, nil];
    [imagePickerController.navigationBar setTitleTextAttributes:attributes];
    [imagePickerController.navigationBar setTintColor:COLOR_SYSTEM_DEFAULT];
    if (self.navigationBarBgImage)
    {
        [imagePickerController.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    }
    if (self.navigationBarShadowImage)
    {
        [imagePickerController.navigationBar setShadowImage:nil];
    }

    if (self.viewController)
    {
        [self.viewController presentViewController:imagePickerController animated:YES completion:nil];
    }
    else
    {
        [self callbackJsSdk:@"" errorCode:LBErrorCodeFail msg:kLBMsgQrcodeImageFail];
        [self alertNoVc];
    }
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
        NSString *ret = [self getStringWithImage:originalImage];
        if (ret)
        {
            [self callbackJsSdk:ret errorCode:LBErrorCodeSuccess msg:kLBMsgQrcodeImageSuccess];
        }
        else
        {
            [self callbackJsSdk:@"" errorCode:LBErrorCodeFail msg:kLBMsgQrcodeImageFail];
        }
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
    [self callbackJsSdk:@"" errorCode:LBErrorCodeCancel msg:kLBMsgQrcodeImageCancel];
    [picker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:self.statusBarStyle];
    }];
}

/**
 *  识别二维码图片
 *
 *  @param img 图片
 *
 *  @return 识别出的字符串
 */
- (NSString*)getStringWithImage:(UIImage *)img
{
    
    UIImage *loadImage= img;
    CGImageRef imageToDecode = loadImage.CGImage;
    
    LBZXLuminanceSource *source = [[LBZXCGImageLuminanceSource alloc] initWithCGImage:imageToDecode];
    LBZXBinaryBitmap *bitmap = [LBZXBinaryBitmap binaryBitmapWithBinarizer:[LBZXHybridBinarizer binarizerWithSource:source]];
    
    NSError *error = nil;
    
    LBZXDecodeHints *hints = [LBZXDecodeHints hints];
    
    LBZXMultiFormatReader *reader = [LBZXMultiFormatReader reader];
    LBZXResult *result = [reader decode:bitmap
                                hints:hints
                                error:&error];
    if (result)
    {
        return result.text;
    }
    return nil;
}

@end
