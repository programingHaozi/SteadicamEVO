//
//  LBXScanWrapper.m
//
//
//  Created by lbxia on 15/3/4.
//  Copyright (c) 2015年 lbxia. All rights reserved.
//

#import "LBXScanWrapper.h"
#import "LBXScanNative.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@interface LBXScanWrapper()

//ios7之后native封装
@property(nonatomic,strong)LBXScanNative* scanNativeObj;

/**
 @brief  扫码类型
 */
@property(nonatomic,strong)NSArray* arrayBarCodeType;

@end


@implementation LBXScanWrapper

+ (BOOL)isSysIos7Later
{
    return [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0;
}

+ (BOOL)isSysIos8Later
{
    return [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0;
}

- (instancetype)initWithPreView:(UIView*)preView objectType:(NSArray*)arrayBarCodeType cropRect:(CGRect)cropRect
              success:(void(^)(NSArray<LBXScanResult*> *array))blockScanResult
{
    if (self = [super init])
    {
        
        self.arrayBarCodeType = arrayBarCodeType;
        
        
        CGRect frame = preView.frame;
        frame.origin = CGPointZero;
       
        _scanNativeObj = [[LBXScanNative alloc]initWithPreView:preView ObjectType:arrayBarCodeType cropRect:cropRect success:^(NSArray<LBXScanResult*> *array) {
            
            if (blockScanResult)
            {
                blockScanResult(array);
            }
        }];
        [_scanNativeObj setNeedCaptureImage:YES];
    }
    
    return self;
}

/*!
 *  开始扫码
 */
- (void)startScan
{
    [_scanNativeObj startScan];
}

/*!
 *  停止扫码
 */
- (void)stopScan
{
    [_scanNativeObj stopScan];
}

- (void)openFlash:(BOOL)bOpen
{
   AVCaptureDevice *device =  [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
     if ([device hasTorch] && [device hasFlash])
     {
         [_scanNativeObj setTorch:bOpen];
     }
}

- (void)openOrCloseFlash
{
    AVCaptureDevice *device =  [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if ([device hasTorch] && [device hasFlash])
    {
        [_scanNativeObj changeTorch];
    }
}

/*!
 *  修改扫码类型
 *
 *  @param objType 扫码类型
 */
- (void)changeScanObjType:(NSArray*)objType
{
    [_scanNativeObj changeScanType:objType];
}

/*
 *  识别各种码图片
 *
 *  @param image 图像
 *  @param block 返回识别结果
 */
+ (void)recognizeImage:(UIImage*)image success:(void(^)(NSArray<LBXScanResult*> *array))block;
{
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    
    //系统自带识别方法
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    for (CIQRCodeFeature *result in features)
    {
        NSString *scanResult = result.messageString;
        NSLog(@"%@",scanResult);
        
        LBXScanResult *xx=[[LBXScanResult alloc]init];
        xx.strScanned=scanResult;
        xx.imgScanned=image;
        [arr addObject:xx];
    }
    
    if (block)
    {
        block(arr);
    }
}

#pragma mark- 震动、声音效果

+ (void)systemVibrate
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

#define SOUNDID  1109  //1012 -iphone   1152 ipad  1109 ipad
+ (void)systemSound
{
    AudioServicesPlaySystemSound(SOUNDID);
}

#pragma mark -相机、相册权限
+ (BOOL)isGetCameraPermission
{
    BOOL isCameraValid = YES;
    //ios7之前系统默认拥有权限
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        if (authStatus == AVAuthorizationStatusDenied)
        {
            isCameraValid = NO;
        }
    }
    return isCameraValid;
}

+ (BOOL)isGetPhotoPermission
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
    {
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        
        if ( author == ALAuthorizationStatusDenied )
        {
            
            return NO;
        }
        return YES;
    }
    
    PHAuthorizationStatus authorStatus = [PHPhotoLibrary authorizationStatus];
    if ( authorStatus == PHAuthorizationStatusDenied )
    {
        
        return NO;
    }
    return YES;
}

#pragma mark -生成二维码

/*
 *  生成二维码
 *
 *  @param str  二维码字符串
 *  @param size 二维码图片大小
 *
 *  @return 返回生成的图像
 */
+ (UIImage*)createQRCodeWithString:(NSString*)str size:(CGSize)size
{
    return [LBXScanWrapper createNonInterpolatedUIImageFormCIImage:[LBXScanWrapper createQRForString:str] withSize:size.width];
}

/*
 *  生成条形码
 *
 *  @param str  条形码字符串
 *  @param size 条形码图片大小
 *
 *  @return 返回生成的图像
 */
+ (UIImage*)createBarCodeWithString:(NSString*)str size:(CGSize)size
{
    CIImage *barcodeImage=[LBXScanWrapper createBarCodeForString:str];
    //消除模糊
    
    CGFloat scaleX = size.width / barcodeImage.extent.size.width;
    
    CGFloat scaleY = size.height / barcodeImage.extent.size.height;
    
    CIImage *transformedImage = [barcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    return [UIImage imageWithCIImage:transformedImage];
    
}


// 参考文档
// https://developer.apple.com/library/mac/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html

- (UIImage *)generateQRCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height
{
    
    // 生成二维码图片
    CIImage *qrcodeImage;
    NSData *data = [code dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:false];
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    qrcodeImage = [filter outputImage];
    
    // 消除模糊
    CGFloat scaleX = width / qrcodeImage.extent.size.width; // extent 返回图片的frame
    CGFloat scaleY = height / qrcodeImage.extent.size.height;
    CIImage *transformedImage = [qrcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    return [UIImage imageWithCIImage:transformedImage];
}

- (UIImage *)generateBarCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height
{
    // 生成二维码图片
    CIImage *barcodeImage;
    NSData *data = [code dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:false];
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    
    [filter setValue:data forKey:@"inputMessage"];
    barcodeImage = [filter outputImage];
    
    // 消除模糊
    CGFloat scaleX = width / barcodeImage.extent.size.width; // extent 返回图片的frame
    CGFloat scaleY = height / barcodeImage.extent.size.height;
    CIImage *transformedImage = [barcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    return [UIImage imageWithCIImage:transformedImage];
}

/**
 @brief  图像中间加logo图片
 @param srcImg    原图像
 @param LogoImage logo图像
 @param logoSize  logo图像尺寸
 @return 加Logo的图像
 */
+ (UIImage*)addImageLogo:(UIImage*)srcImg centerLogoImage:(UIImage*)logoImage logoSize:(CGSize)logoSize
{
    if (!logoImage)
    {
        return srcImg;
    }
    
    UIGraphicsBeginImageContext(srcImg.size);
    [srcImg drawInRect:CGRectMake(0, 0, srcImg.size.width, srcImg.size.height)];
    
    CGRect rect = CGRectMake(srcImg.size.width/2 - logoSize.width/2, srcImg.size.height/2-logoSize.height/2, logoSize.width, logoSize.height);
    [logoImage drawInRect:rect];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

#pragma mark - QRCodeGenerator
+ (CIImage *)createQRForString:(NSString *)qrString
{
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    
    // 1.实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2.恢复滤镜的默认属性 (因为滤镜有可能保存上一次的属性)
    [filter setDefaults];
    
    //3 设置内容和纠错级别
    [filter setValue:stringData forKey:@"inputMessage"];
    [filter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    //4 返回CIImage
    return filter.outputImage;
}

#pragma mark - BarCodeGenerator
+ (CIImage *)createBarCodeForString:(NSString *)qrString
{
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    
    //1 创建filter
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    
    // 2.恢复滤镜的默认属性 (因为滤镜有可能保存上一次的属性)
    [filter setDefaults];
    
    //3 设置内容和纠错级别
    [filter setValue:stringData forKey:@"inputMessage"];
    
    //4 返回CIImage
    return filter.outputImage;
}

#pragma mark - imageToTransparent

+ (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue
{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++)
    {
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900)    // 将白色变成透明
        {
            // 改成下面的代码，会将图片转成想要的颜色
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }
        else
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    
    // 输出图片
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, providerReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    
    // 清理空间
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}

#pragma mark - 生成二维码

+ (UIImage*)createQRCodeWithString:(NSString*)text size:(CGSize)size qrColor:(UIColor*)qrColor bgColor:(UIColor*)bgColor
{
    
    NSData *stringData = [text dataUsingEncoding: NSUTF8StringEncoding];
    
    //1生成
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2.恢复滤镜的默认属性 (因为滤镜有可能保存上一次的属性)
    [filter setDefaults];
    
    [filter setValue:stringData forKey:@"inputMessage"];
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    //上色
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                       keysAndValues:
                             @"inputImage",filter.outputImage,
                             @"inputColor0",[CIColor colorWithCGColor:qrColor.CGColor],
                             @"inputColor1",[CIColor colorWithCGColor:bgColor.CGColor],
                             nil];
    
    CIImage *qrImage = colorFilter.outputImage;
    
    //绘制
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgImage);
    
    return codeImage;
}

#pragma mark - CIImage转UIImage

+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

void providerReleaseData (void *info, const void *data, size_t size)
{
    free((void*)data);
}

#pragma mark - 格式化code
// 每隔4个字符空两格
- (NSString *)formatCode:(NSString *)code
{
    NSMutableArray *chars = [[NSMutableArray alloc] init];
    
    for (int i = 0, j = 0 ; i < [code length]; i++, j++)
    {
        [chars addObject:[NSNumber numberWithChar:[code characterAtIndex:i]]];
        if (j == 3)
        {
            j = -1;
            [chars addObject:[NSNumber numberWithChar:' ']];
            [chars addObject:[NSNumber numberWithChar:' ']];
        }
    }
    
    int length = (int)[chars count];
    char str[length];
    for (int i = 0; i < length; i++)
    {
        str[i] = [chars[i] charValue];
    }
    
    NSString *temp = [NSString stringWithUTF8String:str];
    return temp;
}

@end
