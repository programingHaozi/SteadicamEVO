//
//  TFMacro+View.h
//  Treasure
//
//  Created by xiayiyong on 15/9/14.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#define FRAME(x,y,width,height)  CGRectMake(x, y, width, height)

/**
 *  屏幕宽
 *
 *  @param mainScreen].bounds.size.width
 *
 *  @return 屏幕宽
 */
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

/**
 *  屏幕高度
 *
 *  @param mainScreen].bounds.size.height
 *
 *  @return 屏幕高度
 */
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

/**
 *  导航栏高度
 *
 */
#define NAV_BAR_HEIGHT        44

/**
 *  工具栏高度
 */
#define TAB_BAR_HEIGHT        49

/**
 *  状态栏高度
 */
#define STATUS_BAR_HEIGHT     20.0

/**
 *  导航栏高度
 */
#define NAV_BAR_HEIGHT2        (self.navigationController.navigationBar.bounds.size.height)

/**
 *  状态栏高度
 */
#define TAB_BAR_HEIGHT2        (self.tabBarController.tabBar.bounds.size.height)

