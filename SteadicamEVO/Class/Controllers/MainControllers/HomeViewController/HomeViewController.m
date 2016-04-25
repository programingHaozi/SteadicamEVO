//
//  HomeViewController.m
//  SteadicamEVO
//
//  Created by Chen Hao 陈浩 on 16/3/30.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import "HomeViewController.h"
#import "BTConnectManager.h"

@interface HomeViewController ()<CBCentralManagerDelegate>

@property (strong, nonatomic) CBCentralManager *centralManger;

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setCustomNavigationBarHidden:YES];
    
    self.centralManger = [[CBCentralManager alloc] initWithDelegate:self
                                                              queue:nil];
    
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state == CBCentralManagerStatePoweredOn) {
        [self.centralManger scanForPeripheralsWithServices:nil
                                                   options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@(YES)}];
        NSLog(@">>>BLE状态正常");
    }else{
        NSLog(@">>>设备不支持BLE或者未打开");
    }
}

- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
    NSLog(@">>>>扫描周边设备 .. 设备id:%@, rssi: %@",[peripheral.identifier UUIDString],RSSI);
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

@end
