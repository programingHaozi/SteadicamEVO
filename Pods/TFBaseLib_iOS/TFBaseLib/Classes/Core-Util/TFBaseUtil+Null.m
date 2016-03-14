//
//  TFBaseUtil+Null.m
//  TFBaseLib
//
//  Created by xiayiyong on 15/10/16.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFBaseUtil+Null.h"

id tf_removeNullFromObject(id object)
{
    return [TFBaseUtil removeNullFromObject:object];
}

@implementation TFBaseUtil (Null)

+ (id)removeNullFromObject:(id)object {
    if ([object isKindOfClass:[NSDictionary class]]) {
        return [self _removeNullFromDict:(NSDictionary *)object];
    } else if ([object isKindOfClass:[NSArray class]]) {
        return [self _removeNullFromArray:(NSArray *)object];
    } else if ([object isKindOfClass:[NSNull class]] || object == nil) {
        return nil;
    }
    
    return object;
}

+ (NSDictionary *)_removeNullFromDict:(NSDictionary *)dict {
    if (dict == nil || [dict isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionaryWithCapacity:dict.count];
    for (id key in dict.allKeys) {
        id object = [dict objectForKey:key];
        
        if ([object isKindOfClass:[NSNull class]] || object == nil) {
            // 不添加
        } else if ([object isKindOfClass:[NSDictionary class]]) {
            object = [self _removeNullFromDict:(NSDictionary *)object];
            
            if (object != nil) {
                [resultDict setObject:object forKey:key];
            }
        } else if ([object isKindOfClass:[NSArray class]]) {
            object = [self _removeNullFromArray:(NSArray *)object];
            
            if (object != nil) {
                [resultDict setObject:object forKey:key];
            }
        } else {
            [resultDict setObject:object forKey:key];
        }
    }
    
    return resultDict;
}

+ (NSArray *)_removeNullFromArray:(NSArray *)array {
    if (array == nil || [array isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    if (array.count == 0) {
        return array;
    }
    
    NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:array.count];
    
    for (NSUInteger i = 0; i < array.count; ++i) {
        id object = array[i];
        
        if ([object isKindOfClass:[NSNull class]] || object == nil) {
            // 不添加
        } else if ([object isKindOfClass:[NSDictionary class]]) {
            object = [self _removeNullFromDict:(NSDictionary *)object];
            if (object != nil && ![object isKindOfClass:[NSNull class]]) {
                [resultArray addObject:object];
            }
        } else if ([object isKindOfClass:[NSArray class]]) {
            object = [self _removeNullFromArray:(NSArray *)object];
            if (object != nil && ![object isKindOfClass:[NSNull class]]) {
                [resultArray addObject:object];
            }
        } else {
            [resultArray addObject:object];
        }
    }
    
    return resultArray;
}

@end
