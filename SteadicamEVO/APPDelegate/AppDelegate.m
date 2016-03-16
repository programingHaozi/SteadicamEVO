//
//  AppDelegate.m
//  SteadicamEVO
//
//  Created by 耗子 on 16/3/6.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import "AppDelegate.h"
#import "SplashViewController.h"
#import "HomeTabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self showADView];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

/**
 *  判断是否是新版本
 *
 *  @return 是否最新版本
 */
- (BOOL)checkIsNewVersion
{
    if (kSCEUserDefaults.lastAPPVersion !=nil && [kSCEUserDefaults.lastAPPVersion isEqualToString:tf_getAPPVersion()])
    {
        return NO;
    }
    
    kSCEUserDefaults.lastAPPVersion = tf_getAPPVersion();
    
    return YES;
}

/*
 显示广告页面
 */
- (void)showADView
{
    WS(weakSelf);
    
    if ([weakSelf checkIsNewVersion])
    {
        [weakSelf showSplashView];
    }
    else
    {
//        AdViewController *vc = [[AdViewController alloc] initWithBlock:^(id data) {
//            [self goToRootViewController];
//        }];
//        [self.window setRootViewController:[[UINavigationController alloc] initWithRootViewController:vc]];
        [self goToRootViewController];
    }
}

/*
 显示启动页面
 */
- (void)showSplashView
{
    SplashViewController *vc = [[SplashViewController alloc] initWithResultBlock:^(id data) {
        
        [self goToRootViewController];
    }];
    
    [self.window setRootViewController:vc];
}

- (void)goToRootViewController
{
    HomeTabBarController *vc =[[HomeTabBarController alloc]init];
    
    [self.window setRootViewController:vc];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
