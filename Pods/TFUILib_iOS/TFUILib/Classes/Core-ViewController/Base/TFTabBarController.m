//
//  TFTabBarController.m
//  Treasure
//
//  Created by xiayiyong on 15/7/2.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFTabBarController.h"
#import "TFNavigationController.h"
#import <TFBaseLib.h>

#define SELECTED_VIEW_CONTROLLER_TAG 93746282

@interface TFTabBarController ()

@property (nonatomic, strong) TFCustomTabBar *tabBar;

@end

@implementation TFTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTabBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - TabBar -

- (void)initTabBar
{
    self.tabBar = [[TFCustomTabBar alloc]init];
    self.tabBar.delegate = self;
    [self.view addSubview:self.tabBar];
    
    WS(weakSelf)
    [self.tabBar mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@49);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.left.equalTo(@0);
    }];
    
    self.tabBar.selectBarItemBlock = ^(NSUInteger idx){
        weakSelf.selectedIndex = idx;
    };
}


#pragma mark - Setter Getters -

- (void)setTabBarTranslucent:(BOOL)tabBarTranslucent
{
    _tabBarTranslucent = tabBarTranslucent;
    
    self.tabBar.translucent = tabBarTranslucent;
    
    [self setViewControllers:self.viewControllers];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    
    self.tabBar.selectedIndex = selectedIndex;
    
    if (selectedIndex < self.viewControllers.count)
    {
        UIViewController *viewController = [self.viewControllers objectAtIndex:selectedIndex];
        
        if (viewController)
        {
            UIView* currentView = [self.view viewWithTag:SELECTED_VIEW_CONTROLLER_TAG];
            [currentView removeFromSuperview];
            
            viewController.view.tag = SELECTED_VIEW_CONTROLLER_TAG;
            
            [self.view insertSubview:viewController.view belowSubview:self.tabBar];
            
            WS(weakSelf)
            [viewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.   equalTo(weakSelf.view.mas_top).offset(0);
                make.right. equalTo(weakSelf.view.mas_right).offset(0);
                make.bottom.equalTo(weakSelf.tabBarTranslucent ? weakSelf.view.mas_bottom : weakSelf.tabBar.mas_top).offset(0);
                make.left.  equalTo(weakSelf.view.mas_left).offset(0);
            }];
        }
    }
}

- (NSUInteger)selectedIndex
{
    return self.tabBar.selectedIndex;
}

-(void)setViewControllers:(NSArray *)viewControllers
{
    _viewControllers = viewControllers;
    
    __block NSMutableArray<TFCustomTabBarItem *> *barItemsArray = [[NSMutableArray alloc]init];;
    
    WS(weakSelf)
    [viewControllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [weakSelf addChildViewController:obj];
        
        if ([obj isKindOfClass:[UINavigationController class]])
        {
            UINavigationController *nav = obj;
            if ([nav.viewControllers.firstObject isKindOfClass:[UIViewController class]])
            {
                UIViewController *vc = (UIViewController *)nav.viewControllers.firstObject;
                if (!vc.tfTabBarItem)
                {
                    vc.tfTabBarItem = [[TFCustomTabBarItem alloc]initWithTitle:nil
                                                                   normalImage:nil
                                                                 selectedImage:nil];
                }
                
                [barItemsArray addObject:vc.tfTabBarItem];
            }
        }
        else if ([obj isKindOfClass:[UIViewController class]])
        {
            UIViewController *vc = (UIViewController *)obj;
            if (!vc.tfTabBarItem)
            {
                vc.tfTabBarItem = [[TFCustomTabBarItem alloc]initWithTitle:nil
                                                               normalImage:nil
                                                             selectedImage:nil];
            }
            
            [barItemsArray addObject:vc.tfTabBarItem];
        }
    }];
    
    self.tabBar.tabBarItems = [NSArray arrayWithArray:barItemsArray];
}

- (void)setTabBarTitles:(NSArray *)tabBarTitles
{
    _tabBarTitles            = tabBarTitles;
    
    self.tabBar.tabBarTitles = tabBarTitles;
}

- (void)setTabBarNormalImages:(NSArray *)tabBarNormalImages
{
    _tabBarNormalImages            = tabBarNormalImages;
    
    self.tabBar.tabBarNormalImages = tabBarNormalImages;
}

- (void)setTabBarSelectedImages:(NSArray *)tabBarSelectedImages
{
    _tabBarSelectedImages            = tabBarSelectedImages;
    
    self.tabBar.tabBarSelectedImages = tabBarSelectedImages;
}

