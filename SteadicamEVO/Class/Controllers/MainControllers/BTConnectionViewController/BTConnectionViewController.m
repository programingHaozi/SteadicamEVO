//
//  BTConnectionViewController.m
//  SteadicamEVO
//
//  Created by Chen Hao 陈浩 on 16/6/3.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import "BTConnectionViewController.h"
#import "BTConnectionViewCell.h"
#import "BTConnectionViewModel.h"

#define kRadianToDegrees(radian) (radian*180.0)/(M_PI)

@interface BTConnectionViewController ()

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@property (nonatomic, strong) BTConnectionViewModel *viewModel;

@property (nonatomic, strong) UIImageView *graybar;

@property (nonatomic, strong) UIImageView *selectBTBGImageView;

@property (nonatomic, strong) UILabel *seletedBTNameLabel;

@property (nonatomic, strong) UILabel *seletedStateLabel;

@property (nonatomic, strong) UIImageView *loadingImageView;

@property (nonatomic, strong) UILabel *helpLabel;

@property (nonatomic, strong) UIView *popView;

@property (nonatomic, strong) UIImageView *connectLoadingImageView;

@property (nonatomic, strong) UILabel *connectStateLabel;

@property (nonatomic, assign) BOOL isBTConnect;

@end

@implementation BTConnectionViewController
@dynamic viewModel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self hideRightButton];
    
    self.isUseTemplate = NO;
    
    self.isBTConnect = kBTConnectManager.isBTConnected;

}

- (void)initViews
{
    [super initViews];
    
    self.popView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 265, 50)];
    
    UIImageView *popBG = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 265, 50)];
    popBG.image = IMAGE(@"BT_messageBG");
    [self.popView addSubview:popBG];
    
    self.connectLoadingImageView = [[UIImageView alloc]init];
    self.connectLoadingImageView.image = IMAGE(@"BT_loading");
    [self.popView addSubview:self.connectLoadingImageView];
    
    self.connectStateLabel = [[UILabel alloc]init];
    self.connectStateLabel.font = [UIFont systemFontOfSize:14];
    [self.popView addSubview:self.connectStateLabel];
    
    self.selectBTBGImageView = [[UIImageView alloc]init];
    self.selectBTBGImageView.image = IMAGE(@"BT_seletedBTBG");
    [self.view addSubview:self.selectBTBGImageView];
    
    self.seletedBTNameLabel = [[UILabel alloc]init];
    self.seletedBTNameLabel.font = [UIFont systemFontOfSize:13];
    self.seletedBTNameLabel.text = @"BlueNRG";
    self.seletedBTNameLabel.textColor = HEXCOLOR(0x7e7e7e, 1);
    [self.selectBTBGImageView addSubview:self.seletedBTNameLabel];
    
    self.seletedStateLabel = [[UILabel alloc]init];
    self.seletedStateLabel.text = @"Connected";
    self.seletedStateLabel.font = [UIFont systemFontOfSize:9];
    self.seletedStateLabel.textColor = HEXCOLOR(0x7e7e7e, 1);
    [self.selectBTBGImageView addSubview:self.seletedStateLabel];
    
    self.graybar = [[UIImageView alloc]init];
    self.graybar.image = IMAGE(@"BT_graybar");
    [self.view addSubview:self.graybar];
    
    self.loadingImageView = [[UIImageView alloc]init];
    self.loadingImageView.image = IMAGE(@"BT_loading");
    [self.view addSubview:self.loadingImageView];
    
    CABasicAnimation* scanRotationAnimation;
    scanRotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    scanRotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * -2.0 ];
    scanRotationAnimation.duration = 0.5;
    scanRotationAnimation.cumulative = YES;
    scanRotationAnimation.repeatCount = MAXFLOAT;
    [self.loadingImageView.layer addAnimation:scanRotationAnimation forKey:@"rotationAnimation"];
    
    self.helpLabel = [[UILabel alloc]init];
    self.helpLabel.font = [UIFont systemFontOfSize:7];
    self.helpLabel.text = @"Select a device to connect";
    self.helpLabel.textColor = HEXCOLOR(0x7e7e7e, 1);
    [self.view addSubview:self.helpLabel];
}

