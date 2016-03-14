//
//  TFKeyChain.h
//  TFBaseLib
//
//  Created by xiayiyong on 15/10/21.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kTFKeyChain  ([TFKeyChain standardKeyChain])

@interface TFKeyChain : NSObject

/**
 *  构造钥匙串
 *
 */
+ (instancetype)standardKeyChain;

@end
