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

//@property (strong, nonatomic) CBCentralManager *centralManger;

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.customNavigationBar.hidden = YES;

    [kBTConnectManager connectDeviceWithCompletion:^(NSInteger result) {
        
    } disconnection:^(NSError *error) {
        
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
