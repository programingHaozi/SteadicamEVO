//
//  SCEViewController.m
//  SteadicamEVO
//
//  Created by Chen Hao 陈浩 on 16/3/30.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import "SCEViewController.h"

@interface SCEViewController ()

@property (nonatomic, strong) UIImageView *BGImageView;

@end

@implementation SCEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.customNavigationBar.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
    
    [self.customNavigationBar setBackgroundImage:IMAGE(@"navigationBar") forBarMetrics:UIBarMetricsDefault];
    
    [self initTitle:self.viewModel.title color:[UIColor whiteColor]];
    
    [self initLeftImage:@"back_white" highLightImage:@"back_black" selector:@selector(back)];
    [self initRightImage:@"home_white" highLightImage:@"home_black" selector:@selector(home)];
}

#pragma mark- init autolayout bind

- (void)initViews
{
    [super initViews];
    
    self.BGImageView = [[UIImageView alloc]init];
    self.BGImageView.image = IMAGE(@"background");
    [self.view insertSubview:self.BGImageView atIndex:0];
}

- (void)autolayoutViews
{
    [super autolayoutViews];
    
    WS(weakSelf)
    [self.BGImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.view.mas_top).offset(44);
        make.left.equalTo(weakSelf.view.mas_left).offset(0);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(0);
        make.right.equalTo(weakSelf.view.mas_right).offset(0);
    }];
}

- (void)bindData
{
    [super bindData];
}

#pragma mark - return action -

- (void)back
{
    [super back];
}

-(void)home
{
    [self popToRootViewController];
}

@end
