//
//  UIImage+Adapt.m
//  Treasure
//
//  Created by xiayiyong on 15/12/8.
//  Copyright © 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "UIImage+Adapt.h"
#import "TFBaseMacro+System.h"

#define SUFFIX_1X_PNG   @".png"
#define SUFFIX_3X_PNG   @"@3x.png"
#define SUFFIX_2X_PNG   @"@2x.png"

@implementation UIImage (Adapt)

+(UIImage*)imageWithName:(NSString*)name
{
    if (TARGET_IPHONE_6PLUS)
    {

        NSString *name3x = [[UIImage getImageName:name] stringByAppendingString:SUFFIX_3X_PNG];
        
        NSString *path3x=[[NSBundle mainBundle] pathForResource:name3x ofType:@""];
        
        if (path3x)
        {
            return [UIImage imageWithContentsOfFile:path3x];
        }
        else
        {
            NSString *name2x = [[UIImage getImageName:name] stringByAppendingString:SUFFIX_2X_PNG];
            
            NSString *path2x=[[NSBundle mainBundle] pathForResource:name2x ofType:@""];
            
            if (path2x)
            {
                return [UIImage imageWithContentsOfFile:path2x];
            }
            else
            {
                NSString *name1x = [[UIImage getImageName:name] stringByAppendingString:SUFFIX_1X_PNG];
                NSString *path1x=[[NSBundle mainBundle] pathForResource:name1x ofType:@""];
                return [UIImage imageWithContentsOfFile:path1x];
            }
        }
    }
    else
    {
        NSString *name2x = [[UIImage getImageName:name] stringByAppendingString:SUFFIX_2X_PNG];
        
        NSString *path2x=[[NSBundle mainBundle] pathForResource:name2x ofType:@""];
        
        if (path2x)
        {
            return [UIImage imageWithContentsOfFile:path2x];
        }
        else
        {
            NSString *name1x = [[UIImage getImageName:name] stringByAppendingString:SUFFIX_1X_PNG];
            NSString *path1x=[[NSBundle mainBundle] pathForResource:name1x ofType:@""];
            return [UIImage imageWithContentsOfFile:path1x];
        }
    }
    
    
    return nil;
}

// 获取图片的名字(不带扩展名)
+ (NSString *)getImageName:(NSString *)name
{
    if(name)
    {
        NSArray *tempArray = [name componentsSeparatedByString:@"."];
        
        if(tempArray)
        {
            // 有.分割的文件名
            if([tempArray count] > 1)
            {
                NSString *extName = [tempArray lastObject];
               return [name substringWithRange:NSMakeRange(0, name.length - (extName.length + 1))];
            }
        }
    }
    
    return name;
}

@end