-(void)autolayoutViews
{
    [super autolayoutViews];
    
    WS(weakSelf)
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(super.view).with.insets(UIEdgeInsetsMake(117, 125, 44, 125));
    }];
    
    [self.selectBTBGImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@79);
        make.width.equalTo(@269);
        make.height.equalTo(@39);
        make.centerX.equalTo(@0);
    }];
    
    [self.seletedBTNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@12);
        make.left.equalTo(@15);
    }];
    [self.seletedBTNameLabel setContentHuggingPriority:UILayoutPriorityRequired
                                        forAxis:UILayoutConstraintAxisHorizontal];
    [self.seletedBTNameLabel setContentHuggingPriority:UILayoutPriorityRequired
                                        forAxis:UILayoutConstraintAxisVertical];
    
    [self.seletedStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@16);
        make.left.equalTo(@200);
    }];
    [self.seletedStateLabel setContentHuggingPriority:UILayoutPriorityRequired
                                               forAxis:UILayoutConstraintAxisHorizontal];
    [self.seletedStateLabel setContentHuggingPriority:UILayoutPriorityRequired
                                               forAxis:UILayoutConstraintAxisVertical];
    
    [self.graybar mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@1.5);
        make.bottom.equalTo(weakSelf.tableView.mas_bottom).offset(0);
        make.left.equalTo(weakSelf.tableView.mas_left).offset(24);
        make.right.equalTo(weakSelf.tableView.mas_right).offset(-24);
    }];
    
    [self.helpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@-125);
        make.top.equalTo(weakSelf.tableView.mas_bottom).offset(10);
    }];
    [self.helpLabel setContentHuggingPriority:UILayoutPriorityRequired
                                               forAxis:UILayoutConstraintAxisHorizontal];
    [self.helpLabel setContentHuggingPriority:UILayoutPriorityRequired
                                               forAxis:UILayoutConstraintAxisVertical];
    
    [self.loadingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@14);
        make.height.equalTo(@14);
        make.right.equalTo(weakSelf.helpLabel.mas_left).offset(-8);
        make.centerY.equalTo(weakSelf.helpLabel.mas_centerY).offset(0);
    }];
    
    [self.connectLoadingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@14);
        make.height.equalTo(@14);
        make.top.equalTo(@18);
        make.left.equalTo(@18);
    }];
    
    [self.connectStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@16);
        make.left.equalTo(weakSelf.connectLoadingImageView.mas_right).offset(18);
    }];
    [self.connectStateLabel setContentHuggingPriority:UILayoutPriorityRequired
                                      forAxis:UILayoutConstraintAxisHorizontal];
    [self.connectStateLabel setContentHuggingPriority:UILayoutPriorityRequired
                                      forAxis:UILayoutConstraintAxisVertical];
}

-(void)bindData
{
    [super bindData];
    
    WS(weakSelf)
    [RACObserve(self, isBTConnect) subscribeNext:^(NSNumber *isConnect) {
        
        weakSelf.seletedStateLabel.hidden = !isConnect.boolValue;
        
        if (isConnect.boolValue)
        {
            weakSelf.seletedBTNameLabel.text = kBTConnectManager.connectName;
            weakSelf.seletedBTNameLabel.textColor = HEXCOLOR(0xff0000, 1);
        }
        else
        {
            weakSelf.seletedBTNameLabel.text = @"Not Connected";
            weakSelf.seletedBTNameLabel.textColor = HEXCOLOR(0x7e7e7e, 1);
        }
    }];
    
    [kBTConnectManager discoverDevice:^(NSArray *devices) {
        
        weakSelf.viewModel.dataArray = devices;
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - delegate -


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BTConnectionViewCell *cell = (BTConnectionViewCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    cell.BTNameLabel.text = self.viewModel.dataArray[indexPath.row];
    
    cell.selectBt = self.selectedIndexPath == indexPath;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [kBTConnectManager stopScan];
    self.loadingImageView.hidden = YES;
    self.connectLoadingImageView.hidden = NO;
    self.connectStateLabel.text = @"Connecting...";
    
    kBTConnectManager.needConnectName = self.viewModel.dataArray[indexPath.row];
    
    [self presentPopupView:self.popView
                 animation:[TFPopupViewAnimationSpring new]
       backgroundClickable:NO];
    
    CABasicAnimation* connectRotationAnimation;
    connectRotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    connectRotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    connectRotationAnimation.duration = 0.5;
    connectRotationAnimation.cumulative = YES;
    connectRotationAnimation.repeatCount = MAXFLOAT;
    [self.connectLoadingImageView.layer addAnimation:connectRotationAnimation forKey:@"rotationAnimation"];
    
    WS(weakSelf)
    [kBTConnectManager connectDeviceWithCompletion:^(NSInteger result) {
        
        weakSelf.isBTConnect = kBTConnectManager.isBTConnected;

        weakSelf.connectLoadingImageView.hidden = YES;
        
        if (result != 0)
        {
            weakSelf.connectStateLabel.text = @"The connection fails!";
        }
        else
        {
            weakSelf.connectStateLabel.text = @"The conenction is successful!";
            
            weakSelf.selectedIndexPath = indexPath;
            
            [weakSelf.tableView reloadData];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf dismissPopupView];
        });

    } disconnection:^(NSError *error) {
        
        weakSelf.isBTConnect = kBTConnectManager.isBTConnected;
        weakSelf.connectLoadingImageView.hidden = YES;
        weakSelf.connectStateLabel.text         = @"The connection fails!";
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf dismissPopupView];
        });
        
    }];
}



@end
