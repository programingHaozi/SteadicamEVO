//
//  VersionViewController.m
//  SteadicamEVO
//
//  Created by Chen Hao 陈浩 on 16/6/30.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import "VersionViewController.h"

@interface VersionViewController ()

@property (nonatomic, strong) UILabel *versionLabel;

@end

@implementation VersionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    char byteArray[] = {0xAA ,0x55 ,0x36, 0xFF};
    NSData *datas = [NSData dataWithBytes:byteArray length:sizeof(byteArray)];
    
    [kBTConnectManager sendData:datas];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    char byteArray[] = {0xAA ,0x55 ,0x02, 0xFF};
    NSData *datas = [NSData dataWithBytes:byteArray length:sizeof(byteArray)];
    
    [kBTConnectManager sendData:datas];
    
}

- (void)initViews
{
    [super initViews];
    
    self.versionLabel = [[UILabel alloc]init];
    self.versionLabel.numberOfLines = 0;
    self.versionLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.versionLabel];
}

-(void)autolayoutViews
{
    [super autolayoutViews];
    
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(@0);
        make.centerY.equalTo(@0);
    }];
    [self.versionLabel setContentHuggingPriority:UILayoutPriorityRequired
                                        forAxis:UILayoutConstraintAxisHorizontal];
    [self.versionLabel setContentHuggingPriority:UILayoutPriorityRequired
                                        forAxis:UILayoutConstraintAxisVertical];
}

-(void)bindData
{
    [super bindData];
    
    @weakify(self)
    [RACObserve(kBTConnectManager, notifyInfoStr) subscribeNext:^(NSString * info) {
        
        @strongify(self)
        
        self.versionLabel.text = [NSString stringWithFormat:@"evo_V0%@",[info substringWithRange:NSMakeRange(4,1)]];
    }];
}

@end
