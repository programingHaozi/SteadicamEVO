//
//  TFCustomTabBar.m
//  TFUILib
//
//  Created by Chen Hao 陈浩 on 16/3/9.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFCustomTabBar.h"
#import <TFBaseLib.h>

@interface TFCustomTabBar()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UIImageView *separateLine;

@property (nonatomic, strong) UIToolbar   *blurView;

@end

@implementation TFCustomTabBar

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
    
    self.clipsToBounds = NO;
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
    
    [self.tabBarItems enumerateObjectsUsingBlock:^(TFCustomTabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        float leftOffset = idx * weakSelf.width/weakSelf.tabBarItems.count;
        
        [obj mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(weakSelf.mas_width).dividedBy(weakSelf.tabBarItems.count);
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

- (void)setTabBarItems:(NSArray<TFCustomTabBarItem *> *)tabBarItems
{
    [_tabBarItems enumerateObjectsUsingBlock:^(TFCustomTabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [obj removeFromSuperview];
    }];
    
    if (tabBarItems.count > 5)
    {
        tabBarItems = [tabBarItems subarrayWithRange:NSMakeRange(0, 5)];
    }
    
    _tabBarItems = [NSArray arrayWithArray:tabBarItems];
    
    if (tabBarItems.count > 0)
    {
        
        WS(weakSelf)
        __block void(^touchActionBlcok)(TFCustomTabBarItem *) = ^(TFCustomTabBarItem *barItem) {
            
            if ([self.delegate respondsToSelector:@selector(willSelectItem:tabBar:)])
            {
                BOOL allowSelect = [self.delegate willSelectItem:[weakSelf.tabBarItems indexOfObject:barItem] tabBar:self];
                
                if (!allowSelect)
                {
                    return ;
                }
            }
            
            barItem.selected = YES;
            
            if (weakSelf.selectBarItemBlock)
            {
                weakSelf.selectBarItemBlock([tabBarItems indexOfObject:barItem]);
            }
            
            if ([self.delegate respondsToSelector:@selector(didSelectViewItem:tabBar:)])
            {
                [self.delegate didSelectViewItem:[weakSelf.tabBarItems indexOfObject:barItem] tabBar:self];
            }
        };
        
        [tabBarItems enumerateObjectsUsingBlock:^(TFCustomTabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [self addSubview:obj];
            
            obj.touchActionBlock = touchActionBlcok;
        }];
        
        self.tabBarItems[0].touchActionBlock(self.tabBarItems[0]);
        
    }
}

-(void)setSelectedIndex:(NSUInteger)selectedIndex
{
    if (_selectedIndex == selectedIndex || selectedIndex >= self.tabBarItems.count)
    {
        return;
    }
    
    _selectedIndex = selectedIndex;
    
    [self.tabBarItems enumerateObjectsUsingBlock:^(TFCustomTabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
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
    
    [self.tabBarItems enumerateObjectsUsingBlock:^(TFCustomTabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.title = tabBarTitles[idx];
    }];
}

-(void)setTabBarNormalImages:(NSArray *)tabBarNormalImages
{
    _tabBarNormalImages = tabBarNormalImages;
    
    [self.tabBarItems enumerateObjectsUsingBlock:^(TFCustomTabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.normalImage = tabBarNormalImages[idx];
    }];
}

-(void)setTabBarSelectedImages:(NSArray *)tabBarSelectedImages
{
    _tabBarSelectedImages = tabBarSelectedImages;
    
    [self.tabBarItems enumerateObjectsUsingBlock:^(TFCustomTabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selectImage = tabBarSelectedImages[idx];
    }];
}

-(void)setTabBarTitleColor:(UIColor *)tabBarTitleColor
{
    _tabBarTitleColor = tabBarTitleColor;
    
    [self.tabBarItems enumerateObjectsUsingBlock:^(TFCustomTabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.titleNormalColor = tabBarTitleColor;
    }];
    
}

-(void)setSelectedTabBarTitleColor:(UIColor *)selectedTabBarTitleColor
{
    _selectedTabBarTitleColor = selectedTabBarTitleColor;
    
    [self.tabBarItems enumerateObjectsUsingBlock:^(TFCustomTabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.titleSelectColor = selectedTabBarTitleColor;
    }];
    
}

-(void)setTabBarItemBGColor:(UIColor *)tabBarItemBGColor
{
    _tabBarItemBGColor = tabBarItemBGColor;
    
    [self.tabBarItems enumerateObjectsUsingBlock:^(TFCustomTabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.normalBackgroundColor = tabBarItemBGColor;
    }];
    
}

-(void)setSelectedTabBarItemBGColor:(UIColor *)selectedTabBarItemBGColor
{
    _selectedTabBarItemBGColor = selectedTabBarItemBGColor;
    
    [self.tabBarItems enumerateObjectsUsingBlock:^(TFCustomTabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selectBackgroundColor = selectedTabBarItemBGColor;
    }];
}

-(void)setBadgeBackgroundColor:(UIColor *)badgeBackgroundColor
{
    _badgeBackgroundColor = badgeBackgroundColor;
    
    [self.tabBarItems enumerateObjectsUsingBlock:^(TFCustomTabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.badgeBackgroundColor = badgeBackgroundColor;
    }];
}

-(void)setBadgeStringColor:(UIColor *)badgeStringColor
{
    _badgeStringColor = badgeStringColor;
    
    [self.tabBarItems enumerateObjectsUsingBlock:^(TFCustomTabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.badgeStringColor = badgeStringColor;
    }];
}

-(void)setTranslucent:(BOOL)translucent
{
    _translucent = translucent;
    
    self.blurView.hidden = !translucent;
    
    self.backgroundColor = translucent ? [UIColor clearColor] : [UIColor whiteColor];
}

#pragma mark - public Method -

-(void)setBadge:(NSString *)badge atIndex:(NSUInteger)index
{
    self.tabBarItems[index].badgeValue = badge;
}

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    if (animated)
    {
        [self pop_removeAllAnimations];
        
        if (hidden)
        {
            self.center = CGPointMake(self.center.x, self.superview.height - self.height/2);
            
            POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
            animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.centerX, self.centerY + 2 * self.height)];
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            animation.duration = 0.5;
            
            [self pop_addAnimation:animation forKey:@"hideTabBarAnimation"];
        }
        else
        {
            self.center = CGPointMake(self.center.x, self.superview.height + 1.5 * self.height);
            
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
