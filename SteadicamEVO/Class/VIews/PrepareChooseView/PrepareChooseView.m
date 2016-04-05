//
//  PrepareChooseView.m
//  SteadicamEVO
//
//  Created by Chen Hao 陈浩 on 16/3/31.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import "PrepareChooseView.h"

@interface PrepareChooseView()

@property (nonatomic, strong) TFLabel *titlLabel;

@property (nonatomic, strong) TFButton *leftButton;

@property (nonatomic, strong) TFButton *rightButton;

@end

@implementation PrepareChooseView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self initViews];
        [self autolayoutViews];
        [self bindData];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    
    self = [self initWithLeft:nil
                        right:nil
                        title:nil];
   return self;
}

-(instancetype)initWithLeft:(NSString *)left
                      right:(NSString *)right
                      title:(NSString *)title
{
    if (self = [super initWithFrame:CGRectZero])
    {
        [self initViewsWithLeft:left
                          right:right
                          title:title];
        [self autolayoutViews];
        [self bindData];
    }
    
    return self;
}

- (void)initViewsWithLeft:(NSString *)left
                    right:(NSString *)right
                    title:(NSString *)title
{
    WS(weakSelf)
    
    self.leftButton = [[TFButton alloc]init];
    [self.leftButton setNormalTitle:left
                           textFont:nil
                          textColor:[UIColor whiteColor]];
    [self.leftButton touchAction:^{
        
        weakSelf.selectBlock(0);
    }];
    [self addSubview:self.leftButton];
    
    self.rightButton = [[TFButton alloc]init];
    [self.rightButton setNormalTitle:right
                             textFont:nil
                            textColor:DefaultDarkColor];
    [self.rightButton touchAction:^{
        
        weakSelf.selectBlock(1);
    }];
    [self addSubview:self.rightButton];
    
    self.titlLabel = [[TFLabel alloc]init];
    self.titlLabel.textColor = [UIColor whiteColor];
    self.titlLabel.text = title;
    self.titlLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titlLabel];
}

- (void)initViews
{
    
}

- (void)autolayoutViews
{
    WS(weakSelf)
    [self.titlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@20);
        make.top.equalTo(weakSelf.mas_top).offset(0);
        make.left.equalTo(weakSelf.mas_left).offset(0);
        make.right.equalTo(weakSelf.mas_right).offset(0);
    }];
    
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@92);
        make.height.equalTo(@54);
        make.left.equalTo(weakSelf.mas_left).offset(0);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(0);
    }];
    
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@92);
        make.height.equalTo(@54);
        make.right.equalTo(weakSelf.mas_right).offset(0);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(0);
    }];
}

-(void)bindData
{
    
}

@end
