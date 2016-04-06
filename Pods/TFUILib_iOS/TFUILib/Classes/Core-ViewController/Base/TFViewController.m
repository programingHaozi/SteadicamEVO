//
//  TFViewController.m
//  Treasure
//
//  Created by xiayiyong on 15/9/7.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFViewController.h"
#import "TFUICategory.h"
#import "TFUIUtil.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface TFViewController ()

@property(nonatomic,strong)NSMutableArray *activeRequests;

@property(nonatomic,strong)UIView *headView;

@property(nonatomic,strong)UIView *footView;

@property(nonatomic,strong)TFLoadingView *loadingView;

@end

@implementation TFViewController

#pragma mark- init

- (id)initWithResultBlock:(TFViewControllerResultBlock)block
{
    return [self initWithViewModel:nil resultBlock:block];
}

- (id)initWithViewModel:(id)viewModel
{
    return [self initWithViewModel:viewModel resultBlock:nil];
}

- (id)initWithViewModel:(id)viewModel resultBlock:(TFViewControllerResultBlock)block
{
    self = [super init];
    if (self)
    {
        // Initialization code
        _viewModel = viewModel;
        _resultBlock     = block;
    }
    
    return self;
}

- (id)initWithData:(NSDictionary*)data
{
    return [self initWithData:nil resultBlock:nil];
}

- (id)initWithData:(NSDictionary*)data resultBlock:(TFViewControllerResultBlock)block
{
    self = [super init];
    if (self)
    {
        // Initialization code
        _resultBlock=block;
        
        NSString *viewControllerClassName = NSStringFromClass([self class]);
        NSString *viewModelClassName      = [viewControllerClassName stringByReplacingOccurrencesOfString:@"ViewController" withString:@"ViewModel"];
        
        Class viewModel = NSClassFromString(viewModelClassName);
        if (viewModel)
        {
            _viewModel = [viewModel mj_objectWithKeyValues:data];
        }
    }
    
    return self;
}

- (id)initWithViewModel:(id)viewModel
                nibName:(NSString *)nibName
                 bundle:(NSBundle *)bundle
{
    self = [super initWithNibName:nibName bundle:bundle];
    if (self == nil) return nil;
    
    _viewModel = viewModel;
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.top=65;
    
    //[self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];
    
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navigationBar.delegate = self;
    [self.view addSubview:navigationBar];
    
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    self.customNavigationItem=navigationItem;
    self.customNavigationBar=navigationBar;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self initBackButton];
    
    if ([self.viewModel respondsToSelector:@selector(title)])
    {
        if ([self.viewModel title] != nil)
        {
            self.title = [self.viewModel title];
            [self initTitle:self.title];
        }
    }
    
    //statusbar改白色
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets           = NO;
    self.navigationController.navigationBar.translucent = NO;
    
    [self initViews];
    [self autolayoutViews];
    [self bindData];
}

#pragma mark- 控制状态栏的样式

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark- init autolayout bind

- (void)initViews
{
    
}

- (void)autolayoutViews
{
    
}

- (void)bindData
{
    
}

#pragma mark- showNavigationBar

- (void)showNavigationBar
{
    
}

- (void)hideNavigationBar
{
    
}

#pragma mark load data

- (void)startLoadData
{
    
}

- (void)endLoadData
{
    [self hideHUD];
}

#pragma mark- setter getter

- (id)viewModel
{
    if (_viewModel == nil)
    {
        NSString *viewControllerClassName = NSStringFromClass([self class]);
        NSString *viewModelClassName      = [viewControllerClassName stringByReplacingOccurrencesOfString:@"ViewController" withString:@"ViewModel"];
        
        Class viewModel = NSClassFromString(viewModelClassName);
        if (viewModel)
        {
            _viewModel = [[viewModel alloc]init];
        }
    }

    return _viewModel;
}

#pragma mark init button

