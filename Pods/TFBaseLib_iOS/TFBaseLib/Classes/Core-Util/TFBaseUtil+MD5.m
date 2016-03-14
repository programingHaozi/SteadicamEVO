//
//  TFBaseUtil+MD5.m
//  TFBaseLib
//
//  Created by xiayiyong on 15/10/13.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFBaseUtil+MD5.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonKeyDerivation.h>

NSString *tf_md5(NSString *string)
{
    return [TFBaseUtil md5:string];
}

@implementation TFBaseUtil (MD5)

+(NSString *)md5:(NSString *)string
{
    NSMutableString *md5String = [NSMutableString string];
    const char *cString = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cString, (CC_LONG)strlen(cString), result);
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [md5String appendFormat:@"%02x",result[i]];
    }
    return md5String;
}

@end
