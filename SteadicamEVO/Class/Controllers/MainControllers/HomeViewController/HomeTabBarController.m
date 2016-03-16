//
//  HomeTabBarController.m
//  SteadicamEVO
//
//  Created by Chen Hao 陈浩 on 16/3/16.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import "HomeTabBarController.h"

@implementation HomeTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    TFViewController *vc1 = [[TFViewController alloc]init];
    vc1.view.backgroundColor = [UIColor orangeColor];
    vc1.tabbarItem = [[TFCustomTabbarItem alloc]initWithTitle:@"第一" normalImage:IMAGE(@"56.png") selectedImage:IMAGE(@"57.png")];
    
    TFViewController *vc2 = [[TFViewController alloc]init];
    vc2.view.backgroundColor = [UIColor blueColor];
    vc2.tabbarItem = [[TFCustomTabbarItem alloc]initWithTitle:@"第二" normalImage:IMAGE(@"56.png") selectedImage:IMAGE(@"57.png")];
    
    TFViewController *vc3 = [[TFViewController alloc]init];
    vc3.view.backgroundColor = [UIColor yellowColor];
    vc3.tabbarItem = [[TFCustomTabbarItem alloc]initWithTitle:@"第三disan " normalImage:IMAGE(@"56.png") selectedImage:IMAGE(@"57.png")];
    
   
    
    self.viewControllers = @[vc1,vc2,vc3];
    self.tabBarTranslucent = YES;
    
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


#pragma mark test

-(void)didSelectViewItem:(NSUInteger)index tabBar:(TFCustomTabbar *)tabBar
{
    NSLog(@"点击了第 %lu 个", (unsigned long)index);
}


-(BOOL)willSelectItem:(NSUInteger)index tabBar:(TFCustomTabbar *)tabBar
{
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
