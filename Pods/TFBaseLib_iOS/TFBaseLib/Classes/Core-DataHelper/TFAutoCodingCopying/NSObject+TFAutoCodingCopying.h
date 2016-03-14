//
//  NSObject+TFAutoCodingCopying.h
//  Treasure
//
//  Created by xiayiyong on 15/9/2.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//  from https://github.com/nicklockwood/AutoCoding
//

#import <UIKit/UIKit.h>

@interface NSObject (TFAutoCodingCopying)<NSCoding, NSSecureCoding, NSCopying>

/**
 *  自动实现copy
 *
 */
+ (NSDictionary *)codableProperties;

/**
 *  自动实现copy
 *
 */
- (NSDictionary *)codableProperties;

/**
 *  根据文件实现
 *
 */
+ (instancetype)objectWithContentsOfFile:(NSString *)path;

/**
 *  将文件写入到指定文件路径
 *
 */
- (BOOL)writeToFile:(NSString *)filePath atomically:(BOOL)useAuxiliaryFile;

@end

