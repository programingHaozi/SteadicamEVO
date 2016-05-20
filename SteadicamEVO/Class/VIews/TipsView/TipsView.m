
//
//  TipsView.m
//  SteadicamEVO
//
//  Created by 耗子 on 16/4/5.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import "TipsView.h"

@interface TipsView()

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) TFLabel *messageLabel;

@property (nonatomic, strong) TFButton *confirmButton;

@property (nonatomic, strong) TFButton *cancelButton;

@end

@implementation TipsView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self initViewsWithMessage:nil
                         buttonAry:nil];
        [self autolayoutViews];
        [self bindData];
    }
    
    return self;
}



-(instancetype)initWithFrame:(CGRect)frame
{
    self = [self initWithMessage:nil
                     buttonArray:nil];
    
    return self;
}

//-(instancetype)initWithMessage:(NSString *)message
//                   buttonTitle:(NSString *)title
//{
//    if (self = [super initWithFrame:CGRectZero])
//    {
//        [self initViewsWithMessage:message
//                       buttonTitle:title];
//        [self autolayoutViews];
//        [self bindData];
//    }
//    
//    return self;
//}

- (instancetype)initWithMessage:(NSString *)message buttonArray:(NSArray *)titleAry
{
    if (self = [super initWithFrame:CGRectZero])
    {
        [self initViewsWithMessage:message
                       buttonAry:titleAry];
        [self autolayoutViews];
        [self bindData];
    }
    
    return self;
}

- (void)initViews
{
}



- (void)initViewsWithMessage:(NSString *)message
                 buttonAry:(NSArray *)titleAry
{
    self.bgImageView       = [[UIImageView alloc]init];
    self.bgImageView.image = IMAGE(@"messgeBg");
    [self addSubview:self.bgImageView];
    
    self.messageLabel               = [[TFLabel alloc]init];
    self.messageLabel.text          = message;
    self.messageLabel.textColor     = HEXCOLOR(0x2d2e2e, 1);
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.font          = [UIFont boldSystemFontOfSize:16];
    self.messageLabel.numberOfLines = 0;
    
    [self addSubview:self.messageLabel];
    
    
    if (titleAry.count == 1)
    {
        self.confirmButton = [[TFButton alloc]init];
        [self.confirmButton setNormalTitle:titleAry[0]
                                  textFont:nil
                                 textColor:HEXCOLOR(0x2d2e2e, 1)];
        [self.confirmButton setNormalBackgroundImage:@"whiteButtonBg1"
                         hightlightedBackgroundImage:@"whiteButtonBg2"
                             disabledBackgroundImage:nil];
        
        WS(weakSelf)
        [self.confirmButton touchAction:^{
            
            if (weakSelf.confirmBlock)
            {
                weakSelf.confirmBlock();
            }
        }];
        [self addSubview:self.confirmButton];
        
        [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(@94);
            make.height.equalTo(@53);
            make.centerX.equalTo(weakSelf.mas_centerX).offset(0);
            make.bottom.equalTo(weakSelf.mas_bottom).offset(-25);
        }];
    }
    else if (titleAry.count == 2)
    {
        self.confirmButton = [[TFButton alloc]init];
        [self.confirmButton setNormalTitle:titleAry[0]
                                  textFont:nil
                                 textColor:HEXCOLOR(0x2d2e2e, 1)];
        [self.confirmButton setNormalBackgroundImage:@"whiteButtonBg1"
                         hightlightedBackgroundImage:@"whiteButtonBg2"
                             disabledBackgroundImage:nil];
        
        WS(weakSelf)
        [self.confirmButton touchAction:^{
            
            if (weakSelf.confirmBlock)
            {
                weakSelf.confirmBlock();
            }
        }];
        [self addSubview:self.confirmButton];
        
        [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(@94);
            make.height.equalTo(@53);
            make.left.equalTo(@34);
            make.bottom.equalTo(weakSelf.mas_bottom).offset(-25);
        }];
        
        self.cancelButton = [[TFButton alloc]init];
        [self.cancelButton setNormalTitle:titleAry[1]
                                  textFont:nil
                                 textColor:HEXCOLOR(0x2d2e2e, 1)];
        [self.cancelButton setNormalBackgroundImage:@"whiteButtonBg1"
                         hightlightedBackgroundImage:@"whiteButtonBg2"
                             disabledBackgroundImage:nil];
        
        
        [self.cancelButton touchAction:^{
            
            if (weakSelf.cancelBlock)
            {
                weakSelf.cancelBlock();
            }
        }];
        [self addSubview:self.cancelButton];
        
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(@94);
            make.height.equalTo(@53);
            make.right.equalTo(@-34);;
            make.bottom.equalTo(weakSelf.mas_bottom).offset(-25);
        }];
    }
    
}

-(void)autolayoutViews
{
    WS(weakSelf)
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.mas_top).offset(0);
        make.left.equalTo(weakSelf.mas_left).offset(0);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(0);
        make.right.equalTo(weakSelf.mas_right).offset(0);
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@70);
        make.top.equalTo(weakSelf.mas_top).offset(40);
        make.left.equalTo(weakSelf.mas_left).offset(10);
        make.right.equalTo(weakSelf.mas_right).offset(-10);
    }];
    
   
    
}

-(void)bindData
{
    
}

@end
