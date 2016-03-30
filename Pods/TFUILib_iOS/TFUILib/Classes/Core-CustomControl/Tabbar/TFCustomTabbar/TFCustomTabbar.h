//
//  TFCustomTabBar.h
//  TFUILib
//
//  Created by Chen Hao 陈浩 on 16/3/9.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFView.h"
#import "TFCustomTabBarItem.h"
#import "TFCustomTabBar.h"

/**
 *  选择barItem回调
 *
 *  @param idx barItem Index
 */
typedef void(^SelectBarItemBlock)(NSUInteger idx);

/**
 *  TFCustomTabBarSelectDelegate
 */
@protocol TFCustomTabBarSelectDelegate;

/**
 *  TFCustomTabBar
 */
@interface TFCustomTabBar : TFView

/**
 *  代理
 */
@property (nullable, nonatomic, weak) id<TFCustomTabBarSelectDelegate> delegate;

/**
 *  背景图片(设置image为空时，恢复默认半透明效果；image不为空时，没有半透明效果)
 */
@property (nullable, nonatomic, strong) UIImage *backgroundImage;

/**
 *  BarItems数组
 */
@property (nullable, nonatomic, strong) NSArray<TFCustomTabBarItem *> *tabBarItems;

/**
 *  TabBar标题数组
 */
@property (nullable, nonatomic, strong) NSArray *tabBarTitles;

/**
 *  TabBar选择状态图片数组
 */
@property (nullable, nonatomic, strong) NSArray *tabBarSelectedImages;

/**
 *  TabBar正常状态图片数组
 */
@property (nullable, nonatomic, strong) NSArray *tabBarNormalImages;

/**
 *  TabBar正常状态标题颜色(统一设置，如需分别设置，请使用VC.tabBarItem.titleNormalColor)
 */
@property (nullable, nonatomic, strong) UIColor *tabBarTitleColor;

/**
 *  TabBar选择状态标题颜色(统一设置，如需分别设置，请使用VC.tabBarItem.titleSelectColor)
 */
@property (nullable, nonatomic, strong) UIColor *selectedTabBarTitleColor;

/**
 *  TabBarItem正常状态背景色(统一设置，如需分别设置，请使用VC.tabBarItem.backgroundColor)
 */
@property (nullable, nonatomic, strong) UIColor *tabBarItemBGColor;

/**
 *  TabBarItem选择状态背景色(统一设置，如需分别设置，请使用VC.tabBarItem.selectBackgroundColor)
 */
@property (nullable, nonatomic, strong) UIColor *selectedTabBarItemBGColor;

/**
 *  Badge背景色(统一设置，如需分别设置，请使用VC.tabBarItem.badgeBackgroundColor)
 */
@property (nullable, nonatomic, strong) UIColor *badgeBackgroundColor;

/**
 *  Badge字体色(统一设置，如需分别设置，请使用VC.tabBarItem.badgeStringColor)
 */
@property (nullable, nonatomic, strong) UIColor *badgeStringColor;

/**
 *  tabBar是否模糊
 */
@property (nonatomic, assign) BOOL translucent;

/**
 *  选中的barItem的index
 */
@property (nonatomic, assign) NSUInteger selectedIndex;

/**
 *  选择barItem回调
 */
@property (nullable, nonatomic, strong) SelectBarItemBlock selectBarItemBlock;

/**
 *  设置badge值
 *
 *  @param badge badge值
 *  @param index Index
 */
- (void)setBadge:(NSString * _Nullable)badge atIndex:(NSUInteger)index;

/**
 *  设置TabBar隐藏/显示
 *
 *  @param hidden   是否隐藏
 *  @param animated 是否有动画
 */
- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated;

@end

/**
 *  TFTabBarSelectDelegate
 */
@protocol TFCustomTabBarSelectDelegate <NSObject>

@optional

/**
 *  即将选择子控制器（点击TabBar）
 *
 *  @param index  点击Item的Index
 *  @param tabBar tabBar实例
 *
 *  @return 改Item是否可点击
 */
- (BOOL)willSelectItem:(NSUInteger)index tabBar:(TFCustomTabBar * _Nonnull)tabBar;

/**
 *  已经选择子控制器（点击TabBar）
 *
 *  @param index  点击Item的Index
 *  @param tabBar tabBar实例
 */
- (void)didSelectViewItem:(NSUInteger)index tabBar:(TFCustomTabBar * _Nonnull)tabBar;

@end