-(void)setCustomNavigationBarHidden:(BOOL)customNavigationBarHidden
{
    self.customNavigationBar.hidden=customNavigationBarHidden;
    if (customNavigationBarHidden)
    {
        self.top=0;
    }
    else
    {
        self.top=65;
    }
    
    // 告诉self.view约束需要更新
    [self.view setNeedsUpdateConstraints];
    
    // 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
    [self.view updateConstraintsIfNeeded];
    
    [self.view layoutIfNeeded];

}

-(void)initTitle:(NSString*)title
{
    [self.customNavigationItem setTitle:title];
}

-(void)initTitle:(NSString *)title
           color:(UIColor *)titleColor
{
    [self.customNavigationItem setTitle:title];
    
    [self.customNavigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:titleColor,
      NSForegroundColorAttributeName,nil]];
}

- (void)initMiddleView:(UIView*)view
{
    self.customNavigationItem.titleView = view;
}

- (void)initLeftImage:(NSString *)strImage
{
    CGRect rect   = CGRectMake(0, -2*SCREEN_WIDTH/320, 60, 44);
    UIButton *btn = [[UIButton alloc] initWithFrame:rect];
    
    [btn addTarget:self action:@selector(leftButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateHighlighted];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.customNavigationItem.leftBarButtonItem = item;
}

-(void)initLeftImage:(NSString *)strImage
      highLightImage:(NSString *)highLightImage
{
    CGRect rect   = CGRectMake(0, -2*SCREEN_WIDTH/320, 60, 44);
    UIButton *btn = [[UIButton alloc] initWithFrame:rect];
    
    [btn addTarget:self action:@selector(leftButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highLightImage] forState:UIControlStateHighlighted];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.customNavigationItem.leftBarButtonItem = item;
}

- (void)initLeftImage:(NSString *)strImage
             selector:(SEL)selector
{
    CGRect rect   = CGRectMake(0, -2*SCREEN_WIDTH/320, 60, 44);
    UIButton *btn = [[UIButton alloc] initWithFrame:rect];
    
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateHighlighted];
    btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    btn.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.customNavigationItem.leftBarButtonItem = item;
}

-(void)initLeftImage:(NSString *)strImage
      highLightImage:(NSString *)highLightImage
            selector:(SEL)selector
{
    CGRect rect   = CGRectMake(0, -2*SCREEN_WIDTH/320, 60, 44);
    UIButton *btn = [[UIButton alloc] initWithFrame:rect];
    
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highLightImage] forState:UIControlStateHighlighted];
    btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    btn.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.customNavigationItem.leftBarButtonItem = item;
}

