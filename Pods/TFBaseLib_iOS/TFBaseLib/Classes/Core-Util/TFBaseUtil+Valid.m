//
//  TFBaseUtil+Valid.m
//  TFBaseLib
//
//  Created by xiayiyong on 16/2/25.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFBaseUtil+Valid.h"
#import "NSString+STRegex.h"

BOOL tf_isValidPassword(NSString *password)
{
    return [password isValidPassword];
}

BOOL tf_isValidPhone(NSString *phone)
{
    return [phone isValidPhone];
}

BOOL tf_isValidCarNo(NSString *lp)
{
    return [TFBaseUtil isValidCarNo:lp];
}

BOOL tf_isValidAllCarNo(NSString *carNo)
{
    return [TFBaseUtil isValidAllCarNo:carNo];
}

BOOL tf_isValidNickname(NSString *nickname)
{
    return [TFBaseUtil isValidNickname:nickname];
}

BOOL tf_isValidRealName(NSString *realName)
{
    return [TFBaseUtil isValidRealName:realName];
}

BOOL tf_isValidVinNo(NSString *vinNo)
{
    return [TFBaseUtil isValidVinNo:vinNo];
}

BOOL tf_isValidEngineNo(NSString *engineNo)
{
    return [TFBaseUtil isValidEngineNo:engineNo];
}


@implementation TFBaseUtil (Valid)


+(BOOL) isValidPassword:(NSString *)password
{
    return [password isValidPassword];
}

+(BOOL) isValidPhone:(NSString *)phone
{
    return [phone isValidPhone];
}

+(BOOL) isValidCarNo:(NSString *)lp
{
    NSString *regex = @"^[A-Za-z]+$";
    NSString *regexNum = @"^[0-9]+$";
    NSString *regexAll = @"^[A-Za-z0-9]+$";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    NSPredicate *predicateNum = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexNum];
    NSPredicate *predicateAll = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexAll];
    if ([predicateAll evaluateWithObject:[lp substringFromIndex:1]])
    {
        if ([predicate evaluateWithObject:[lp substringFromIndex:1]] ||
            [predicateNum evaluateWithObject:[lp substringFromIndex:1]])
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else
    {
        return NO;
    }
    
    return YES;
}

+(BOOL) isValidAllCarNo:(NSString *)carNo
{
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    BOOL isCarNo=[carTest evaluateWithObject:carNo];
    
    NSString *carRegex1 = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{6}$";
    NSPredicate *carTest1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex1];
    BOOL isCardNo1 = ![carTest1 evaluateWithObject:carNo];
    
    return isCarNo&&isCardNo1;
}

+(BOOL) isValidNickname:(NSString *)nickname
{
    NSString *regex = @"^[-.A-Za-z0-9➋➌➍➎➏➐➑➒_\u4E00-\u9FA5]{1,20}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isNickname= [passWordPredicate evaluateWithObject:nickname];
    return isNickname;
}

+(BOOL) isValidRealName:(NSString *)realName
{
    NSString *regex = @"^[A-Za-z\u4e00-\u9fa5]{1,20}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isRealName= [passWordPredicate evaluateWithObject:realName];
    return isRealName;
}

+(BOOL) isValidVinNo:(NSString *)vinNo
{
    NSString *nicknameRegex =@"(^[A-Za-z0-9]{17}$)";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    BOOL isVinNo= [passWordPredicate evaluateWithObject:vinNo];
    return isVinNo;
}

+(BOOL) isValidEngineNo:(NSString *)engineNo
{
    NSString *regexAll = @"^[A-Za-z0-9]+$";
    NSPredicate *predicateAll = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexAll];
    
    if (![predicateAll evaluateWithObject:engineNo])
    {
        return NO;
    }
    else
    {
        return YES;
    }
    
}


@end
