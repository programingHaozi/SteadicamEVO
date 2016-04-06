//
//  GuideViewModel.m
//  SteadicamEVO
//
//  Created by Chen Hao 陈浩 on 16/3/30.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import "GuideViewModel.h"

@implementation GuideViewModel

-(instancetype)init
{
    if (self = [super init])
    {
        
    
    }
    
    return self;
}

- (NSString *)title
{
    return @"Guide setup";
}

-(NSArray *)moviePathAry
{
    
    NSArray *ary = @[
                     [[NSBundle mainBundle] pathForResource:@"安装底部配重" ofType:@"mov"],
                     [[NSBundle mainBundle] pathForResource:@"上电进入调重心模式" ofType:@"mov"],
                     [[NSBundle mainBundle] pathForResource:@"安装手机" ofType:@"mov"],
                     [[NSBundle mainBundle] pathForResource:@"展开" ofType:@"mov"],
                     [[NSBundle mainBundle] pathForResource:@"调整前后位置" ofType:@"mov"],
                     ];
    
    return ary;
}

@end
