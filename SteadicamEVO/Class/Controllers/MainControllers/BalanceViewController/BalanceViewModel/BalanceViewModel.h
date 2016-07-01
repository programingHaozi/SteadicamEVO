//
//  BalanceViewModel.h
//  SteadicamEVO
//
//  Created by Chen Hao 陈浩 on 16/3/30.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import "SCEViewModel.h"

typedef NS_ENUM(NSUInteger, BalanceState)
{
    BalanceStateUnFold = 0,
    BalanceStateInstall = 1,
    BalanceStateSet = 2,
    BalanceStateHold = 3,
    BalanceStatePower = 4,
//    BalanceStateSlide = 5,
//    BalanceStateAdjust = 6,
//    BalanceStateSlideAgain = 7,
};

@interface BalanceViewModel : SCEViewModel

@property (nonatomic, assign) BalanceState balanceState;

@property (nonatomic, strong) NSString *instruction;

@property (nonatomic, strong) NSString *moviePath;

@end
