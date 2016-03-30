//
//  TFCustomTabBarItem.m
//  TFUILib
//
//  Created by Chen Hao 陈浩 on 16/3/9.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFCustomTabBarItem.h"

@interface TFCustomTabBarItem()

@property (nonatomic, strong) UILabel * badgeLabel;

@property (nonatomic, strong) UIButton * barButton;

@property (nonatomic, strong) UIImageView *barImageView;

@property (nonatomic, strong) UILabel *barTitleLabel;

@property (nonatomic, strong) UIImageView *backgoundImageView;


@end

@implementation TFCustomTabBarItem

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
    self = [self initWithTitle:nil
                   normalImage:nil
                 selectedImage:nil];
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                  normalImage:(UIImage *)normalImage
                selectedImage:(UIImage *)selectedImage
{
    if (self = [super initWithFrame:CGRectZero])
    {
        [self initSubviews];
        
        _title = title;
        _normalImage = normalImage;
        _selectImage = selectedImage;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    WS(weakSelf)
    [self.backgoundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.mas_top).offset(0);
        make.right.equalTo(weakSelf.mas_right).offset(0);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(0);
        make.left.equalTo(weakSelf.mas_left).offset(0);
    }];
    
    [self.barButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.mas_top).offset(0);
        make.right.equalTo(weakSelf.mas_right).offset(0);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(0);
        make.left.equalTo(weakSelf.mas_left).offset(0);
    }];
    
   
    
    [self.barImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@25);
        make.height.equalTo(@25);
        make.top.equalTo(weakSelf.mas_top).offset(5.5);
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
    }];
    
    [self.barTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@12);
        make.right.equalTo(weakSelf.mas_right).offset(0);
        make.top.equalTo(weakSelf.mas_top).offset(35);
        make.left.equalTo(weakSelf.mas_left).offset(0);
    }];
    
    [self.badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@20);
        make.height.equalTo(@20);
        make.top.equalTo(weakSelf.mas_top).offset(0);
        make.centerX.mas_equalTo(weakSelf.mas_centerX).offset(12.5);
    }];
    
    self.backgroundColor         = self.normalBackgroundColor;
    self.barImageView.image      = _selected ? self.selectImage : self.normalImage;
    self.barTitleLabel.text      = self.title;
    self.barTitleLabel.textColor = _selected ? self.titleSelectColor : self.titleNormalColor;
}

- (void)initSubviews
{
    self.titleNormalColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
    self.titleSelectColor = [UIColor colorWithRed:0.01 green:0.66 blue:0.96 alpha:1];
    
    self.backgoundImageView = [[UIImageView alloc]init];
    [self addSubview:self.backgoundImageView];
    
    self.barButton = [[UIButton alloc]initWithFrame:self.bounds];
    [self.barButton addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.barButton];
    
    self.barImageView = [[UIImageView alloc]init];
    self.barImageView.contentMode            = UIViewContentModeBottom;
    self.barImageView.clipsToBounds          = NO;
    self.barImageView.userInteractionEnabled = NO;
    [self addSubview:self.barImageView];
    
    self.barTitleLabel = [[UILabel alloc]init];
    self.barTitleLabel.font            = [UIFont systemFontOfSize:10.0];
    self.barTitleLabel.textAlignment   = NSTextAlignmentCenter;
    [self addSubview:self.barTitleLabel];
    
    self.badgeLabel = [[UILabel alloc] init];
    self.badgeLabel.font            = [UIFont boldSystemFontOfSize:11];
    self.badgeLabel.hidden          = YES;
    self.badgeLabel.textColor       = [UIColor whiteColor];
    self.badgeLabel.textAlignment   = NSTextAlignmentCenter;
    self.badgeLabel.backgroundColor = [UIColor colorWithRed:253.0/255.0 green:56.0/255.0 blue:56.0/255.0 alpha:1.0];
    
    CALayer *layer      = self.badgeLabel.layer;
    layer.borderColor   = [UIColor whiteColor].CGColor;
    layer.borderWidth   = 2.0;
    layer.cornerRadius  = 10.0;
    layer.masksToBounds = YES;
    
    [self addSubview:self.badgeLabel];
}

#pragma mark - Setter -

-(void)setSelected:(BOOL)selected
{
    if (_selected == selected)
    {
        return;
    }
    
    _selected = selected;
    
    if (selected)
    {
        self.barImageView.image       = self.selectImage;
        self.barTitleLabel.textColor  = self.titleSelectColor;
        self.backgoundImageView.image = self.selectBackgroundImage;
        self.backgroundColor          = self.selectBackgroundColor;
    }
    else
    {
        self.barImageView.image       = self.normalImage;
        self.barTitleLabel.textColor  = self.titleNormalColor;
        self.backgoundImageView.image = self.normalBackgroundImage;
        self.backgroundColor          = self.normalBackgroundColor;
    }
}

-(void)setNormalBackgroundImage:(UIImage *)normalBackgroundImage
{
    _normalBackgroundImage = normalBackgroundImage;
    
    if (!self.selected)
    {
        self.backgoundImageView.image = normalBackgroundImage;
    }
}

- (void)setBadgeValue:(NSString *)badgeValue
{
    _badgeValue = badgeValue;
    
    if ([badgeValue isEqualToString:@"0"])
    {
        self.badgeLabel.hidden = YES;
    }
    else
    {
        self.badgeLabel.text   = badgeValue;
        self.badgeLabel.hidden = NO;
    }
}

-(void)setBadgeBackgroundColor:(UIColor *)badgeBackgroundColor
{
    _badgeBackgroundColor           = badgeBackgroundColor;
    self.badgeLabel.backgroundColor = badgeBackgroundColor;
}

-(void)setBadgeStringColor:(UIColor *)badgeStringColor
{
    _badgeStringColor         = badgeStringColor;
    self.badgeLabel.textColor = badgeStringColor;
}

-(void)setTitle:(NSString *)title
{
    _title                  = title;
    self.barTitleLabel.text = title;
}

- (void)setTitleNormalColor:(UIColor *)titleNormalColor
{
    _titleNormalColor = titleNormalColor;
    
    if (!self.selected)
    {
        self.barTitleLabel.textColor = titleNormalColor;
    }
}

-(void)setNormalImage:(UIImage *)normalImage
{
    _normalImage = normalImage;
    
    if (!self.selected)
    {
        self.barImageView.image = normalImage;
    }
}

#pragma mark - Action -

- (void)btnClick
{
    if (self.touchActionBlock)
    {
        self.touchActionBlock(self);
    }
}


@end
