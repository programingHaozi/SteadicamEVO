//
//
//
//
//  Created by lbxia on 15/10/21.
//  Copyright © 2015年 lbxia. All rights reserved.
//

#import "TFQRCodeViewController.h"
#import "LBXScanResult.h"
#import "LBXScanWrapper.h"

@interface TFQRCodeViewController ()

/**
 *  扫码区域上方提示文字
 */
@property (nonatomic, strong) UILabel *topTitle;

//底部显示的功能项
@property (nonatomic, strong) UIView *bottomButtonView;

#pragma mark - 底部几个功能：开启闪光灯、相册、我的二维码

/**
 *  相册按钮
 */
@property (nonatomic, strong) UIButton *photoButton;

/**
 *  闪光灯按钮
 */
@property (nonatomic, strong) UIButton *flashButton;

/**
 *  我的二维码按钮
 */
@property (nonatomic, strong) UIButton *myQRButton;

@end

@implementation TFQRCodeViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.view.backgroundColor = [UIColor blackColor];
    
    switch (self.type)
    {
        case TFQPresetScanType_QQ:
        {
            [self qqStyle];
        }
            break;
        case TFQPresetScanType_Alipay:
        {
            [self alipayStyle];
        }
            break;
        case TFQPresetScanType_WX:
        {
            [self wxStyle];
        }
            break;
            
        case TFQPresetScanType_SMALL:
        {
            [self smallStyle];
        }
            break;
        case TFQPresetScanType_COLOR:
        {
            [self colorStyle];
        }
            break;
        case TFQPresetScanType_NOBORDER:
        {
            [self noborderStyle];
        }
            break;
        case TFQPresetScanType_BARCODE:
        {
            [self barcodeStyle];
        }
            break;
            
        default:
            break;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self drawScanView];
    
    [self performSelector:@selector(startScan) withObject:nil afterDelay:0.2];
    
    if (self.showTitle)
    {
        [self initTitle];
    }
    
    if (self.showButton)
    {
        [self initBottomButtons];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [_scanObj stopScan];
    [_qRScanView stopScanAnimation];
}

#pragma mark- init autolayout bind

- (void)initViews
{
    
}

- (void)autolayoutViews
{
    
}

- (void)bindData
{
    
}

//绘制扫描区域
- (void)initTitle
{
    if (!_topTitle)
    {
        self.topTitle = [[UILabel alloc]init];
        _topTitle.bounds = CGRectMake(0, 0, 145, 60);
        _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, 50);
        
        //3.5inch iphone
        if ([UIScreen mainScreen].bounds.size.height <= 568 )
        {
            _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, 38);
            _topTitle.font = [UIFont systemFontOfSize:14];
        }
        
        _topTitle.textAlignment = NSTextAlignmentCenter;
        _topTitle.numberOfLines = 0;
        _topTitle.text = @"将取景框对准二维码即可自动扫描";
        _topTitle.textColor = [UIColor whiteColor];
        [self.view addSubview:_topTitle];
    }
}

