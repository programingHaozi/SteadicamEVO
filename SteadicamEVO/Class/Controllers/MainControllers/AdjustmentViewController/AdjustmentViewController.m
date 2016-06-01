//
//  AdjustmentViewController.m
//  SteadicamEVO
//
//  Created by Chen Hao 陈浩 on 16/5/18.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import "AdjustmentViewController.h"
#import "AdjustmentViewModel.h"
#import "TipsView.h"

@interface AdjustmentViewController()

@property (strong, nonatomic)  TFButton *startButton;

@property (strong, nonatomic)  TFButton *finishiButton;

@property (strong, nonatomic)  UILabel *instructionLabel;

@property (strong, nonatomic)  UILabel  *tiplabel;

@property (strong, nonatomic)  UIView *imageContainer1;

@property (strong, nonatomic)  UIImageView *arrowImageView1;

@property (strong, nonatomic)  UIImageView *phoneImageView1;

@property (strong, nonatomic)  UIView *imageContainer2;

@property (strong, nonatomic)  UIImageView *upArrowImageView2;

@property (strong, nonatomic)  UIImageView *downArrowImageView2;

@property (strong, nonatomic)  UIImageView *foreImageView2;

@property (strong, nonatomic)  UILabel *foreLabel;

@property (strong, nonatomic)  UILabel *weightLabel;

@property (strong, nonatomic)  UIImageView *weightImageView2;

@property (strong, nonatomic)  UIImageView *downArrowImageView;

@property (strong, nonatomic)  UILabel *notifyLabel;

@property (nonatomic, strong)  AdjustmentViewModel *viewModel;

@end

@implementation AdjustmentViewController
@dynamic viewModel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.viewModel.adjustState = AdjustStateZero;
    
    [self hideRightButton];
    
    NSString *str = @"$eVo,startmotor:do\r\n";
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [kBTConnectManager sendData:data];
}

-(void)initViews
{
    [super initViews];

    WS(weakSelf)
    
    self.startButton = [[TFButton alloc]init];
    [self.startButton setNormalTitle:@"Start" textFont:nil textColor:[UIColor whiteColor]];
    [self.startButton setBackgroundImage:IMAGE(@"blackButtonBg") forState:UIControlStateNormal];
    [self.startButton touchAction:^{
        
        [weakSelf startAction:weakSelf.startButton];
    }];
    [self.view addSubview:self.startButton];
    
    self.finishiButton = [[TFButton alloc]init];
    [self.finishiButton setNormalTitle:@"Finish" textFont:nil textColor:HEXCOLOR(0x7e7e7e, 1)];
    [self.finishiButton setBackgroundImage:IMAGE(@"blackButtonBg") forState:UIControlStateNormal];
    [self.finishiButton touchAction:^{
        
        [weakSelf finishAction:weakSelf.finishiButton];
    }];
    [self.view addSubview:self.finishiButton];
    
    self.instructionLabel = [[UILabel alloc]init];
    self.instructionLabel.numberOfLines = 0;
    self.instructionLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.instructionLabel];
    
    self.tiplabel = [[UILabel alloc]init];
    self.tiplabel.textColor = HEXCOLOR(0x7e7e7e, 1);
    self.tiplabel.font = [UIFont systemFontOfSize:10];
    self.tiplabel.text = @"Please don't tune phone when motors are running.";
    [self.view addSubview:self.tiplabel];
    
    self.imageContainer1 = [[UIView alloc]init];
    self.imageContainer1.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.imageContainer1];
    
    self.arrowImageView1 = [[UIImageView alloc]init];
    self.arrowImageView1.image = IMAGE(@"arrow_left_yellow_s");
    self.arrowImageView1.hidden = YES;
    [self.imageContainer1 addSubview:self.arrowImageView1];
    
    self.phoneImageView1 = [[UIImageView alloc]init];
    self.phoneImageView1.image = IMAGE(@"adjust_phone");
    [self.imageContainer1 addSubview:self.phoneImageView1];
    
    self.imageContainer2 = [[UIView alloc]init];
    self.imageContainer2.backgroundColor = [UIColor clearColor];
    self.imageContainer2.hidden = YES;
    [self.view addSubview:self.imageContainer2];
    
    self.upArrowImageView2 = [[UIImageView alloc]init];
    self.upArrowImageView2.image = IMAGE(@"arrow_up_gray");
    [self.imageContainer2 addSubview:self.upArrowImageView2];
    
    self.downArrowImageView2 = [[UIImageView alloc]init];
    self.downArrowImageView2.image = IMAGE(@"arrow_down_gray");
    [self.imageContainer2 addSubview:self.downArrowImageView2];
    
    self.foreImageView2 = [[UIImageView alloc]init];
    self.foreImageView2.image = IMAGE(@"adjust_foreAft");
    [self.imageContainer2 addSubview:self.foreImageView2];
    
    self.weightImageView2 = [[UIImageView alloc]init];
    self.weightImageView2.image = IMAGE(@"adjust_weight");
    [self.imageContainer2 addSubview:self.weightImageView2];
    
    self.foreLabel = [[UILabel alloc]init];
    self.foreLabel.text = @"Fore/Aft";
    self.foreLabel.font = [UIFont systemFontOfSize:13];
    self.foreLabel.textColor = HEXCOLOR(0x7e7e7e, 1);
    [self.imageContainer2 addSubview:self.foreLabel];
    
    self.weightLabel = [[UILabel alloc]init];
    self.weightLabel.text = @"Counterweight";
    self.weightLabel.font = [UIFont systemFontOfSize:13];
    self.weightLabel.textColor = HEXCOLOR(0x7e7e7e, 1);
    [self.imageContainer2 addSubview:self.weightLabel];
    
    self.downArrowImageView = [[UIImageView alloc]init];
    self.downArrowImageView.image = IMAGE(@"arrow_down_red_s");
    self.downArrowImageView.hidden = YES;
    [self.view addSubview:self.downArrowImageView];
    
    self.notifyLabel = [[UILabel alloc]init];
    self.notifyLabel.numberOfLines = 0;
    self.notifyLabel.textColor = [UIColor whiteColor];
    self.notifyLabel.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:self.notifyLabel];
    
}

