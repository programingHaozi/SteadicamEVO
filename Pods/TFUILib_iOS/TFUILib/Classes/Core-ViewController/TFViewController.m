//
//  TFViewController.m
//  Treasure
//
//  Created by xiayiyong on 15/9/7.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFViewController.h"
#import "TFNavigationController.h"
#import "LGProgressHud.h"
#import "UIView+TFLoading.h"
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
        self.viewModel = viewModel;
        self.block     = block;
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
        self.block=block;
        
        NSString *viewControllerClassName = NSStringFromClass([self class]);
        NSString *viewModelClassName      = [viewControllerClassName stringByReplacingOccurrencesOfString:@"ViewController" withString:@"ViewModel"];
        
        Class viewModel = NSClassFromString(viewModelClassName);
        if (viewModel)
        {
            self.viewModel = [viewModel mj_objectWithKeyValues:data];
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
    
    self.viewModel = viewModel;
    
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
        }
    }
    
    //statusbar改白色
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] == 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone ;
    }
    
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets           = NO;
    self.navigationController.navigationBar.translucent = NO;
    
    [self initViews];
    [self autolayoutViews];
    [self bindData];
    
}

#pragma mark- init autolayout bind

- (void)initViews
{
    NSString *className=NSStringFromClass([self class]);
    if (![className isEqualToString:NSStringFromClass([TFViewController class])])
    {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:[NSString stringWithFormat:@"You must override %@ in %@", NSStringFromSelector(_cmd), self.class]
                                     userInfo:nil];
    }
}

- (void)autolayoutViews
{
    NSString *className=NSStringFromClass([self class]);
    if (![className isEqualToString:NSStringFromClass([TFViewController class])])
    {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:[NSString stringWithFormat:@"You must override %@ in %@", NSStringFromSelector(_cmd), self.class]
                                     userInfo:nil];
    }
}