- (void)initLeftTitle:(NSString *)strTitle
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
    
    [btn setTitle:strTitle forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [btn sizeToFit];
    [btn addTarget:self action:@selector(leftButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [btn setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.customNavigationItem.leftBarButtonItem = item;
    
}

- (void)initLeftTitle:(NSString *)strTitle
             selector:(SEL)selector
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
    
    [btn setTitle:strTitle forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [btn sizeToFit];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.customNavigationItem.leftBarButtonItem = item;
}

- (void)initLeftTitle:(NSString *)strTitle
                color:(UIColor *)color
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
    
    [btn setTitle:strTitle forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [btn sizeToFit];
    [btn addTarget:self action:@selector(leftButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [btn setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.customNavigationItem.leftBarButtonItem = item;
}

- (void)initLeftTitle:(NSString *)strTitle
                color:(UIColor *)color
             selector:(SEL)selector
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
    
    [btn setTitle:strTitle forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [btn sizeToFit];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.customNavigationItem.leftBarButtonItem = item;
}

- (void)initLeftImage:(NSString *)strImage
                title:(NSString *)strTitle
                color:(UIColor *)color
{
    CGRect rect = CGRectMake(0, -2*SCREEN_WIDTH/320, 60, 44);
    
    UIButton *btn = [[UIButton alloc] initWithFrame:rect];
    
    [btn addTarget:self action:@selector(leftButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateHighlighted];
    [btn setTitle:strTitle forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.customNavigationItem.leftBarButtonItem = item;
}

-(void)initLeftImage:(NSString *)strImage
      highLightImage:(NSString *)highLightImage
               title:(NSString *)strTitle
               color:(UIColor *)color
{
    CGRect rect = CGRectMake(0, -2*SCREEN_WIDTH/320, 60, 44);
    
    UIButton *btn = [[UIButton alloc] initWithFrame:rect];
    
    [btn addTarget:self action:@selector(leftButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highLightImage] forState:UIControlStateHighlighted];
    [btn setTitle:strTitle forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.customNavigationItem.leftBarButtonItem = item;
}

- (void)initLeftImage:(NSString *)strImage
                title:(NSString *)strTitle
                color:(UIColor *)color
             selector:(SEL)selector
{
    CGRect rect = CGRectMake(0, -2*SCREEN_WIDTH/320, 60, 44);
    
    UIButton *btn = [[UIButton alloc] initWithFrame:rect];
    
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateHighlighted];
    [btn setTitle:strTitle forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.customNavigationItem.leftBarButtonItem = item;
}

-(void)initLeftImage:(NSString *)strImage
      highLightImage:(NSString *)highLightImage
               title:(NSString *)strTitle
               color:(UIColor *)color
            selector:(SEL)selector
{
    CGRect rect = CGRectMake(0, -2*SCREEN_WIDTH/320, 60, 44);
    
    UIButton *btn = [[UIButton alloc] initWithFrame:rect];
    
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highLightImage] forState:UIControlStateHighlighted];
    [btn setTitle:strTitle forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.customNavigationItem.leftBarButtonItem = item;
}

- (void)initRightImage:(NSString *)strImage
{
    CGRect rect = CGRectMake(0, -2*SCREEN_WIDTH/320, 60, 44);
    
    UIButton *btn = [[UIButton alloc] initWithFrame:rect];
    
    [btn addTarget:self action:@selector(rightButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateHighlighted];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    btn.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.customNavigationItem.rightBarButtonItem = item;
}

-(void)initRightImage:(NSString *)strImage
       highLightImage:(NSString *)highLightImage
{
    CGRect rect = CGRectMake(0, -2*SCREEN_WIDTH/320, 60, 44);
    
    UIButton *btn = [[UIButton alloc] initWithFrame:rect];
    
    [btn addTarget:self action:@selector(rightButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highLightImage] forState:UIControlStateHighlighted];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    btn.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.customNavigationItem.rightBarButtonItem = item;
}

- (void)initRightImage:(NSString *)strImage
              selector:(SEL)selector
{
    CGRect rect = CGRectMake(0, -2*SCREEN_WIDTH/320, 60, 44);
    
    UIButton *btn = [[UIButton alloc] initWithFrame:rect];
    
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateHighlighted];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    btn.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.customNavigationItem.rightBarButtonItem = item;
}

-(void)initRightImage:(NSString *)strImage
       highLightImage:(NSString *)highLightImage
             selector:(SEL)selector
{
    CGRect rect = CGRectMake(0, -2*SCREEN_WIDTH/320, 60, 44);
    
    UIButton *btn = [[UIButton alloc] initWithFrame:rect];
    
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highLightImage] forState:UIControlStateHighlighted];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    btn.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.customNavigationItem.rightBarButtonItem = item;
}

- (void)initRightTitle:(NSString *)strTitle
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
    
    [btn setTitle:strTitle forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [btn sizeToFit];
    [btn addTarget:self action:@selector(rightButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [btn setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.customNavigationItem.rightBarButtonItem = item;
}

- (void)initRightTitle:(NSString *)strTitle selector:(SEL)selector
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
    
    [btn setTitle:strTitle forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [btn sizeToFit];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.customNavigationItem.rightBarButtonItem = item;
}

- (void)initRightTitle:(NSString *)strTitle color:(UIColor *)color;
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
    
    [btn setTitle:strTitle forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [btn sizeToFit];
    [btn addTarget:self action:@selector(rightButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [btn setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.customNavigationItem.rightBarButtonItem = item;
}

- (void)initRightTitle:(NSString *)strTitle
                 color:(UIColor *)color
              selector:(SEL)selector
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
    
    [btn setTitle:strTitle forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [btn sizeToFit];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.customNavigationItem.rightBarButtonItem = item;
}

- (void)initRightImage:(NSString *)strImage
                 title:(NSString *)strTitle
                 color:(UIColor *)color
{
    CGRect rect = CGRectMake(0, -2*SCREEN_WIDTH/320, 60, 44);
    
    UIButton *btn = [[UIButton alloc] initWithFrame:rect];
    
    [btn addTarget:self action:@selector(rightButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateHighlighted];
    [btn setTitle:strTitle forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    btn.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.customNavigationItem.rightBarButtonItem = item;
    
}

-(void)initRightImage:(NSString *)strImage
       highLightImage:(NSString *)highLightImage
                title:(NSString *)strTitle
                color:(UIColor *)color
{
    CGRect rect = CGRectMake(0, -2*SCREEN_WIDTH/320, 60, 44);
    
    UIButton *btn = [[UIButton alloc] initWithFrame:rect];
    
    [btn addTarget:self action:@selector(rightButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highLightImage] forState:UIControlStateHighlighted];
    [btn setTitle:strTitle forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    btn.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.customNavigationItem.rightBarButtonItem = item;
}

- (void)initRightImage:(NSString *)strImage
                 title:(NSString *)strTitle
                 color:(UIColor *)color
              selector:(SEL)selector
{
    CGRect rect = CGRectMake(0, -2*SCREEN_WIDTH/320, 60, 44);
    
    UIButton *btn = [[UIButton alloc] initWithFrame:rect];
    
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateHighlighted];
    [btn setTitle:strTitle forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    btn.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.customNavigationItem.rightBarButtonItem = item;
}

-(void)initRightImage:(NSString *)strImage
       highLightImage:(NSString *)highLightImage
                title:(NSString *)strTitle
                color:(UIColor *)color
             selector:(SEL)selector
{
    CGRect rect = CGRectMake(0, -2*SCREEN_WIDTH/320, 60, 44);
    
    UIButton *btn = [[UIButton alloc] initWithFrame:rect];
    
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highLightImage] forState:UIControlStateHighlighted];
    [btn setTitle:strTitle forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    btn.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.customNavigationItem.rightBarButtonItem = item;
}


- (void)resetLeftTitle:(NSString*)str
{
    self.customNavigationItem.leftBarButtonItem.title = str;
}

- (void)resetRightTitle:(NSString*)str
{
    self.customNavigationItem.rightBarButtonItem.title = str;
}

- (void)initBackButton
{
    UIViewController *rootVC=[self getRootViewController];
    
    if (![rootVC isKindOfClass:[UINavigationController class]])
    {
        return;
    }
    
    UINavigationController *rootNav= (UINavigationController *)rootVC;
    if (rootNav.viewControllers.count>=1 && self!=rootNav.viewControllers.firstObject)
    {
        [self initLeftTitle:NSLocalizedString(@"back", @"返回")];
    }
}

#pragma mark event

- (void)leftButtonEvent
{
    if ([self respondsToSelector:@selector(back)])
    {
        [self back];
    }
}

- (void)rightButtonEvent
{
    
}

#pragma mark button event

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

- (void)enableLeftButton
{
    if (self.customNavigationItem.leftBarButtonItem)
    {
        self.customNavigationItem.leftBarButtonItem.enabled = YES;
    }
}

- (void)enableRightButton
{
    if (self.customNavigationItem.rightBarButtonItem)
    {
        self.customNavigationItem.rightBarButtonItem.enabled = YES;
    }
}

- (void)disableLeftButton
{
    if (self.customNavigationItem.leftBarButtonItem)
    {
        self.customNavigationItem.leftBarButtonItem.enabled = NO;
    }
}

- (void)disableRightButton
{
    if (self.customNavigationItem.rightBarButtonItem)
    {
        self.customNavigationItem.rightBarButtonItem.enabled = NO;
    }
}

@end

