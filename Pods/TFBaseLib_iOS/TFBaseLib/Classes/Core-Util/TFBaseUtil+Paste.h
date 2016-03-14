//
//  TFBaseUtil+Paste.h
//  TFBaseLib
//
//  Created by xiayiyong on 15/10/16.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TFBaseUtil.h"

/**
 *  设置需要粘贴的文字
 *
 *  @param string string
 */
void tf_pasteString(NSString* string);

/**
 *  设置需要粘贴的图片
 *
 *  @param image image
 */
void tf_pasteImage(UIImage* image);

@interface TFBaseUtil (Paste)

/**
 *  设置需要粘贴的文字
 *
 *  @param string string
 */
+(void)pasteString:(NSString*)string;

/**
 *  设置需要粘贴的图片
 *
 *  @param image image
 */
+(void)pasteImage:(UIImage*)image;

@end