- (void)initBottomButtons
{
    if (_bottomButtonView)
    {
        return;
    }
    
    self.bottomButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame)-164,
                                                                      CGRectGetWidth(self.view.frame), 100)];
    
    _bottomButtonView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    [self.view addSubview:_bottomButtonView];
    
    CGSize size = CGSizeMake(65, 87);
    self.flashButton = [[UIButton alloc]init];
    _flashButton.bounds = CGRectMake(0, 0, size.width, size.height);
    _flashButton.center = CGPointMake(CGRectGetWidth(_bottomButtonView.frame)/2, CGRectGetHeight(_bottomButtonView.frame)/2);
     [_flashButton setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
    [_flashButton addTarget:self action:@selector(openFlash) forControlEvents:UIControlEventTouchUpInside];
    
    self.photoButton = [[UIButton alloc]init];
    _photoButton.bounds = _flashButton.bounds;
    _photoButton.center = CGPointMake(CGRectGetWidth(_bottomButtonView.frame)/4, CGRectGetHeight(_bottomButtonView.frame)/2);
    [_photoButton setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_photo_nor"] forState:UIControlStateNormal];
    [_photoButton setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_photo_down"] forState:UIControlStateHighlighted];
    [_photoButton addTarget:self action:@selector(openPhoto) forControlEvents:UIControlEventTouchUpInside];
    
    self.myQRButton = [[UIButton alloc]init];
    _myQRButton.bounds = _flashButton.bounds;
    _myQRButton.center = CGPointMake(CGRectGetWidth(_bottomButtonView.frame) * 3/4, CGRectGetHeight(_bottomButtonView.frame)/2);
    [_myQRButton setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_myqrcode_nor"] forState:UIControlStateNormal];
    [_myQRButton setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_myqrcode_down"] forState:UIControlStateHighlighted];
    [_myQRButton addTarget:self action:@selector(openCreateQRCode) forControlEvents:UIControlEventTouchUpInside];
    
    [_bottomButtonView addSubview:_flashButton];
    [_bottomButtonView addSubview:_photoButton];
    [_bottomButtonView addSubview:_myQRButton];   
}

//绘制扫描区域
- (void)drawScanView
{
    if (!_qRScanView)
    {
        CGRect rect = self.view.frame;
        rect.origin = CGPointMake(0, 0);
        
        self.qRScanView = [[LBXScanView alloc]initWithFrame:rect style:_style];
        [self.view addSubview:_qRScanView];
        
    }
    
    [_qRScanView startDeviceReadyingWithText:@"相机启动中"];
}

- (void)restartDevice
{
    [_scanObj startScan];
}

//启动设备
- (void)startScan
{
    if ( ![LBXScanWrapper isGetCameraPermission] )
    {
        [_qRScanView stopDeviceReadying];
        
        [self showError:@"   请到设置隐私中开启本程序相机权限   "];
        return;
    }
    
    if (!_scanObj )
    {
        __weak __typeof(self) weakSelf = self;
        // AVMetadataObjectTypeQRCode   AVMetadataObjectTypeEAN13Code
        
        CGRect cropRect = CGRectZero;
        
        if (_isOpenInterestRect)
        {
            
            cropRect = [LBXScanView getScanRectWithPreView:self.view style:_style];
        }
        
        self.scanObj = [[LBXScanWrapper alloc]initWithPreView:self.view
                                                   objectType:nil
                                                     cropRect:cropRect
                                                      success:^(NSArray<LBXScanResult *> *array){
                                                          [weakSelf scanResultWithArray:array];
                                                      }];
        
    }
    
    [_scanObj startScan];
    
    [_qRScanView stopDeviceReadying];
    
    [_qRScanView startScanAnimation];
    
    self.view.backgroundColor = [UIColor clearColor];
}

#pragma mark- 相册 开关闪光灯  打开本地照片
- (void)openPhoto
{
    if ([LBXScanWrapper isGetPhotoPermission])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        picker.allowsEditing = YES;
        
        [self presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        [self showError:@"      请到设置->隐私中开启本程序相册权限     "];
    }
}

- (void)openFlash
{
    [_scanObj openOrCloseFlash];
    
    self.isOpenFlash =!self.isOpenFlash;
    
    if (self.isOpenFlash)
    {
        [_flashButton setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_down"] forState:UIControlStateNormal];
    }
    else
    {
        [_flashButton setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
    }
}

- (void)openCreateQRCode
{
    
}

/**
 *  当选择一张图片后进入这里
 */
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    __block UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (!image)
    {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    __weak __typeof(self) weakSelf = self;
    [LBXScanWrapper recognizeImage:image
                           success:^(NSArray<LBXScanResult *> *array) {
                               [weakSelf scanResultWithArray:array];
                           }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"cancel");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -实现类继承该方法，作出对应处理

- (void)showError:(NSString*)str
{
    
}

- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    if (array.count < 1)
    {
        return;
    }
    
    //经测试，可以同时识别2个二维码，不能同时识别二维码和条形码
    for (LBXScanResult *result in array)
    {
        NSLog(@"scanResult:%@",result.strScanned);
    }
    
    LBXScanResult *scanResult = array[0];
    
    NSString*strResult = scanResult.strScanned;
    
    self.scanImage = scanResult.imgScanned;
    
    if (!strResult)
    {
        return;
    }
    
    //震动提醒
    [LBXScanWrapper systemVibrate];
    
    //声音提醒
    [LBXScanWrapper systemSound];
    
    [self popViewController];
    
    if (self.resultBlock)
    {
        self.resultBlock(scanResult);
    }
   
}

#pragma mark -预设界面

//模仿qq界面
- (void)qqStyle
{
    //设置扫码区域参数设置
    
    //创建参数对象
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    
    //矩形区域中心上移，默认中心点为屏幕中心点
    style.centerUpOffset = 44;
    
    //扫码框周围4个角的类型,设置为外挂式
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Outer;
    
    //扫码框周围4个角绘制的线条宽度
    style.photoframeLineW = 6;
    
    //扫码框周围4个角的宽度
    style.photoframeAngleW = 24;
    
    //扫码框周围4个角的高度
    style.photoframeAngleH = 24;
    
    //扫码框内 动画类型 --线条上下移动
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    
    //线条上下移动图片
    style.animationImage = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_light_green"];
    
    self.style = style;
    self.showButton = YES;
}

//模仿支付宝
- (void)alipayStyle
{
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 60;
    style.xScanRetangleOffset = 30;
    
    if ([UIScreen mainScreen].bounds.size.height <= 480 )
    {
        //3.5inch 显示的扫码缩小
        style.centerUpOffset = 40;
        style.xScanRetangleOffset = 20;
    }
    
    style.alpa_notRecoginitonArea = 0.6;
    
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
    style.photoframeLineW = 2.0;
    style.photoframeAngleW = 16;
    style.photoframeAngleH = 16;
    
    style.isNeedShowRetangle = NO;
    
    style.anmiationStyle = LBXScanViewAnimationStyle_NetGrid;
    
    //使用的支付宝里面网格图片
    UIImage *imgFullNet = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_full_net"];
    style.animationImage = imgFullNet;
    
    self.style = style;
}

//模仿微信
- (void)wxStyle
{
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 44;
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
    style.photoframeLineW = 2;
    style.photoframeAngleW = 18;
    style.photoframeAngleH = 18;
    style.isNeedShowRetangle = YES;
    
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    
    style.colorAngle = [UIColor colorWithRed:0./255 green:200./255. blue:20./255. alpha:1.0];
    
    //qq里面的线条图片
    UIImage *imgLine = [UIImage imageNamed:@"CodeScan.bundle/qrcode_Scan_weixin_Line"];
    // imgLine = [self createImageWithColor:[UIColor colorWithRed:120/255. green:221/255. blue:71/255. alpha:1.0]];
    style.animationImage = imgLine;
    
    self.style = style;
}

//无边框，内嵌4个角
- (void)noborderStyle
{
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 44;
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
    style.photoframeLineW = 3;
    style.photoframeAngleW = 18;
    style.photoframeAngleH = 18;
    style.isNeedShowRetangle = NO;
    
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    
    //qq里面的线条图片
    UIImage *imgLine = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_light_green"];
    style.animationImage = imgLine;
    
    self.style = style;;
}

//框内区域识别
- (void)innerStyle
{
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 44;
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_On;
    style.photoframeLineW = 6;
    style.photoframeAngleW = 24;
    style.photoframeAngleH = 24;
    style.isNeedShowRetangle = YES;
    
    style.anmiationStyle = LBXScanViewAnimationStyle_NetGrid;
    
    //矩形框离左边缘及右边缘的距离
    style.xScanRetangleOffset = 80;
    
    //使用的支付宝里面网格图片
    UIImage *imgPartNet = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_part_net"];
    
    style.animationImage = imgPartNet;
    
    self.style = style;
    self.isOpenInterestRect = YES;
}

//4个角在矩形框线上,网格动画
- (void)gridStyle
{
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 44;
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_On;
    style.photoframeLineW = 6;
    style.photoframeAngleW = 24;
    style.photoframeAngleH = 24;
    style.isNeedShowRetangle = YES;
    
    style.anmiationStyle = LBXScanViewAnimationStyle_NetGrid;
    
    //使用的支付宝里面网格图片
    UIImage *imgPartNet = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_part_net"];
    style.animationImage = imgPartNet;
    
    self.style = style;
}

//自定义4个角及矩形框颜色
- (void)colorStyle
{
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 44;
    
    //扫码框周围4个角的类型设置为在框的上面
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_On;
    //扫码框周围4个角绘制线宽度
    style.photoframeLineW = 6;
    
    //扫码框周围4个角的宽度
    style.photoframeAngleW = 24;
    
    //扫码框周围4个角的高度
    style.photoframeAngleH = 24;
    
    //显示矩形框
    style.isNeedShowRetangle = YES;
    
    //动画类型：网格形式，模仿支付宝
    style.anmiationStyle = LBXScanViewAnimationStyle_NetGrid;
    
    
    style.animationImage = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_part_net"];;
    
    //码框周围4个角的颜色
    style.colorAngle = [UIColor colorWithRed:65./255. green:174./255. blue:57./255. alpha:1.0];
    
    //矩形框颜色
    style.colorRetangleLine = [UIColor colorWithRed:247/255. green:202./255. blue:15./255. alpha:1.0];
    
    //非矩形框区域颜色
    style.red_notRecoginitonArea = 247./255.;
    style.green_notRecoginitonArea = 202./255;
    style.blue_notRecoginitonArea = 15./255;
    style.alpa_notRecoginitonArea = 0.2;
    
    self.style = style;
    
    //开启只识别矩形框内图像功能
    self.isOpenInterestRect = YES;
}

//
- (void)smallStyle
{
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    
    //矩形框向上移动
    style.centerUpOffset = 60;
    //矩形框离左边缘及右边缘的距离
    style.xScanRetangleOffset = 100;
    
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_On;
    style.photoframeLineW = 6;
    style.photoframeAngleW = 24;
    style.photoframeAngleH = 24;
    style.isNeedShowRetangle = YES;
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    
    //qq里面的线条图片
    UIImage *imgLine = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_light_green"];
    
    style.animationImage = imgLine;
    
    self.style = style;
}

/**
 *  条形码界面
 */
- (void)barcodeStyle
{
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 44;
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
    style.photoframeLineW = 4;
    style.photoframeAngleW = 28;
    style.photoframeAngleH = 16;
    style.isNeedShowRetangle = NO;
    
    style.anmiationStyle = LBXScanViewAnimationStyle_LineStill;
    
    style.animationImage = [self createImageWithColor:[UIColor redColor]];
    //非正方形
    //设置矩形宽高比
    style.whRatio = 4.3/2.18;
    
    //离左边和右边距离
    style.xScanRetangleOffset = 30;
    
    self.style = style;
}

- (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