- (void)setTabBarTitleColor:(UIColor *)tabBarTitleColor
{
    _tabBarTitleColor            = tabBarTitleColor;
    
    self.tabBar.tabBarTitleColor = tabBarTitleColor;
}

- (void)setSelectedTabBarTitleColor:(UIColor *)selectedTabBarTitleColor
{
    _selectedTabBarTitleColor            = selectedTabBarTitleColor;
    
    self.tabBar.selectedTabBarTitleColor = selectedTabBarTitleColor;
}

- (void)setTabBarItemBGColor:(UIColor *)tabBarItemBGColor
{
    _tabBarItemBGColor            = tabBarItemBGColor;
    
    self.tabBar.tabBarItemBGColor = tabBarItemBGColor;
}

- (void)setSelectedTabBarItemBGColor:(UIColor *)selectedTabBarItemBGColor
{
    _selectedTabBarItemBGColor            = selectedTabBarItemBGColor;
    
    self.tabBar.selectedTabBarItemBGColor = selectedTabBarItemBGColor;
}

- (TFViewController *)selectedViewController
{
    if (self.viewControllers)
    {
        return self.viewControllers[self.selectedIndex];
    }
    
    return nil;
}

-(void)setBadgeBackgroundColor:(UIColor *)badgeBackgroundColor
{
    _badgeBackgroundColor = badgeBackgroundColor;
    
    self.tabBar.badgeBackgroundColor = badgeBackgroundColor;
}

-(void)setBadgeStringColor:(UIColor *)badgeStringColor
{
    _badgeStringColor = badgeStringColor;
    
    self.tabBar.badgeStringColor = badgeStringColor;
}

-(void)setTabBarBackgroundImage:(UIImage *)tabBarBackgroundImage
{
    _tabBarBackgroundImage = tabBarBackgroundImage;
    
    self.tabBar.backgroundImage = tabBarBackgroundImage;
}


#pragma mark - Public Method -

- (void)removeViewControllerAtIndex:(NSUInteger)index
{
    NSMutableArray *tempAry = [[NSMutableArray alloc]initWithArray:self.viewControllers];
    [tempAry removeObjectAtIndex:index];
    
    self.viewControllers = [NSArray arrayWithArray:tempAry];
}

- (void)insertViewController:(UIViewController *)vc
                       title:(NSString *)title
                 normalImage:(UIImage *)normalImage
               selectedImage:(UIImage *)selectedImage
                     atIndex:(NSUInteger)index
{
    
    vc.tfTabBarItem = [[TFCustomTabBarItem alloc]initWithTitle:title
                                                   normalImage:normalImage
                                                 selectedImage:selectedImage];
    
    NSMutableArray *tempAry = [[NSMutableArray alloc]initWithArray:self.viewControllers];
    
    if (index > self.viewControllers.count)
    {
        index = self.viewControllers.count;
    }
    [tempAry insertObject:vc atIndex:index];
    
    self.viewControllers = tempAry;
}

- (void)setBadge:(NSString *)badge atIndex:(NSUInteger)index
{
    [self.tabBar setBadge:badge atIndex:index];
}

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    [self.tabBar setTabBarHidden:hidden animated:animated];
}

@end

#pragma mark - TFViewController (TFTabBarControllerItem) -

/**
 *  注意使用OBJC_ASSOCIATION_RETAIN_NONATOMIC 和 OBJC_ASSOCIATION_COPY_NONATOMIC是不同的
 *  用COPY时会崩溃
 */

@implementation UIViewController (TFTabBarControllerItem)
@dynamic tfTabBarItem;
@dynamic tfTabBarController;

const void *TF_TAbBar_ITEM_KEY = @"TFTabBarItemKey";

const void *TF_TAbBar_CONTROLLER_KEY = @"TFTabBarControllerKey";

-(void)setTfTabBarItem:(TFCustomTabBarItem *)tfTabBarItem
{
    objc_setAssociatedObject(self, TF_TAbBar_ITEM_KEY, tfTabBarItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(TFCustomTabBarItem *)tfTabBarItem
{
    return objc_getAssociatedObject(self, TF_TAbBar_ITEM_KEY);
}

-(TFTabBarController *)tfTabBarController
{
    if ([self.parentViewController isKindOfClass:[TFTabBarController class]])
    {
        return (TFTabBarController *)self.parentViewController;
    }
    else if ([self.parentViewController.parentViewController isKindOfClass:[TFTabBarController class]])
    {
        return (TFTabBarController *)self.parentViewController.parentViewController;
    }
    
    return nil;
}

@end
