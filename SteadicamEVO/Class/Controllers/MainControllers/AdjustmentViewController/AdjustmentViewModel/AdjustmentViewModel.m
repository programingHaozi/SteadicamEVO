//
//  AdjustmentViewModel.m
//  SteadicamEVO
//
//  Created by Chen Hao 陈浩 on 16/5/18.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import "AdjustmentViewModel.h"

@interface AdjustmentViewModel()

@property (nonatomic, strong) NSArray *instructionAry;

@end

@implementation AdjustmentViewModel

-(instancetype)init
{
    if (self = [super init])
    {
        _instructionAry = @[
                            @"Turn knob to move the phone in the direction shown.",
                            @"Calibrating...",
                            @"Turn knob to move the phone in the direction shown.",
                            @"Slide the red mark below to align ▽with△.",
                            @"Slide the red mark below to align ▽with△.",
                            @"Please according to the  direction shown to adjust Fore/Aft or Weight.",
                            @"Calibrating...",
                            @"Please according to the  direction shown to adjust Fore/Aft or Weight.",
                            @"The calibration completed."
                            ];
    }
    
    return self;
}

-(NSString *)title
{
    return @"Roll Adjustment";
}

-(void)setAdjustState:(AdjustState)adjustState
{
    _adjustState = adjustState;
    
    self.instruction = self.instructionAry[adjustState];
}

@end
