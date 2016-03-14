//
//  TFBaseUtil+Identifier.h
//  TFBaseLib
//
//  Created by xiayiyong on 15/10/16.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFBaseUtil.h"

/**
 *  获取Identifier
 *
 *  @return Identifier
 */
NSString *tf_uniqueIdentifier(void);

@interface TFBaseUtil (Identifier)

/**
 *  获取Identifier
 *
 *  @return Identifier
 */
+ (NSString *)uniqueIdentifier;

@end
