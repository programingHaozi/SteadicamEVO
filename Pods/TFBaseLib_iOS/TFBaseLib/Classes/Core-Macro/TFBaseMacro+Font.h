//
//  TFMacro+Font.h
//  Treasure
//
//  Created by xiayiyong on 15/9/14.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

/**
 *  设置字体
 */
#define FONT(size) [UIFont systemFontOfSize:size ]

/**
 *  设置加粗字体
 */
#define BFONT(size) [UIFont boldSystemFontOfSize:size]

/**
 * 通过不同机型的设计稿像素值获取系统字体
 *
 *  @param iPhone5  iPhone5机型
 *  @param iPhone6  iPhone6机型
 *  @param iPhone6p iPhone6P机型
 *
 */
#define FONT_BY_PIXEL(iPhone5, iPhone6, iPhone6p)\
(TARGET_IPHONE_6PLUS ? [UIFont systemFontOfSize:iPhone6p / 3] : (TARGET_IPHONE_6 ? [UIFont systemFontOfSize:iPhone6 / 2] : [UIFont systemFontOfSize:iPhone5 / 2]))

#define FONT_BOLD_BY_PIXEL(iPhone5, iPhone6, iPhone6p)\
(TARGET_IPHONE_6PLUS ? [UIFont boldSystemFontOfSize:iPhone6p / 3] : (TARGET_IPHONE_6 ? [UIFont boldSystemFontOfSize:iPhone6 / 2] : [UIFont boldSystemFontOfSize:iPhone5 / 2]))

/**
 * 通过不同机型的设计稿像素值获取系统字体
 *
 *  @param iPhone5  iPhone5机型
 *  @param iPhone6  iPhone6机型
 *  @param iPhone6p iPhone6P机型
 *  @param fontName 字体名
 *
 */
#define FONT_BY_PIXEL_FONTNAME(iPhone5, iPhone6, iPhone6p, fontName)\
(TARGET_IPHONE_6PLUS ? [UIFont fontWithName:fontName size:iPhone6p / 3] : (TARGET_IPHONE_6 ? [UIFont fontWithName:fontName size:iPhone6 / 2] : [UIFont fontWithName:fontName size:iPhone5 / 2]))