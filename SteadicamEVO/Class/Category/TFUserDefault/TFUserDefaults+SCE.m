//
//  TFUserDefaults+SCE.m
//  SteadicamEVO
//
//  Created by Chen Hao 陈浩 on 16/3/16.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import "TFUserDefaults+SCE.h"

@implementation TFUserDefaults (SCE)

@dynamic lastAPPVersion;
@dynamic account;
@dynamic password;

- (NSString *)transformKey:(NSString *)key
{
    return [NSString stringWithFormat:@"userdefault_cxbapp_%@", key];
}

@end
