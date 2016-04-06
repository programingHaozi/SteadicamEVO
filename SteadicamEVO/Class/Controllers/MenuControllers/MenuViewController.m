//
//  MenuViewController.m
//  SteadicamEVO
//
//  Created by Chen Hao 陈浩 on 16/3/30.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()<
UITableViewDelegate,
UITableViewDataSource
>

@end

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self hideRightButton];
}

- (void)initViews
{
    [super initViews];

}

-(void)autolayoutViews
{
    [super autolayoutViews];
}

-(void)bindData
{
    [super bindData];
}


@end
