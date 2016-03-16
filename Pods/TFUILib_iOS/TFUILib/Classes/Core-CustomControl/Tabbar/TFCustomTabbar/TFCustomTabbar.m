//
//  TFCustomTabbar.m
//  TFUILib
//
//  Created by Chen Hao 陈浩 on 16/3/9.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFCustomTabbar.h"
#import <TFBaseLib.h>

@interface TFCustomTabbar()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UIImageView *separateLine;

@property (nonatomic, strong) UIToolbar   *blurView;

@end

@implementation TFCustomTabbar

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self initSubviews];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initSubviews];
    }
    
    return self;
}

- (void)initSubviews
{
    self.backgroundColor = [UIColor clearColor];
    
    _blurView = [[UIToolbar alloc]init];
    [self addSubview:_blurView];
    
    _backgroundImageView = [[UIImageView alloc]init];
    _backgroundImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:_backgroundImageView];
    
    _separateLine = [[UIImageView alloc]init];
    _separateLine.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    _separateLine.tintColor = [UIColor colorWithRed:0 green:0.48 blue:1 alpha:1];
    [self addSubview:_separateLine];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    WS(weakSelf)
    [self.blurView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.mas_top).offset(0);
        make.right.equalTo(weakSelf.mas_right).offset(0);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(0);
        make.left.equalTo(weakSelf.mas_left).offset(0);
    }];
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.mas_top).offset(0);
        make.right.equalTo(weakSelf.mas_right).offset(0);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(0);
        make.left.equalTo(weakSelf.mas_left).offset(0);
    }];
    
    [self.separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@0.5);
        make.top.equalTo(weakSelf.mas_top).offset(-0.25);
        make.right.equalTo(weakSelf.mas_right).offset(0);
        make.left.equalTo(weakSelf.mas_left).offset(0);
    }];
    
    [self.tabbarItems enumerateObjectsUsingBlock:^(TFCustomTabbarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        float leftOffset = idx * weakSelf.width/weakSelf.tabbarItems.count;
        
        [obj mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(weakSelf.mas_width).dividedBy(weakSelf.tabbarItems.count);
            make.height.equalTo(@48);
            make.left.equalTo(weakSelf.mas_left).offset(leftOffset);
            make.bottom.equalTo(weakSelf.mas_bottom).offset(0);
        }];
    }];
}

#pragma mark - Setter -

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = backgroundImage;
    
    [self.backgroundImageView setImage:backgroundImage];
}

- (void)setTabbarItems:(NSArray<TFCustomTabbarItem *> *)tabbarItems
{
    [_tabbarItems enumerateObjectsUsingBlock:^(TFCustomTabbarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [obj removeFromSuperview];
    }];
    
    _tabbarItems = [NSArray arrayWithArray:tabbarItems];
    
    if (tabbarItems.count > 0)
    {
        
        WS(weakSelf)
        __block void(^touchActionBlcok)(TFCustomTabbarItem *) = ^(TFCustomTabbarItem *barItem) {
            
            if ([self.delegate respondsToSelector:@selector(willSelectItem:tabBar:)])
            {
                BOOL allowSelect = [self.delegate willSelectItem:[weakSelf.tabbarItems indexOfObject:barItem] tabBar:self];
                
                if (!allowSelect)
                {
                    return ;
                }
            }
            
            barItem.selected = YES;
            
            if (weakSelf.selectBarItemBlock)
            {
                weakSelf.selectBarItemBlock([tabbarItems indexOfObject:barItem]);
            }
            
            if ([self.delegate respondsToSelector:@selector(didSelectViewItem:tabBar:)])
            {
                [self.delegate didSelectViewItem:[weakSelf.tabbarItems indexOfObject:barItem] tabBar:self];
            }
        };
        
        if (tabbarItems.count > 5)
        {
            tabbarItems = [tabbarItems subarrayWithRange:NSMakeRange(0, 5)];
        }

        [tabbarItems enumerateObjectsUsingBlock:^(TFCustomTabbarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

            [self addSubview:obj];
            
            obj.touchActionBlock = touchActionBlcok;
        }];
        
        self.tabbarItems[0].touchActionBlock(self.tabbarItems[0]);
        
    }
}