-(void)autolayoutViews
{
    [super autolayoutViews];
    
    WS(weakSelf)
    
    [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@92);
        make.height.equalTo(@54);
        make.left.equalTo(@44);
        make.bottom.equalTo(@-34);
    }];
    
    [self.finishiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@92);
        make.height.equalTo(@54);
        make.right.equalTo(@-44);
        make.bottom.equalTo(@-34);
    }];
    
    [self.instructionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      
        make.width.equalTo(@210);
        make.height.equalTo(@64);
        make.left.equalTo(@50);
        make.top.equalTo(@104);
    }];
    
    [self.notifyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@210);
        make.height.equalTo(@40);
        make.left.equalTo(@50);
        make.top.equalTo(@64);
    }];
   
    
    [self.tiplabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@49);
        make.bottom.equalTo(weakSelf.startButton.mas_top).offset(-7);
    }];
    [self.tiplabel setContentHuggingPriority:UILayoutPriorityRequired
                                             forAxis:UILayoutConstraintAxisHorizontal];
    [self.tiplabel setContentHuggingPriority:UILayoutPriorityRequired
                                             forAxis:UILayoutConstraintAxisVertical];
    
    [self.imageContainer1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@260);
        make.height.equalTo(@120);
        make.right.equalTo(@0);
        make.top.equalTo(@64);
    }];
    
    [self.arrowImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@27);
        make.height.equalTo(@13);
        make.left.equalTo(@0);
        make.centerY.equalTo(@0);

    }];
    
    [self.phoneImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.width.equalTo(@106);
        make.height.equalTo(@90);
        make.left.equalTo(weakSelf.arrowImageView1.mas_right).offset(7);
        make.bottom.equalTo(@0);
    }];
    
    [self.imageContainer2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@260);
        make.height.equalTo(@120);
        make.right.equalTo(@0);
        make.top.equalTo(@64);
    }];
    
    [self.upArrowImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@27);
        make.height.equalTo(@24);
        make.left.equalTo(@0);
        make.top.equalTo(@30);
    }];
    
    [self.downArrowImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@27);
        make.height.equalTo(@24);
        make.left.equalTo(@0);
        make.bottom.equalTo(@-5);
    }];
    
    [self.foreImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@83);
        make.height.equalTo(@77);
        make.left.equalTo(weakSelf.upArrowImageView2.mas_right).offset(33);
        make.centerY.equalTo(@0);
    }];
    
    [self.weightImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.equalTo(@83);
        make.height.equalTo(@77);
        make.left.equalTo(weakSelf.foreImageView2.mas_right).offset(23);
        make.centerY.equalTo(@0);
    }];
    
    [self.foreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.foreImageView2.mas_bottom).offset(0);
        make.bottom.equalTo(@0);
        make.centerX.equalTo(weakSelf.foreImageView2.mas_centerX).offset(0);
    }];
    [self.foreLabel setContentHuggingPriority:UILayoutPriorityRequired
                                     forAxis:UILayoutConstraintAxisHorizontal];
    [self.foreLabel setContentHuggingPriority:UILayoutPriorityRequired
                                     forAxis:UILayoutConstraintAxisVertical];
    
    [self.weightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.weightImageView2.mas_bottom).offset(0);
        make.bottom.equalTo(@0);
        make.centerX.equalTo(weakSelf.weightImageView2.mas_centerX).offset(0);
    }];
    [self.weightLabel setContentHuggingPriority:UILayoutPriorityRequired
                                     forAxis:UILayoutConstraintAxisHorizontal];
    [self.weightLabel setContentHuggingPriority:UILayoutPriorityRequired
                                     forAxis:UILayoutConstraintAxisVertical];
    
    [self.downArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@35);
        make.height.equalTo(@25);
        make.bottom.equalTo(@-8);
        make.centerX.equalTo(@0);
    }];
    
    
}

