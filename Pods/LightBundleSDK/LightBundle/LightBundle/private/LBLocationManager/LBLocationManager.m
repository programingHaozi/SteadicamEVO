//
//  LocationManager.m
//  Treasure
//
//  Created by Hu Dan 胡丹 on 15/8/27.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "LBLocationManager.h"

#define kDefaultTimeOut 30

@implementation LBLocationModel

@end

@interface LBLocationManager()<CLLocationManagerDelegate>
@property (strong,nonatomic) CLLocationManager *locationManager;
@property (strong,nonatomic) LocationUpdateBlock locationDidUpdate;
@property (strong,nonatomic) LocationFailedBlock locationDidFailed;
@property (strong,nonatomic) NSTimer *timer;
@property (assign,nonatomic) BOOL stillLocationing;
@end

@implementation LBLocationManager

+ (void)startLocation
{
    [[LBLocationManager sharedManager]startLocationWithUpdateBlock:nil failedBlock:nil];
}

+ (LBLocationManager*)sharedManager
{
    static LBLocationManager *sharedInstance=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LBLocationManager alloc] init];
    });
    return sharedInstance;
}

- (void)dealloc
{
    if (_timer!=nil)
    {
        [_timer invalidate];
        _timer=nil;
    }
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.distanceFilter = kCLDistanceFilterNone; // meters
        _locationManager.distanceFilter = 100.0f;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.delegate = self;
        
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8)
        {
            [_locationManager requestAlwaysAuthorization];
            [_locationManager requestWhenInUseAuthorization];
        }
        
//        _location.province = @"";
        _location.city = @"";
        _location.longitude = 0;
        _location.latitude = 0;
        
        
//        if (_timer == nil)
//        {
//            _timer = [NSTimer scheduledTimerWithTimeInterval:kDefaultTimeOut
//                                target:self
//                                selector:@selector(timerFired:)
//                                userInfo:nil
//                                repeats:YES];
//        }

    }
    return self;
}

+ (void)startLocationWithUpdateBlock:(LocationUpdateBlock)didUpdate failedBlock:(LocationFailedBlock)didFailed
{
    LBLocationManager *manager=[LBLocationManager sharedManager];
    manager.locationDidUpdate = didUpdate;
    manager.locationDidFailed = didFailed;
    [manager.locationManager startUpdatingLocation];
//    [manager sliceStartLocation];
}

- (void)startLocationWithUpdateBlock:(LocationUpdateBlock)didUpdate failedBlock:(LocationFailedBlock)didFailed
{
    [[self class]startLocationWithUpdateBlock:didUpdate failedBlock:didFailed];
}

- (void)sliceStartLocation
{
    //是否具有定位权限
    BOOL servicesEnabled = [CLLocationManager locationServicesEnabled];
    _servicesEnabled = servicesEnabled;
    //
    //    //是否具有定位权限
    CLAuthorizationStatus authorizeEnabled = [CLLocationManager authorizationStatus];
    _authorizeEnabled = (authorizeEnabled == kCLAuthorizationStatusAuthorizedAlways || authorizeEnabled == kCLAuthorizationStatusAuthorizedWhenInUse);
    
    //定位服务开始且具有定位权限 则开始定位
    if (_servicesEnabled && _authorizeEnabled) {
        if (!_stillLocationing) {
            _stillLocationing = YES;
            [[LBLocationManager sharedManager].locationManager startUpdatingLocation];
//            if (_timer == nil)
//            {
//                _timer = [NSTimer scheduledTimerWithTimeInterval:kDefaultTimeOut
//                                                target:self
//                                                selector:@selector(timerFired:)
//                                                userInfo:nil
//                                                repeats:NO];
//            }

        }
    }
}

/**
 *  检查定位服务以及定位权限
 */
+ (BOOL)checkLocationServicesEnabled{
    //定位服务是否可用
    
    BOOL servicesEnabled = [CLLocationManager locationServicesEnabled];
//    _servicesEnabled = servicesEnabled;
    return servicesEnabled;
}

