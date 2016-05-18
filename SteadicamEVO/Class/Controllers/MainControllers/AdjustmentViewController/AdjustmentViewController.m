//
//  AdjustmentViewController.m
//  SteadicamEVO
//
//  Created by Chen Hao 陈浩 on 16/5/18.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import "AdjustmentViewController.h"

@interface AdjustmentViewController()

@property (weak, nonatomic) IBOutlet TFButton *startButton;

@property (weak, nonatomic) IBOutlet TFButton *finishiButton;
@property (weak, nonatomic) IBOutlet UIView *imageContainer1;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *phoneImageView1;

@end

@implementation AdjustmentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)initViews
{
    [super initViews];
    
    [self hideRightButton];

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
