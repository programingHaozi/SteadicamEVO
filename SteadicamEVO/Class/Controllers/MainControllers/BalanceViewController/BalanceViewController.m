//
//  BalanceViewController.m
//  SteadicamEVO
//
//  Created by Chen Hao 陈浩 on 16/3/30.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import "BalanceViewController.h"
#import "PrepareChooseView.h"
#import "BalanceViewModel.h"
#import "AdjustmentView.h"

@interface BalanceViewController ()

@property (nonatomic, strong) PrepareChooseView *chooseView;

@property (weak, nonatomic) IBOutlet UIWebView *gifView;

@property (weak, nonatomic) IBOutlet TFLabel *instructionLabel;

@property (weak, nonatomic) IBOutlet TFButton *nextButton;

@property (nonatomic, strong) BalanceViewModel *viewModel;

@property (nonatomic, strong) AdjustmentView *adjusetmentView;

@end

@implementation BalanceViewController
@dynamic viewModel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.viewModel.balanceState = BalanceStateUnFold;
}

- (void)initViews
{
    [super initViews];
    
    
//    //自动调整尺寸
//    self.gifView.scalesPageToFit = YES;
//    //禁止滚动
//    self.gifView.scrollView.scrollEnabled = NO;
//    //设置透明效果
//    self.gifView.backgroundColor = [UIColor clearColor];
//    self.gifView.opaque = 0;
    
    self.adjusetmentView = tf_getViewFromNib(NSStringFromClass([AdjustmentView class]));
    self.adjusetmentView.hidden = YES;
    [self.view insertSubview:self.adjusetmentView belowSubview:self.nextButton];
    
    self.chooseView = [[PrepareChooseView alloc]initWithLeft:@"Later"
                                                       right:@"OK"
                                                       title:@"Are you ready to balance the evo now ?"];
    [self.view addSubview:self.chooseView];
    
    WS(weakSelf)
    self.chooseView.selectBlock = ^(NSInteger idx){
        
        if (idx == 0)
        {
            [weakSelf back];
        }
        else
        {
            [weakSelf.chooseView removeFromSuperview];
            
            weakSelf.gifView.hidden          = NO;
            weakSelf.instructionLabel.hidden = NO;
            weakSelf.nextButton.hidden       = NO;
        }
    };
}

-(void)autolayoutViews
{
    [super autolayoutViews];
    
    WS(weakSelf)
    [self.chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@304);
        make.height.equalTo(@124);
        make.centerX.equalTo(weakSelf.view.mas_centerX).offset(0);
        make.centerY.equalTo(weakSelf.view.mas_centerY).offset(32);
    }];
    
    [self.adjusetmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.view.mas_top).offset(44);
        make.left.equalTo(weakSelf.view.mas_left).offset(0);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(0);
        make.right.equalTo(weakSelf.view.mas_right).offset(0);
    }];
}

-(void)bindData
{
    [super bindData];
    
    @weakify(self)
    [RACObserve(self.viewModel, balanceState) subscribeNext:^(NSNumber *num) {
        
        [self initTitle:self.viewModel.title];
        
        @strongify(self)
        [self.nextButton setNormalTitle:@"Next"
                               textFont:nil
                              textColor:[UIColor whiteColor]];
        
        if (num.integerValue > 3)
        {
            [self.nextButton setNormalTitle:@"OK"
                                   textFont:nil
                                  textColor:[UIColor whiteColor]];
        }
        
        if (num.integerValue == 5 || num.integerValue == 7)
        {
            self.adjusetmentView.hidden  = NO;
            self.gifView.hidden          = YES;
            self.instructionLabel.hidden = YES;
        }
        else
        {
            if (num.integerValue > 0)
            {
                self.gifView.hidden          = NO;
                self.instructionLabel.hidden = NO;
            }
            self.adjusetmentView.hidden  = YES;
        }
    }];
    
    [RACObserve(self.viewModel, instruction) subscribeNext:^(NSString *instruction) {
        
        @strongify(self)
        self.instructionLabel.text = instruction;
        
    }];
    
    [RACObserve(self.viewModel, gifPath) subscribeNext:^(NSString *path) {
        
        @strongify(self)
    
        //将图片转为NSData
        NSData *gifData = [NSData dataWithContentsOfFile:path];
        
        //加载数据
        [self.gifView loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    }];
}

#pragma mark - Action -
- (IBAction)nextAction:(id)sender
{
    self.viewModel.balanceState ++;
}

@end
