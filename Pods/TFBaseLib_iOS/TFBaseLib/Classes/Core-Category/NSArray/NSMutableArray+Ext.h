//
//  NSMutableArray+Ext.h
//  Treasure
//
//  Created by xiayiyong on 15/7/1.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSArray+Ext.h"

@interface NSMutableArray (Ext)

/**
 *  将两个元素互换位置
 *
 *  @return YES，表示移动成功，NO表示移动失败
 */
- (BOOL)exchangeObjectFromIndex:(NSUInteger)from toIndex:(NSUInteger)to;

@end