-(void)bindData
{
    [super bindData];
    
    @weakify(self)
    [RACObserve(self.viewModel, adjustState) subscribeNext:^(NSNumber * state) {
        
        @strongify(self)
        
        self.instructionLabel.text = self.viewModel.instruction;
        
        self.downArrowImageView.hidden = !(self.viewModel.adjustState == AdjustStateThree);
        
        switch (state.intValue) {
            case 0:
            {
                
            }
                break;
            case 1:
            {
                
            }
                break;
            case 2:
            {
                self.arrowImageView1.hidden = NO;
            }
                break;
            case 3:
            {
                
                [self.instructionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    
                    make.width.equalTo(@400);
                    make.height.equalTo(@64);
                    make.left.equalTo(@50);
                    make.top.equalTo(@104);
                }];
                
                self.imageContainer1.hidden = YES;
                
                self.downArrowImageView.hidden = NO;
                
            }
                break;
            case 4:
            {
                
                
                TipsView *tipView = [[TipsView alloc]initWithMessage:@"Does the red mark digned?"
                                                         buttonArray:@[@"Yes",@"No"]];
                tipView.frame = CGRectMake(0, 0, 300, 200);
                
                WS(weakSelf)
                tipView.confirmBlock = ^(){
                    
                    [weakSelf dismissPopupView];
                    
                    weakSelf.viewModel.adjustState ++;
                };
                
                tipView.cancelBlock = ^(){
                    
                    [weakSelf dismissPopupView];
                };
                
                [self presentPopupView:tipView
                             animation:[TFPopupViewAnimationSpring new]
                   backgroundClickable:NO];
            }
                break;
            case 5:
            {
                [self.instructionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    
                    make.width.equalTo(@250);
                    make.height.equalTo(@64);
                    make.left.equalTo(@50);
                    make.top.equalTo(@104);
                }];
                
                [self initTitle:@"Pitch Adjustment" color:[UIColor whiteColor]];
                
                self.imageContainer2.hidden = NO;
                
                self.downArrowImageView.hidden = YES;
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    TipsView *tipView = [[TipsView alloc]initWithMessage:@"Please according to actual condition to adjust weight or Fore/Aft position."
                                                             buttonArray:@[@"OK"]];
                    tipView.frame = CGRectMake(0, 0, 300, 200);
                    
                    WS(weakSelf)
                    tipView.confirmBlock = ^(){
                        
                        [weakSelf dismissPopupView];
                    };
                    
                    [self presentPopupView:tipView
                                 animation:[TFPopupViewAnimationSpring new]
                       backgroundClickable:NO];
                });
                
                
            }
                break;
            case 6:
            {
                
            }
                break;
            case 7:
            {
                [self.downArrowImageView2 setImage:IMAGE(@"arrow_down_yellow")];
            }
                break;
                case 8:
            {
                self.imageContainer2.hidden = YES;
                
                self.imageContainer1.hidden = NO;
                
                self.arrowImageView1.hidden = YES;
                
                [self.phoneImageView1 setImage:IMAGE(@"adjust_complete")];
            }
                break;
                
            default:
                break;
        }
    }];
    
    
    [RACObserve(kBTConnectManager, notifyInfoStr) subscribeNext:^(NSString * info) {
    
    @strongify(self)
        
        self.notifyLabel.text = info;
    }];
}

- (void)startAction:(id)sender
{
    if (self.viewModel.adjustState == AdjustStateEight)
    {
        return;
    }
    
    self.viewModel.adjustState ++;
}
- (void)finishAction:(id)sender
{
    [super popToRootViewController];
}

@end
