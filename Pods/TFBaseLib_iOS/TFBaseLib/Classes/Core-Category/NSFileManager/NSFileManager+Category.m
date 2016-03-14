//
//  NSFileManager+Category.m
//  Treasure
//
//  Created by xiayiyong on 15/7/1.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "NSFileManager+Category.h"

@implementation NSFileManager (Category)

- (BOOL)isFileExists:(NSString *)filePath
{
  NSFileManager *fileManager = [NSFileManager defaultManager];
  BOOL result = [fileManager fileExistsAtPath:filePath];
  return result;
}

- (long)fileSizeWithPath:(NSString *)path
{
  NSError *error = nil;
  NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path
                                                                              error:&error];
  if (error)
  {
    return 0;
  }
  NSString *fileSize = [NSString stringWithFormat:@"%@", [attributes objectForKey:@"NSFileSize"]];
  return fileSize.integerValue;
}

+ (BOOL)createFolder:(NSString *)folder atPath:(NSString *)path
{
    NSString *savePath = [path stringByAppendingPathComponent:folder];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory;
    BOOL exist = [fileManager fileExistsAtPath:savePath isDirectory:&isDirectory];
    NSError *error = nil;
    if (!exist || !isDirectory)
    {
        [fileManager createDirectoryAtPath:savePath withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    return [fileManager fileExistsAtPath:savePath isDirectory:&isDirectory];
}

+ (BOOL)saveData:(NSData *)data withName:(NSString *)name atPath:(NSString *)path
{
    if (data && name && path)
    {
        NSString *filePath = [path stringByAppendingPathComponent:name];
        return [data writeToFile:filePath atomically:YES];
    }
    
    return NO;
}

+ (NSData *)findFile:(NSString *)fileName atPath:(NSString *)path
{
    NSData *data = nil;
    if (fileName && path)
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *filePath = [path stringByAppendingPathComponent:fileName];
        
        if ([fileManager fileExistsAtPath:filePath])
        {
            data = [NSData dataWithContentsOfFile:filePath];
        }
    }
    
    return data;
}

+ (BOOL)deleteFile:(NSString *)fileName atPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    return success;
}

@end
