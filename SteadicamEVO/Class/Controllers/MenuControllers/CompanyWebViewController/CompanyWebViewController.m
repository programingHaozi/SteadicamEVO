//
//  CompanyWebViewController.m
//  SteadicamEVO
//
//  Created by Chen Hao 陈浩 on 16/3/30.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import "CompanyWebViewController.h"

@interface CompanyWebViewController ()

@property (nonatomic, strong) TFButton *yunButton;

@property (nonatomic, strong) TFButton *steButton;

@property (nonatomic, strong) UIImageView *seperateImageview;

@end

@implementation CompanyWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initViews
{
    [super initViews];
    
    self.yunButton = [[TFButton alloc]init];
    [self.yunButton setNormalImage:@"yun_logo"
                 hightlightedImage:nil
                     disabledImage:nil];
    [self.view addSubview:self.yunButton];
    
    self.steButton = [[TFButton alloc]init];
    [self.steButton setNormalImage:@"ste_logo"
                 hightlightedImage:nil
                     disabledImage:nil];
    [self.view addSubview:self.steButton];
    
    self.seperateImageview = [[UIImageView alloc]init];
    self.seperateImageview.image = IMAGE(@"seperateLine");
    [self.view addSubview:self.seperateImageview];
    
}

-(void)autolayoutViews
{
    [super autolayoutViews];
    
    WS(weakSelf)
    [self.seperateImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@1);
        make.centerY.equalTo(weakSelf.view.mas_centerY).offset(32);
        make.left.equalTo(weakSelf.view.mas_left).offset(24);
        make.right.equalTo(weakSelf.view.mas_right).offset(-24);
    }];
    
    
    [self.yunButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.view.mas_top).offset(64);
        make.left.equalTo(weakSelf.view.mas_left).offset(0);
        make.right.equalTo(weakSelf.view.mas_right).offset(0);
        make.bottom.equalTo(weakSelf.seperateImageview.mas_top).offset(0);
    }];
    
    [self.steButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.seperateImageview.mas_bottom).offset(0);
        make.left.equalTo(weakSelf.view.mas_left).offset(0);
        make.right.equalTo(weakSelf.view.mas_right).offset(0);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(0);
    }];
}

-(void)bindData
{
    [super bindData];
}


@end
