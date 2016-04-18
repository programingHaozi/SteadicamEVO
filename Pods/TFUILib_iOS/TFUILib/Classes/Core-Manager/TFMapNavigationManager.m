//
//  TFMapNavigationManager.m
//  LocationBlock
//
//  Created by xiayiyong on 16/1/11.
//  Copyright © 2016年 xiayiyong. All rights reserved.
//

#import "TFMapNavigationManager.h"

const double tfx_pi = 3.14159265358979324 * 3000.0 / 180.0;

//火星转百度坐标
void bd_encrypt(double gg_lat, double gg_lon, double *bd_lat, double *bd_lon)
{
    double x = gg_lon, y = gg_lat;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * tfx_pi);
    double theta = atan2(y, x) + 0.000003 * cos(x * tfx_pi);
    *bd_lon = z * cos(theta) + 0.0065;
    *bd_lat = z * sin(theta) + 0.006;
}

//百度坐标转火星
void bd_decrypt(double bd_lat, double bd_lon, double *gg_lat, double *gg_lon)
{
    double x = bd_lon - 0.0065, y = bd_lat - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * tfx_pi);
    double theta = atan2(y, x) - 0.000003 * cos(x * tfx_pi);
    *gg_lon = z * cos(theta);
    *gg_lat = z * sin(theta);
}


@implementation TFMapNavigationManager
{
    double _fromLatitude;
    double _fromLongitute;
    double _toLatitude;
    double _toLongitute;
    NSString *_name;
    CLLocationManager *_manager;
}

+ (void)load
{
    [super load];
    [TFMapNavigationManager sharedManager];
}

+ (instancetype) sharedManager
{
    static TFMapNavigationManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TFMapNavigationManager alloc] init];
    });
    
    return sharedInstance;
}

+ (UIViewController*)getTopViewController
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
    {
        result = nextResponder;
    }
    else
    {
        result = window.rootViewController;
    }
    
    return result;
}

+(NSArray *)checkHasOwnApp
{
    NSArray *mapSchemeArr = @[@"comgooglemaps://",@"iosamap://navi",@"baidumap://map/",@"qqmap://"];
    
    NSMutableArray *appListArr = [[NSMutableArray alloc] initWithObjects:@"苹果原生地图", nil];
    
    for (int i = 0; i < [mapSchemeArr count]; i++) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[mapSchemeArr objectAtIndex:i]]]]) {
            if (i == 0)
            {
                [appListArr addObject:@"google地图"];
            }
            else if (i == 1)
            {
                [appListArr addObject:@"高德地图"];
            }
            else if (i == 2)
            {
                [appListArr addObject:@"百度地图"];
            }
            else if (i == 3)
            {
                [appListArr addObject:@"腾讯地图"];
            }
        }
    }
    
    return appListArr;
}

-(id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *name = _name;
    
    NSString *btnTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if (buttonIndex == 0)
    {
        CLLocationCoordinate2D from = CLLocationCoordinate2DMake(_fromLatitude, _fromLongitute);
        MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:from addressDictionary:nil]];
        currentLocation.name = @"我的位置";
        
        //终点
        CLLocationCoordinate2D to = CLLocationCoordinate2DMake(_toLatitude, _toLongitute);
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:to addressDictionary:nil]];
        NSLog(@"网页google地图:%f,%f",to.latitude,to.longitude);
        toLocation.name = name;
        NSArray *items = [NSArray arrayWithObjects:currentLocation, toLocation, nil];
        NSDictionary *options = @{
                                  MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
                                  MKLaunchOptionsMapTypeKey:
                                      [NSNumber numberWithInteger:MKMapTypeStandard],
                                  MKLaunchOptionsShowsTrafficKey:@YES
                                  };
        
        //打开苹果自身地图应用
        [MKMapItem openMapsWithItems:items launchOptions:options];
    }
    if ([btnTitle isEqualToString:@"google地图"])
    {
        NSString *urlStr = [NSString stringWithFormat:@"comgooglemaps://?saddr=%.8f,%.8f&daddr=%.8f,%.8f&directionsmode=transit",_fromLatitude,_fromLongitute,_toLatitude,_toLongitute];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }
    else if ([btnTitle isEqualToString:@"高德地图"])
    {
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=applicationName&sid=BGVIS1&slat=%f&slon=%f&sname=%@&did=BGVIS2&dlat=%f&dlon=%f&dname=%@&dev=0&m=0&t=0",_fromLatitude,_fromLongitute,@"我的位置",_toLatitude,_toLongitute,_name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *r = [NSURL URLWithString:urlString];
        [[UIApplication sharedApplication] openURL:r];
        
    }
    else if ([btnTitle isEqualToString:@"腾讯地图"])
    {
        
        NSString *urlStr = [NSString stringWithFormat:@"qqmap://map/routeplan?type=drive&fromcoord=%f,%f&tocoord=%f,%f&policy=1",_fromLatitude,_fromLongitute,_toLatitude,_toLongitute];
        NSURL *r = [NSURL URLWithString:urlStr];
        [[UIApplication sharedApplication] openURL:r];
    }
    else if([btnTitle isEqualToString:@"百度地图"])
    {
        double AdressLat,AdressLon;
        double NowLat,NowLon;
        
        bd_encrypt(_toLatitude,_toLongitute, &AdressLat, &AdressLon);
        bd_encrypt(_fromLatitude,_fromLongitute, &NowLat, &NowLon);
        NSString *stringURL = [NSString stringWithFormat:@"baidumap://map/direction?origin=%f,%f&destination=%f,%f&&mode=driving",NowLat,NowLon,AdressLat,AdressLon];
        NSURL *url = [NSURL URLWithString:stringURL];
        [[UIApplication sharedApplication] openURL:url];
    }
}

