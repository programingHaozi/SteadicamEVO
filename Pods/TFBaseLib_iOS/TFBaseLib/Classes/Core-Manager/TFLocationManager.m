//
//  LocationManager.m
//  Treasure
//
//  Created by Hu Dan 胡丹 on 15/8/27.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFLocationManager.h"

#define kDefaultTimeOut 60*10   
#define LAST_LOCATION @"kUserLocation"

@implementation LocationModel

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        self.latitude=@"0";
        self.longitude=@"0";
        self.province=@"";
        self.city=@"";
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init])
    {
        self.latitude = [decoder decodeObjectForKey:@"latitude"];
        self.longitude = [decoder decodeObjectForKey:@"longitude"];
        self.province = [decoder decodeObjectForKey:@"province"];
        self.city = [decoder decodeObjectForKey:@"city"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.latitude forKey:@"latitude"];
    [encoder encodeObject:self.longitude forKey:@"longitude"];
    [encoder encodeObject:self.province forKey:@"province"];
    [encoder encodeObject:self.city forKey:@"city"];
}

@end

@interface TFLocationManager()<CLLocationManagerDelegate>
@property (strong,nonatomic) CLLocationManager *locationManager;

@property (strong,nonatomic) LocationModel *location;
@property (assign,nonatomic) BOOL stillLocationing;
@property (strong,nonatomic) NSTimer *myTimer;

@end

@implementation TFLocationManager


+ (void)load
{
    [super load];
    [[TFLocationManager sharedManager]sliceStartLocation];
}

+ (instancetype)sharedManager
{
    static TFLocationManager *sharedInstance=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TFLocationManager alloc] init];
    });
    return sharedInstance;
}

- (void)dealloc
{
    if (self.myTimer!=nil)
    {
        [self.myTimer invalidate];
        self.myTimer=nil;
    }
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.delegate = self;
        
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8)
        {
            [self.locationManager requestAlwaysAuthorization];  // 始终允许访问位置信息
            [self.locationManager requestWhenInUseAuthorization];  // 使用应用程序期间允许访问位置数据
        }
        
        self.location=[[LocationModel alloc]init];
        
        [self _saveLocationInUserDefaults];
        
        [self startTimer];
    }
    return self;
}

- (void)sliceStartLocation
{
    // 定位服务是否可用
    BOOL enable=[CLLocationManager locationServicesEnabled];
    
    // 是否具有定位权限
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    
    if (enable == YES && (authorizationStatus == kCLAuthorizationStatusAuthorizedAlways || authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse))
    {
        if (!self.stillLocationing)
        {
            self.stillLocationing=YES;
            CLLocationManager *locationManager = [TFLocationManager sharedManager].locationManager;
            [locationManager startUpdatingLocation];
        }
    }
}

- (void)startLocation:(void (^)(LocationModel* location))successBlock
               failed:(void (^)(NSString *errorMessage))failedBlock
{
    // 定位服务是否可用
    BOOL enable=[CLLocationManager locationServicesEnabled];
    
    // 是否具有定位权限
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    
    if (enable == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"定位服务处于关闭状态，请先前往系统设置中开启定位服务"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else if(authorizationStatus == kCLAuthorizationStatusDenied || authorizationStatus == kCLAuthorizationStatusRestricted)
    {
        //当需要提示关闭了定位功能的用户使用定位的时候可以给通过如下的方式跳转到设定画面：
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString: UIApplicationOpenSettingsURLString]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"您的应用的没有定位权限，请先前往系统设置中开启本应用的定位权限"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else if(authorizationStatus == kCLAuthorizationStatusAuthorizedAlways || authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        [self sliceStartLocation];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // 处理耗时操作的代码块...
            while (self.stillLocationing)
            {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
            
            // 通知主线程刷新
            dispatch_async(dispatch_get_main_queue(), ^{
                // 回调或者说是通知主线程刷新，
                if (successBlock)
                {
                    successBlock(_location);
                }
                
                if (failedBlock)
                {
                    
                }
            }); 
            
        });
    }
}

+ (void)startLocation:(void (^)(LocationModel* location))successBlock
               failed:(void (^)(NSString *errorMessage))failedBlock
{
    [[[self class]sharedManager]startLocation:successBlock failed:failedBlock];
}

# pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    switch (status)
    {
        case kCLAuthorizationStatusNotDetermined:
            break;
        case kCLAuthorizationStatusRestricted:
            break;
        case kCLAuthorizationStatusDenied:
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            break;
        default:
            break;
    }
    
    //是否具有定位权限
    BOOL servicesEnabled=[CLLocationManager locationServicesEnabled];
    self.servicesEnabled=servicesEnabled;
    
    //是否具有定位权限
    CLAuthorizationStatus authorizeEnabled = [CLLocationManager authorizationStatus];
    self.authorizeEnabled = (authorizeEnabled == kCLAuthorizationStatusAuthorizedAlways || authorizeEnabled == kCLAuthorizationStatusAuthorizedWhenInUse);
    
    [self sliceStartLocation];
}

