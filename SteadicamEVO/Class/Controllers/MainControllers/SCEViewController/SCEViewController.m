//
//  SCEViewController.m
//  SteadicamEVO
//
//  Created by Chen Hao 陈浩 on 16/3/30.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import "SCEViewController.h"

@interface SCEViewController ()

/**
 *  导航栏
 */
@property (nonatomic, strong) UINavigationBar *navigationBar;

/**
 *  控制器视图背景图
 */
@property (nonatomic, strong) UIImageView *backgroundImageView;

/**
 *  导航栏控件
 */
@property (nonatomic, strong) UINavigationItem *navigationItem;

@end

@implementation SCEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark- init autolayout bind

- (void)initViews
{
    self.navigationBar = [[UINavigationBar alloc]init];
    [self.view insertSubview:self.navigationBar atIndex:0];

    self.navigationItem = [[UINavigationItem alloc] initWithTitle:@"Title"];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:nil
                                                                   action:@selector(goHome)];

    UIBarButtonItem *leftButton  = [[UIBarButtonItem alloc] initWithTitle:@"back"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:nil
                                                                   action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem  = leftButton;
    self.navigationItem.rightBarButtonItem = rightButton;
    [self.navigationBar pushNavigationItem:self.navigationItem animated:NO];

    self.backgroundImageView = [[UIImageView alloc]init];
    self.backgroundImageView.backgroundColor = [UIColor lightGrayColor];
    [self.view insertSubview:self.backgroundImageView atIndex:0];
}

- (void)autolayoutViews
{
    WS(weakSelf)
    [self.navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.view.mas_top).offset(20);
        make.height.equalTo(@44);
        make.left.equalTo(weakSelf.view.mas_left).offset(0);
        make.right.equalTo(weakSelf.view.mas_right).offset(0);
    }];
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.navigationBar.mas_bottom).offset(0);
        make.left.equalTo(weakSelf.view.mas_left).offset(0);
        make.right.equalTo(weakSelf.view.mas_right).offset(0);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(0);
    }];
}

- (void)bindData
{
    @weakify(self)
    [RACObserve(self.viewModel, title) subscribeNext:^(NSString *str) {
        
        @strongify(self)
        self.navigationItem.title =str;
    }];
}

#pragma mark- NaviagtionItem Action

- (void)goBack
{
    [self back];
}

- (void)goHome
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
