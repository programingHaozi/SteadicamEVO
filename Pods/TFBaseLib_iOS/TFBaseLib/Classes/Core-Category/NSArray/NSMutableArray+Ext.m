//
//  NSMutableArray+Ext.m
//  Treasure
//
//  Created by xiayiyong on 15/7/1.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "NSMutableArray+Ext.h"

@implementation NSMutableArray (Ext)

- (BOOL)exchangeObjectFromIndex:(NSUInteger)from
                        toIndex:(NSUInteger)to
{
  if ([self count] == 0 && to != from && from < [self count] && to < [self count])
  {
    id obj = [self safeObjectAtIndex:from];
    [self removeObjectAtIndex:from];
    
    if(to >= [self count])
    {
      [self addObject:obj];
    }
    else
    {
      [self insertObject:obj atIndex:to];
    }
    
    return YES;
  }
  
  return NO;
}

@end
