//
//  TFBaseUtil+Tel.m
//  TFBaseLib
//
//  Created by xiayiyong on 15/10/16.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFBaseUtil+Tel.h"


BOOL tf_canTel(void)
{
    return [TFBaseUtil canTel];
}

void tf_tel(NSString* phoneNumber)
{
    return[TFBaseUtil tel:phoneNumber];
}

void tf_telprompt(NSString* phoneNumber)
{
    return [TFBaseUtil telprompt:phoneNumber];
}

@implementation TFBaseUtil (Tel)

//拨打电话

+ (BOOL)canTel
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel:"]];
}

+ (void)tel:(NSString*)phoneNumber
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNumber]]];
}

+ (void)telprompt:(NSString*)phoneNumber
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",phoneNumber]]];
}


@end
