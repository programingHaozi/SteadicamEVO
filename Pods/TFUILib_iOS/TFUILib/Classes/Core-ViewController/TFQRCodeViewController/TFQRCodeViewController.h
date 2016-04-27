//
//  SubLBXScanViewController.h
//
//  github:https://github.com/MxABC/LBXScan
//  Created by lbxia on 15/10/21.
//  Copyright © 2015年 lbxia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LBXScanView.h"
#import "LBXScanWrapper.h"
#import "TFViewController.h"

/**
 界面预设类型
 */
typedef enum TFQPresetScanType
{
    TFQPresetScanType_QQ=0,//
    TFQPresetScanType_Alipay,//
    TFQPresetScanType_WX,   ///
    TFQPresetScanType_NOBORDER,//
    TFQPresetScanType_COLOR,//
    TFQPresetScanType_SMALL,  //
    TFQPresetScanType_BARCODE,   //
}TFQPresetScanTypeStyle;

/**
 *  继承LBXScanViewController,在界面上绘制想要的按钮，提示语等
 */
@interface TFQRCodeViewController : TFViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, assign) BOOL showButton;
@property (nonatomic, assign) BOOL showTitle;

@property (nonatomic, assign) TFQPresetScanTypeStyle type;

/**
 @brief  扫码功能封装对象
 */
@property (nonatomic,strong) LBXScanWrapper* scanObj;

#pragma mark - 扫码界面效果及提示等
/**
 @brief  扫码区域视图,二维码一般都是框
 */
@property (nonatomic,strong) LBXScanView* qRScanView;

/**
 *  界面效果参数
 */
@property (nonatomic, strong) LBXScanViewStyle *style;


#pragma mark - 扫码界面效果及提示等

/**
 @brief  扫码当前图片
 */
@property(nonatomic,strong)UIImage* scanImage;

/**
 @brief  启动区域识别功能
 */
@property(nonatomic,assign)BOOL isOpenInterestRect;


/**
 @brief  闪关灯开启状态
 */
@property(nonatomic,assign)BOOL isOpenFlash;


//打开相册
- (void)openPhoto;

//开关闪光灯
- (void)openFlash;

- (void)restartDevice;

@end
