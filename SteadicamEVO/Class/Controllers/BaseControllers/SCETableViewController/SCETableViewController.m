//
//  SCETableViewController.m
//  SteadicamEVO
//
//  Created by 耗子 on 16/4/6.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import "SCETableViewController.h"

@interface SCETableViewController ()

@property (nonatomic, strong) UIImageView *BGImageView;

@end

@implementation SCETableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isUseTemplate = YES;
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.customNavigationBar.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
    
    [self.customNavigationBar setBackgroundImage:IMAGE(@"navigationBar") forBarMetrics:UIBarMetricsDefault];
    
    [self.customNavigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil]];
    
    [self initLeftImage:@"back_white" selector:@selector(back)];
    [self initRightImage:@"home_white" selector:@selector(home)];
}

#pragma mark- init autolayout bind

- (void)initViews
{
    [super initViews];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.BGImageView = [[UIImageView alloc]init];
    self.BGImageView.image = IMAGE(@"background");
    [self.view insertSubview:self.BGImageView atIndex:0];
}

- (void)autolayoutViews
{
    [super autolayoutViews];
    
    WS(weakSelf)
    [self.BGImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.view.mas_top).offset(0);
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
    [self popToViewController:[self getRootViewController]];
}

@end
