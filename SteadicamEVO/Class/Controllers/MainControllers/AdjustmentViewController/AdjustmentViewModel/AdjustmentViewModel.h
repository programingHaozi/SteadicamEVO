//
//  AdjustmentViewModel.h
//  SteadicamEVO
//
//  Created by Chen Hao 陈浩 on 16/5/18.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import "SCEViewModel.h"

typedef NS_ENUM(NSUInteger, AdjustState)
{
    AdjustStateZero = 0,
    AdjustStateOne,
    AdjustStateTwo,
    AdjustStateThree,
    AdjustStateFour,
    AdjustStateFive,
    AdjustStateSix,
    AdjustStateSeven,
    AdjustStateEight,
};

@interface AdjustmentViewModel : SCEViewModel

@property (nonatomic, assign) AdjustState adjustState;

@property (nonatomic, strong) NSString *instruction;

@end
