//
//  SCEViewController.m
//  SteadicamEVO
//
//  Created by Chen Hao 陈浩 on 16/3/30.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import "SCEViewController.h"

@interface SCEViewController ()


@end

@implementation SCEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.customNavigationBar.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
    
    [self.customNavigationBar setBackgroundImage:IMAGE(@"navigationBar") forBarMetrics:UIBarMetricsDefault];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
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
