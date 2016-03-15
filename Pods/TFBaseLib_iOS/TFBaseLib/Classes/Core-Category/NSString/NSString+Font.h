//
//  NSString+Font.h
//  TFBaseLib
//
//  Created by xiayiyong on 16/3/14.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Font)

/**
 *  根据字体计算size
 *
 *  @param font
 *  @param size
 *  @param lineBreakMode
 *
 *  @return
 */
- (CGSize)widthWithFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;

/**
 *  根据字体计算宽度
 *
 *  @param font
 *
 *  @return
 */
- (CGFloat)widthWithFont:(UIFont *)font;

- (CGFloat)widthWithFont:(UIFont *)font width:(CGFloat)width;

- (CGFloat)heightWithFont:(UIFont *)font;

- (CGFloat)heightWithFont:(UIFont *)font width:(CGFloat)width;

@end
