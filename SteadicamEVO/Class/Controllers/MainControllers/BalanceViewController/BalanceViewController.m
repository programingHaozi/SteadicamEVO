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
#import "GifViews.h"
#import "TipsView.h"
#import "CompanyWebViewController.h"
#import "AdjustmentViewController.h"

@interface BalanceViewController ()

@property (nonatomic, strong) PrepareChooseView *chooseView;

@property (weak, nonatomic) IBOutlet GifViews *gifView;

@property (weak, nonatomic) IBOutlet TFLabel *instructionLabel;

@property (weak, nonatomic) IBOutlet TFButton *nextButton;

@property (nonatomic, strong) BalanceViewModel *viewModel;

@property (nonatomic, strong) AdjustmentView *adjusetmentView;

@property (nonatomic, strong) SCEViewController *adjustMentVc;

@end

@implementation BalanceViewController
@dynamic viewModel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.viewModel.balanceState = BalanceStateUnFold;
    
    [self hideRightButton];
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"bundle:nil];
//    self.adjustMentVc        = [storyboard instantiateViewControllerWithIdentifier:@"AdjustmentViewController"];
}

- (void)initViews
{
    [super initViews];

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
            
            [weakSelf hideLeftButton];
            [weakSelf showRightButton];
        }
    };
}

-(void)autolayoutViews
{
    [super autolayoutViews];
    
    self.gifView.bounds = CGRectMake(0, 0, 254, 204);
    
    WS(weakSelf)
    [self.chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@304);
        make.height.equalTo(@124);
        make.centerX.equalTo(weakSelf.view.mas_centerX).offset(0);
        make.centerY.equalTo(weakSelf.view.mas_centerY).offset(32);
    }];
    
    [self.adjusetmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.view.mas_top).offset(64);
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
        
        [self initTitle:self.viewModel.title color:[UIColor whiteColor]];
        
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
    
    [RACObserve(self.viewModel, moviePath) subscribeNext:^(NSString *path) {
        
        @strongify(self)
    
        self.gifView.moviePath = path;
    }];
}

#pragma mark - Action -
- (IBAction)nextAction:(id)sender
{
    
    if (self.viewModel.balanceState == 7)
    {
        TipsView *tipView = [[TipsView alloc]initWithMessage:@"Balance complete"
                                                 buttonArray:@[@"OK"]];
        tipView.frame = CGRectMake(0, 0, 300, 200);
        
        WS(weakSelf)
        tipView.confirmBlock = ^(){
            
            [weakSelf dismissPopupView];
            
            
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"bundle:nil];
                self.adjustMentVc        = [storyboard instantiateViewControllerWithIdentifier:@"AdjustmentViewController"];

            [weakSelf pushViewController:self.adjustMentVc];
        };
        
        [self presentPopupView:tipView
                     animation:[TFPopupViewAnimationSpring new]
           backgroundClickable:NO];
    }
    
    self.viewModel.balanceState ++;
}

@end