-(void)setSelectedIndex:(NSUInteger)selectedIndex
{
    if (_selectedIndex == selectedIndex || selectedIndex >= self.tabbarItems.count)
    {
        return;
    }
    
    _selectedIndex = selectedIndex;
    
    [self.tabbarItems enumerateObjectsUsingBlock:^(TFCustomTabbarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx == selectedIndex)
        {
            obj.selected = YES;
            NSLog(@"select ： %lu",(unsigned long)idx);
        }
        else
        {
            obj.selected = NO;
        }
    }];
    
}

-(void)setTabBarTitles:(NSArray *)tabBarTitles
{
    _tabBarTitles = tabBarTitles;
    
    [self.tabbarItems enumerateObjectsUsingBlock:^(TFCustomTabbarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.title = tabBarTitles[idx];
    }];
}

-(void)setTabBarNormalImages:(NSArray *)tabBarNormalImages
{
    _tabBarNormalImages = tabBarNormalImages;
    
    [self.tabbarItems enumerateObjectsUsingBlock:^(TFCustomTabbarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.normalImage = tabBarNormalImages[idx];
    }];
}

-(void)setTabBarSelectedImages:(NSArray *)tabBarSelectedImages
{
    _tabBarSelectedImages = tabBarSelectedImages;
    
    [self.tabbarItems enumerateObjectsUsingBlock:^(TFCustomTabbarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selectImage = tabBarSelectedImages[idx];
    }];
}

-(void)setTabBarTitleColor:(UIColor *)tabBarTitleColor
{
    _tabBarTitleColor = tabBarTitleColor;
    
    [self.tabbarItems enumerateObjectsUsingBlock:^(TFCustomTabbarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.titleNormalColor = tabBarTitleColor;
    }];
    
}

-(void)setSelectedTabBarTitleColor:(UIColor *)selectedTabBarTitleColor
{
    _selectedTabBarTitleColor = selectedTabBarTitleColor;
    
    [self.tabbarItems enumerateObjectsUsingBlock:^(TFCustomTabbarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.titleSelectColor = selectedTabBarTitleColor;
    }];
    
}

-(void)setTabBarItemBGColor:(UIColor *)tabBarItemBGColor
{
    _tabBarItemBGColor = tabBarItemBGColor;
    
    [self.tabbarItems enumerateObjectsUsingBlock:^(TFCustomTabbarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.normalBackgroundColor = tabBarItemBGColor;
    }];
    
}

-(void)setSelectedTabBarItemBGColor:(UIColor *)selectedTabBarItemBGColor
{
    _selectedTabBarItemBGColor = selectedTabBarItemBGColor;
    
    [self.tabbarItems enumerateObjectsUsingBlock:^(TFCustomTabbarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selectBackgroundColor = selectedTabBarItemBGColor;
    }];
}

-(void)setBadgeBackgroundColor:(UIColor *)badgeBackgroundColor
{
    _badgeBackgroundColor = badgeBackgroundColor;
    
    [self.tabbarItems enumerateObjectsUsingBlock:^(TFCustomTabbarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.badgeBackgroundColor = badgeBackgroundColor;
    }];
}

-(void)setBadgeStringColor:(UIColor *)badgeStringColor
{
    _badgeStringColor = badgeStringColor;
    
    [self.tabbarItems enumerateObjectsUsingBlock:^(TFCustomTabbarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.badgeStringColor = badgeStringColor;
    }];
}

#pragma mark - public Method -

-(void)setBadge:(NSString *)badge atIndex:(NSUInteger)index
{
    self.tabbarItems[index].badgeValue = badge;
}

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    if (animated)
    {
        if (hidden)
        {
            POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
            animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.centerX, self.centerY + 2 * self.height)];
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            animation.duration = 0.5;
            
            [self pop_addAnimation:animation forKey:@"hideTabBarAnimation"];
        }
        else
        {
            POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
            animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.centerX, self.centerY - 2 * self.height)];
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            animation.duration = 0.5;
            
            [self pop_addAnimation:animation forKey:@"showTabBarAnimation"];
        }
    }
    else
    {
        if (hidden)
        {
            [self mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.height.equalTo(@49);
                make.right.equalTo(@0);
                make.bottom.equalTo(@(2 * self.height));
                make.left.equalTo(@0);
            }];
        }
        else
        {
            [self mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.height.equalTo(@49);
                make.right.equalTo(@0);
                make.bottom.equalTo(@0);
                make.left.equalTo(@0);
            }];
        }
    }
}

@end