+ (BOOL)checkCLAuthorizationStatus{
    //是否具有定位权限
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    if(authorizationStatus == kCLAuthorizationStatusDenied || authorizationStatus == kCLAuthorizationStatusRestricted)
    {
        //当需要提示关闭了定位功能的用户使用定位的时候可以给通过如下的方式跳转到设定画面：
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString: UIApplicationOpenSettingsURLString]];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                        message:@"您的应用的没有定位权限，请先前往系统设置中开启本应用的定位权限"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
        return NO;
    }
    else if(authorizationStatus == kCLAuthorizationStatusAuthorizedAlways || authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        return YES;
        
    }
    return NO;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    switch (status)
    {
        case kCLAuthorizationStatusNotDetermined:
            [manager requestWhenInUseAuthorization];
            break;
        case kCLAuthorizationStatusRestricted:
            _locationDidFailed(@"位置服务不可用！");
            break;
        case kCLAuthorizationStatusDenied:
            _locationDidFailed(@"请打开该app的位置服务!");
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
            [self sliceStartLocation];
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self sliceStartLocation];
            break;
        default:
            break;
    }
    
//    //是否具有定位权限
//    BOOL servicesEnabled = [CLLocationManager locationServicesEnabled];
//    _servicesEnabled = servicesEnabled;
////
////    //是否具有定位权限
//    CLAuthorizationStatus authorizeEnabled = [CLLocationManager authorizationStatus];
//    _authorizeEnabled = (authorizeEnabled == kCLAuthorizationStatusAuthorizedAlways || authorizeEnabled == kCLAuthorizationStatusAuthorizedWhenInUse);
//    [self sliceStartLocation];
}



- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"%f======%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    [_locationManager stopUpdatingLocation];
    _stillLocationing = NO;
//    if ([_timer isValid]) {
//        [_timer invalidate];
//        _timer = nil;
//    }
    if (!_locationDidUpdate)
    {
        return;
    }
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation
                   completionHandler:^(NSArray *placemarks, NSError *error){
                       LBLocationModel *model=[[LBLocationModel alloc]init];
                       model.longitude=[NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
                       model.latitude=[NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
                       
                       if (error == nil  && [placemarks count] > 0)
                       {
                           CLPlacemark *placemark       = placemarks[0];
                           NSString *city               = placemark.locality;
                           NSString *administrativeArea = placemark.administrativeArea;
                           if (!city)
                           {
                               city = placemark.administrativeArea;
                           }
                           
                           model.city=[self _filterCityName:city];
//                           model.province=[self _filterCityName:administrativeArea];
                       }
                       
                       _locationDidUpdate(model);
                       
                       _location = model;
                       
                   }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [_locationManager stopUpdatingLocation];
    
    if (!_locationDidFailed)
    {
        return;
    }
    
    NSString *errorString = @"";
    switch([error code])
    {
        case kCLErrorDenied:
            errorString = @"请打开该app的位置服务!";
            break;
        case kCLErrorLocationUnknown:
            errorString = @"位置服务不可用!";
            break;
        default:
            errorString = @"定位发生错误!";
            break;
    }
    
    _stillLocationing = NO;
    NSLog(@"errorString = %@", errorString);
    
    _locationDidFailed(errorString);
}

//-(void)timerFired:(NSTimer *)timer
//{
//    [[LBLocationManager sharedManager]startLocationWithUpdateBlock:nil failedBlock:nil];
//}

-(NSString *)_filterCityName:(NSString *)name
{
    NSString *tmpCity;
    NSString *tmpShi      = @"市";
    NSString *tmpSheng    = @"省";
    NSString *tmpZiZhiQu  = @"自治区";
    
    //当前省去掉“省, 市, 自治区”字
    tmpCity               = [NSString stringWithFormat:@"%@", name];
    NSRange range_shi     = [tmpCity rangeOfString:tmpShi];
    NSRange range_sheng   = [tmpCity rangeOfString:tmpSheng];
    NSRange range_zizhiqu = [tmpCity rangeOfString:tmpZiZhiQu];
    if (range_shi.location != 0 && range_shi.length != 0) {
        tmpCity = [tmpCity substringWithRange:NSMakeRange(0, range_shi.location)];
    }
    if (range_sheng.location != 0 && range_sheng.length != 0) {
        tmpCity = [tmpCity substringWithRange:NSMakeRange(0, range_sheng.location)];
    }
    if (range_zizhiqu.location != 0 && range_zizhiqu.length != 0) {
        tmpCity = [tmpCity substringWithRange:NSMakeRange(0, range_zizhiqu.location)];
    }
    return tmpCity;
}

@end
