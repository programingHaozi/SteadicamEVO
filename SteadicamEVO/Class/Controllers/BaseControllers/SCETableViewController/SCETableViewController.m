//
//  SCETableViewController.m
//  SteadicamEVO
//
//  Created by 耗子 on 16/4/6.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import "SCETableViewController.h"

@interface SCETableViewController ()<UINavigationBarDelegate>

@property (nonatomic, strong) UIImageView *BGImageView;

@property (nonatomic, strong) UINavigationItem *customNavigationItem;

@end

@implementation SCETableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isUseTemplate = YES;
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    navigationBar.delegate = self;
    [self.view addSubview:navigationBar];
    
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@""];
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    self.customNavigationItem=navigationItem;
    self.customNavigationBar=navigationBar;
    
    [self.customNavigationBar setBackgroundImage:IMAGE(@"navigationBar") forBarMetrics:UIBarMetricsDefault];
    
    [self initTitle:self.viewModel.title color:[UIColor whiteColor]];
    
    [self initLeftImage:@"back_white" highLightImage:@"back_black" selector:@selector(back)];
    [self initRightImage:@"home_white" highLightImage:@"home_black" selector:@selector(home)];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

#pragma mark- init autolayout bind

- (void)initViews
{
    [super initViews];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle      = UITableViewCellSeparatorStyleNone;
    
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
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(super.view).with.insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
}

- (void)bindData
{
    [super bindData];
}


-(void)initTitle:(NSString *)title
           color:(UIColor *)titleColor
{
    [self.customNavigationItem setTitle:title];
    
    [self.customNavigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:titleColor,
      NSForegroundColorAttributeName,nil]];
}

-(void)initLeftImage:(NSString *)strImage
      highLightImage:(NSString *)highLightImage
            selector:(SEL)selector
{
    CGRect rect   = CGRectMake(0, -2*SCREEN_WIDTH/320, [UIImage imageNamed:strImage].size.width, 44);
    UIButton *btn = [[UIButton alloc] initWithFrame:rect];
    
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highLightImage] forState:UIControlStateHighlighted];
    btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    btn.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.customNavigationItem.leftBarButtonItem = item;
}

-(void)initRightImage:(NSString *)strImage
       highLightImage:(NSString *)highLightImage
             selector:(SEL)selector
{
    CGRect rect = CGRectMake(0, -2*SCREEN_WIDTH/320, [UIImage imageNamed:strImage].size.width, 44);
    
    UIButton *btn = [[UIButton alloc] initWithFrame:rect];
    
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highLightImage] forState:UIControlStateHighlighted];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    btn.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.customNavigationItem.rightBarButtonItem = item;
}

- (void)hideLeftButton
{
    self.customNavigationItem.leftBarButtonItem.customView.hidden = YES;
}

-(void)showLeftButton
{
    self.customNavigationItem.leftBarButtonItem.customView.hidden = NO;
}

- (void)hideRightButton
{
    self.customNavigationItem.rightBarButtonItem.customView.hidden = YES;
}

-(void)showRightButton
{
    self.customNavigationItem.rightBarButtonItem.customView.hidden = NO;
}

#pragma mark - datasource -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (SCREEN_HEIGHT - 64)/[self.viewModel numberOfRowsInSection:indexPath.section];
}

#pragma mark - return action -

- (void)back
{
    [super back];
}

-(void)home
{
    [self popToRootViewController];
}

@end
