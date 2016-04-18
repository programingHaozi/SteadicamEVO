//
//  HomeViewController.m
//  SteadicamEVO
//
//  Created by Chen Hao 陈浩 on 16/3/30.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import "HomeViewController.h"
#import "BTConnectManager.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setCustomNavigationBarHidden:YES];
    
   [kBTConnectManager discoverDeviceNext:^BOOL(NSString *deviceName) {
       return YES;
    } completion:^(BOOL timeout) {
        
    } error:^(NSError *error) {
        
    }];
    
    
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