/**
 *  < iOS 8
 */
-(void)locationManager:(CLLocationManager *)delegator didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [self locationManagerDidUpdateToLocation:newLocation];
}

/**
 *  > iOS 8
 */
- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self locationManagerDidUpdateToLocation:[locations lastObject]];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self.locationManager stopUpdatingLocation];
    
    NSString *errorString=@"";
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
    
    self.stillLocationing=NO;
}

-(void)locationManagerDidUpdateToLocation:(CLLocation *)newLocation
{
    [self.locationManager stopUpdatingLocation];
    
    // 保存Device的现语言
    NSMutableArray *userDefaultLanguages = [[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"];
    
    // 强制成简体中文
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-hans",nil]forKey:@"AppleLanguages"];
    
    self.longitude=[NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
    self.latitude=[NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
    [self _saveLocationInUserDefaults];
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation
                   completionHandler:^(NSArray *placemarks, NSError *error){
                       if (!error)
                       {
                           LocationModel *location=[[LocationModel alloc]init];
                           location.longitude=[NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
                           location.latitude=[NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
                           
                           CLPlacemark *placemark = [placemarks firstObject];
                           if (placemark!=nil)
                           {
                               //CLRegion *region=placemark.region;//区域
                               //NSDictionary *addressDic= placemark.addressDictionary;//详细地址信息字典,包含以下部分信息
                               //NSString *name=placemark.name;//地名
                               //NSString *thoroughfare=placemark.thoroughfare;//街道
                               //NSString *subThoroughfare=placemark.subThoroughfare; //街道相关信息，例如门牌等
                               NSString *locality=placemark.locality; // 城市
                               //NSString *subLocality=placemark.subLocality; // 城市相关信息，例如标志性建筑
                               NSString *administrativeArea=placemark.administrativeArea; // 州
                               //NSString *subAdministrativeArea=placemark.subAdministrativeArea; //其他行政区域信息
                               //NSString *postalCode=placemark.postalCode; //邮编
                               //NSString *ISOcountryCode=placemark.ISOcountryCode; //国家编码
                               //NSString *country=placemark.country; //国家
                               //NSString *inlandWater=placemark.inlandWater; //水源、湖泊
                               //NSString *ocean=placemark.ocean; // 海洋
                               //NSArray *areasOfInterest=placemark.areasOfInterest; //关联的或利益相关的地标
                               
                               if (!locality)
                               {
                                   locality = administrativeArea;
                               }
                               
                               location.city=[self _filterCityName:locality];
                               location.province=[self _filterCityName:administrativeArea];
                               
                               self.location=location;
                               self.province=location.province;
                               self.city=location.city;
                               
                               [self _saveLocationInUserDefaults];
                               //NSLog(@"location=%@",location);
                               
                               // 还原Device的语言
                               [[NSUserDefaults standardUserDefaults] setObject:userDefaultLanguages forKey:@"AppleLanguages"];
                           }
                       }
                       
                       self.stillLocationing=NO;
                   }];
}

-(void)timerFired
{
    [self sliceStartLocation];
}

-(void)startTimer
{
    [self stopTimer];
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:kDefaultTimeOut
                                                      target:self
                                            selector:@selector(timerFired)
                                                    userInfo:nil
                                                     repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.myTimer forMode:NSRunLoopCommonModes];
}

-(void)stopTimer
{
    if (self.myTimer!=nil)
    {
        [self.myTimer invalidate];
        self.myTimer = nil;
    }
}

-(LocationModel *)location
{
    LocationModel *ll= [self _getLocationFromUserDefaults];
    return ll;
}

#pragma mark- private metghod

- (void)_saveLocationInUserDefaults
{
    if (self.location.latitude==nil)
    {
        self.location.latitude=@"0";
    }
    
    if (self.location.longitude==nil)
    {
        self.location.longitude=@"0";
    }
    
    if (self.location.province==nil)
    {
        self.location.province=@"";
    }
    
    if (self.location.city==nil)
    {
        self.location.city=@"";
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:self.location];
    [defaults setObject:myEncodedObject forKey:LAST_LOCATION];
    [defaults synchronize];
}

- (LocationModel *) _getLocationFromUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id myEncodedObject = [defaults objectForKey:LAST_LOCATION];
    LocationModel *location=[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    return location;
}

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
    if (range_shi.location != 0 && range_shi.length != 0)
    {
        tmpCity = [tmpCity substringWithRange:NSMakeRange(0, range_shi.location)];
    }
    if (range_sheng.location != 0 && range_sheng.length != 0)
    {
        tmpCity = [tmpCity substringWithRange:NSMakeRange(0, range_sheng.location)];
    }
    if (range_zizhiqu.location != 0 && range_zizhiqu.length != 0)
    {
        tmpCity = [tmpCity substringWithRange:NSMakeRange(0, range_zizhiqu.location)];
    }
    return tmpCity;
}

@end