+ (void)navigationFromLatitude:(double)fromLatitude fromLongitute:(double)fromLongitute toLatitude:(double)toLatitude toLongitute:(double)toLongitute toName:(NSString *)name
{
    [[self sharedManager] navigationFromLatitude:fromLatitude fromLongitute:fromLongitute toLatitude:toLatitude toLongitute:toLongitute toName:name];
}

- (void)navigationFromLatitude:(double)fromLatitude fromLongitute:(double)fromLongitute toLatitude:(double)toLatitude toLongitute:(double)toLongitute toName:(NSString *)name{
    _fromLatitude = fromLatitude;
    _fromLongitute = fromLongitute;
    _toLatitude = toLatitude;
    _toLongitute = toLongitute;
    _name = name;
    NSArray *appListArr = [TFMapNavigationManager checkHasOwnApp];
    NSString *sheetTitle = [NSString stringWithFormat:@"导航到 %@",name];
    UIActionSheet *sheet;
    if ([appListArr count] == 1)
    {
        sheet = [[UIActionSheet alloc] initWithTitle:sheetTitle delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:appListArr[0], nil];
    }
    else if ([appListArr count] == 2)
    {
        sheet = [[UIActionSheet alloc] initWithTitle:sheetTitle delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:appListArr[0],appListArr[1], nil];
    }
    else if ([appListArr count] == 3)
    {
        sheet = [[UIActionSheet alloc] initWithTitle:sheetTitle delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:appListArr[0],appListArr[1],appListArr[2], nil];
    }
    else if ([appListArr count] == 4)
    {
        sheet = [[UIActionSheet alloc] initWithTitle:sheetTitle delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:appListArr[0],appListArr[1],appListArr[2],appListArr[3], nil];
    }
    else if ([appListArr count] == 5)
    {
        sheet = [[UIActionSheet alloc] initWithTitle:sheetTitle delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:appListArr[0],appListArr[1],appListArr[2],appListArr[3],appListArr[4], nil];
    }
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [sheet showInView:[[self class] getTopViewController].view];
}

+ (void)navigationtoLatitude:(double)toLatitude toLongitute:(double)toLongitute toName:(NSString *)name
{
    [[self sharedManager] navigationtoLatitude:toLatitude toLongitute:toLongitute toName:name];
}

- (void)navigationtoLatitude:(double)toLatitude toLongitute:(double)toLongitute toName:(NSString *)name
{
    [self startLocation];
    _toLatitude = toLatitude;
    _toLongitute = toLongitute;
    _name = name;
}

//获取经纬度
-(void)startLocation
{
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        _manager=[[CLLocationManager alloc]init];
        _manager.delegate=self;
        _manager.desiredAccuracy = kCLLocationAccuracyBest;
        [_manager requestAlwaysAuthorization];
        _manager.distanceFilter=100;
        [_manager startUpdatingLocation];
    }
    else
    {
        UIAlertView *alvertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"需要开启定位服务,请到设置->隐私,打开定位服务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alvertView show];
    }
    
}
#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [self navigationFromLatitude:newLocation.coordinate.latitude fromLongitute:newLocation.coordinate.longitude toLatitude:_toLatitude toLongitute:_toLongitute toName:_name];
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    [self stopLocation];
    
}

-(void)stopLocation
{
    _manager = nil;
}


@end
