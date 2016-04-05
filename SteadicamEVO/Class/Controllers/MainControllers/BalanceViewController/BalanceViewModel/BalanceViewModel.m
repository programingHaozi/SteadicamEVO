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

@property (nonatomic, strong) NSArray *gifPathAry;

@property (nonatomic, strong) NSArray *titleAry;

@end

@implementation BalanceViewModel

-(instancetype)init
{
    if (self = [super init])
    {
        _instructionAry = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
        
        _gifPathAry = @[@"",@"",@"",@"",@"",@"",@"",@""];
        
        _titleAry = @[@"Balance tuner",@"Balance tuner",@"Balance tuner",@"Balance tuner",@"Balance tuner",@"Coarse Adjustment",@"Counterweight Adjustment",@"Fine Adjustment",];
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
    
    self.gifPath = self.gifPathAry[balanceState];
    
}



@end
