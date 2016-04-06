//
//  BalanceViewModel.m
//  SteadicamEVO
//
//  Created by Chen Hao 陈浩 on 16/3/30.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import "BalanceViewModel.h"

@interface BalanceViewModel()

@property (nonatomic, strong) NSArray *instructionAry;

@property (nonatomic, strong) NSArray *moviePathAry;

@property (nonatomic, strong) NSArray *titleAry;

@end

@implementation BalanceViewModel

-(instancetype)init
{
    if (self = [super init])
    {
        _instructionAry = @[
                            @"Unfold the evo and install the phone",
                            @"Install lower weights and adjust lower weight to bottom",
                            @"Set Fore/Aft to center position",
                            @"Hold properly during balancing",
                            @"Power on evo into “Balance Mode”",
                            @"",
                            @"Adjust the counterweight to: 0 extra weights",
                            @""
                            ];
        
        _moviePathAry = @[
                         [[NSBundle mainBundle] pathForResource:@"安装手机" ofType:@"mov"],
                         [[NSBundle mainBundle] pathForResource:@"安装底部配重" ofType:@"mov"],
                         [[NSBundle mainBundle] pathForResource:@"调整前后位置" ofType:@"mov"],
                         [[NSBundle mainBundle] pathForResource:@"正确手持方式" ofType:@"png"],
                         [[NSBundle mainBundle] pathForResource:@"上电进入调重心模式" ofType:@"mov"],
                         @"",
                         [[NSBundle mainBundle] pathForResource:@"安装底部配重" ofType:@"mov"],
                         @""
                         ];
        
        _titleAry = @[
                      @"Balance tuner",
                      @"Balance tuner",
                      @"Balance tuner",
                      @"Balance tuner",
                      @"Balance tuner",
                      @"Coarse Adjustment",
                      @"Counterweight Adjustment",
                      @"Fine Adjustment",
                      ];
    }
    
    return self;
}

-(NSString *)title
{
    return self.titleAry[self.balanceState];
}

- (void)setBalanceState:(BalanceState)balanceState
{
    if (balanceState > 7)
    {
        return;
    }
    
    _balanceState = balanceState;
    
    self.instruction = self.instructionAry[balanceState];
    
    self.moviePath = self.moviePathAry[balanceState];
    
}



@end