- (void)bindData
{
    NSString *className=NSStringFromClass([self class]);
    if (![className isEqualToString:NSStringFromClass([TFViewController class])])
    {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:[NSString stringWithFormat:@"You must override %@ in %@", NSStringFromSelector(_cmd), self.class]
                                     userInfo:nil];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark- 控制状态栏的样式
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark- push pop
- (void)pushViewController:(UIViewController *)vc
{
    [TFUIUtil pushViewController:vc from:self];
}

- (void)popViewController
{
    [self back];
}

- (void)presentViewController
{
    [TFUIUtil presentViewController:self];
}

- (void)dismissViewController
{
    [TFUIUtil dismissViewController:self];
}

- (void)popModuleViewController
{
    [TFUIUtil popModuleViewController];
}

- (void)back
{
    if (self.presentingViewController != nil)
    {
        if (self.navigationController == nil)
        {
            [self dismissViewControllerAnimated:YES completion:nil];
            
            return;
        }
        
        NSArray *arr = self.navigationController.viewControllers;
        if ([arr count] > 0)
        {
            if (self==self.navigationController.viewControllers[0])
            {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    else
    {
        if (self.navigationController == nil)
        {
            return;
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark button event

- (void)hideBack
{
    self.navigationItem.hidesBackButton = YES;
    
    // 禁用左滑手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)hideLeft
{
    self.navigationItem.leftBarButtonItem = nil;
    [self hideBack];
}

- (void)hideRight
{
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)enableLeft
{
    if (self.navigationItem.leftBarButtonItem)
    {
        self.navigationItem.leftBarButtonItem.enabled = YES;
    }
}

- (void)enableRight
{
    if (self.navigationItem.rightBarButtonItem)
    {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

- (void)disableLeft
{
    if (self.navigationItem.leftBarButtonItem)
    {
        self.navigationItem.leftBarButtonItem.enabled = NO;
    }
}

- (void)disableRight
{
    if (self.navigationItem.rightBarButtonItem)
    {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

#pragma mark init button

- (void)initMiddleView:(UIView*)view
{
    self.navigationItem.titleView = view;
}

- (void)initLeftImage:(NSString *)strImage
{
    CGRect rect   = CGRectMake(0, -2*SCREEN_WIDTH/320, 60, 44);
    UIButton *btn = [[UIButton alloc] initWithFrame:rect];
    
    [btn addTarget:self action:@selector(leftEvent:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateHighlighted];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)initLeftImage:(NSString *)strImage selector:(SEL)selector
{
    CGRect rect   = CGRectMake(0, -2*SCREEN_WIDTH/320, 60, 44);
    UIButton *btn = [[UIButton alloc] initWithFrame:rect];
    
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateHighlighted];
    btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    btn.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)initLeftTitle:(NSString *)strTitle
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
    
    [btn setTitle:strTitle forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [btn sizeToFit];
    [btn addTarget:self action:@selector(leftEvent:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
    
}

- (void)initLeftTitle:(NSString *)strTitle selector:(SEL)selector
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
    
    [btn setTitle:strTitle forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [btn sizeToFit];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)initLeftTitle:(NSString *)strTitle color:(UIColor *)color
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
    
    [btn setTitle:strTitle forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [btn sizeToFit];
    [btn addTarget:self action:@selector(leftEvent:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
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
    self.navigationItem.leftBarButtonItem = item;
}

- (void)initLeftImage:(NSString *)strImage
               title:(NSString *)strTitle
               color:(UIColor *)color
{
    CGRect rect = CGRectMake(0, -2*SCREEN_WIDTH/320, 60, 44);
    
    UIButton *btn = [[UIButton alloc] initWithFrame:rect];
    
    [btn addTarget:self action:@selector(leftEvent:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateHighlighted];
    [btn setTitle:strTitle forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
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
    self.navigationItem.leftBarButtonItem = item;
}

- (void)initRightImage:(NSString *)strImage
{
    CGRect rect = CGRectMake(0, -2*SCREEN_WIDTH/320, 60, 44);
    
    UIButton *btn = [[UIButton alloc] initWithFrame:rect];
    
    [btn addTarget:self action:@selector(rightEvent:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateHighlighted];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    btn.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)initRightImage:(NSString *)strImage selector:(SEL)selector
{
    CGRect rect = CGRectMake(0, -2*SCREEN_WIDTH/320, 60, 44);
    
    UIButton *btn = [[UIButton alloc] initWithFrame:rect];
    
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateHighlighted];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    btn.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)initRightTitle:(NSString *)strTitle
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
    
    [btn setTitle:strTitle forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [btn sizeToFit];
    [btn addTarget:self action:@selector(rightEvent:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)initRightTitle:(NSString *)strTitle selector:(SEL)selector
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
    
    [btn setTitle:strTitle forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [btn sizeToFit];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)initRightTitle:(NSString *)strTitle color:(UIColor *)color;
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
    
    [btn setTitle:strTitle forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [btn sizeToFit];
    [btn addTarget:self action:@selector(rightEvent:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
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
    self.navigationItem.rightBarButtonItem = item;
}

- (void)initRightImage:(NSString *)strImage
                title:(NSString *)strTitle
                color:(UIColor *)color
{
    CGRect rect = CGRectMake(0, -2*SCREEN_WIDTH/320, 60, 44);
    
    UIButton *btn = [[UIButton alloc] initWithFrame:rect];
    
    [btn addTarget:self action:@selector(rightEvent:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateHighlighted];
    [btn setTitle:strTitle forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    btn.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;

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
    self.navigationItem.rightBarButtonItem = item;
}

- (void)resetLeftTitle:(NSString*)str
{
    self.navigationItem.leftBarButtonItem.title = str;
}

- (void)resetRightTitle:(NSString*)str
{
    self.navigationItem.rightBarButtonItem.title = str;
}

- (void)initBackButton
{
    if (self.navigationController.viewControllers.count >1)
    {
        [self initLeftImage:@"icon_common_backArrow"];
    }
    else
    {
        //UIViewController *t1=self.navigationController;
        //UIViewController *t2=[TFUIUtil getRootViewController];
        if (self.navigationController!=[TFUIUtil getRootViewController])
        {
            [self initLeftImage:@"icon_common_backArrow"];
        }
    }
}

#pragma mark event

- (void)leftEvent:(UIButton*)button
{
    [self back];
}

- (void)rightEvent:(UIButton*)button
{
    
}

#pragma mark- showNavigationBar

- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    
}

- (void)showNavigationBar
{
    
}

- (void)hideNavigationBar
{
    
}

#pragma mark HUD

- (void)showLoadingHud
{
    [self showLoadingHudWithText:@""];
}

- (void)showLoadingHudWithText:(NSString*)text
{
    if (text == nil || [text length] == 0)
    {
        text = @"正在请求中...";
    }
    
    [LGProgressHud showLoadingHud:[UIApplication sharedApplication].keyWindow
                         withText:text
                     textPosition:TextPositionTypeRight
                         animated:HudAnimatedTypeNone];
}

- (void)hideLoadingHud
{
    [LGProgressHud hideAllHudInView:[UIApplication sharedApplication].keyWindow
                           animated:HudAnimatedTypeNone];
}

#pragma mark loading

- (void)showLoading
{
    [self.view showLoadingWithText:@"加载中..." ];
}

- (void)showLoadingWithText:(NSString*)text
{
    [self.view showLoadingWithText:text];
}

- (void)hideLoading
{
    [self.view hideLoading];
}

#pragma mark toast

- (void)showToast:(NSString*)text
{
    [self showToast:text duration:2.0 position:TFToastPositionTop];
}

- (void)showToast:(NSString*)text duration:(NSTimeInterval)duration position:(id)position
{
    [[UIApplication sharedApplication].keyWindow makeToast:text
                                                  duration:duration
                                                  position:position];
}

#pragma mark load data

- (void)startLoadData
{
    
}

- (void)endLoadData
{
    [self hideLoadingHud];
}

- (void)showCustomNaviBar:(UIView*)customNaviBar;
{
    self.customNaviBarView = customNaviBar;
    
    UIView *view = [self findView:self.navigationController.navigationBar withName:@"_UINavigationBarBackground"];
    
    [view addSubview:self.customNaviBarView];
    self.customNaviBarView.alpha = 0;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.customNaviBarView.alpha = 1;
    }];
}

- (void)hideCustomNaviBar
{
    [UIView animateWithDuration:0.25 animations:^{
        
        self.customNaviBarView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self.customNaviBarView removeFromSuperview];
    }];
}

- (UIView *)findView:(UIView *)aView withName:(NSString *)name
{
    Class cl = [aView class];
    NSString *desc = [cl description];
    
    if ([name isEqualToString:desc])
    {
        return aView;
    }
    
    for (NSUInteger i = 0; i < [aView.subviews count]; i++)
    {
        UIView *subView = [aView.subviews objectAtIndex:i];
        subView = [self findView:subView withName:name];
        if (subView)
        {
            return subView;
        }
    }
    
    return nil;
}

#pragma mark- handle

-(void) handleData:(id)data
{
    if ([data isKindOfClass:[UITableViewCell class]])
    {

    }
    else if ([data isKindOfClass:[TFActionModel class]])
    {
        
    }
    else if ([data isKindOfClass:[TFWebModel class]])
    {
        
    }
    else if ([data isKindOfClass:[TFTableRowModel class]])
    {
        TFTableRowModel *item=(TFTableRowModel *)data;
        
        Class viewModelClass = NSClassFromString(item.vc);
        if (viewModelClass!=nil)
        {
            [self pushViewController:[[viewModelClass alloc]init]];
            return;
        }
        
        SEL selector = NSSelectorFromString(item.method);
        if ([self respondsToSelector:selector])
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self performSelector:selector withObject:nil];
#pragma clang diagnostic pop
            return;
        }
        
    }
    else if ([data isKindOfClass:[TFModel class]])
    {
        
    }
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

@end

