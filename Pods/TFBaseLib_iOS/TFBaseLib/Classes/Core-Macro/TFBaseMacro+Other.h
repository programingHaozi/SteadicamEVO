//
//  TFMacro+Color.h
//  Treasure
//
//  Created by xiayiyong on 15/9/14.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

/**
 *  宽的缩放比例
 */
#define WIDTH_SCALE ([UIScreen mainScreen].bounds.size.width / 320.0)

/**
 *  高的缩放比例
 *
 */
#define HEIGHT_SCALE ([UIScreen mainScreen].bounds.size.height / 568.0)

/**
 *  创建数组
 */
#define ARR(...) [NSArray arrayWithObjects:__VA_ARGS__, nil]

/**
 *  创建动态数组
 */
#define MARR(...) [NSMutableArray arrayWithObjects:__VA_ARGS__, nil]

/**
 *  创建字符串
 */
#define STR(string, args...)    [NSString stringWithFormat:string, args]

/**
 *  读取本地图片
 *
 *  @param file 地址
 *  @param ext  类型
 *
 *  @return 获取到的图片
 */
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]

/**
 *  定义UIImage对象
 *
 *  @param name image的名字
 *
 *  @return UIImage对象
 */
#define IMAGE(name) [UIImage imageNamed:name]

/**
 *  创建alter
 *
 *  @param title title
 *  @param msg   内容
 *
 *  @return alter
 */
#define ALERT(title, msg) \
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil \
cancelButtonTitle:@"确定" \
otherButtonTitles:nil]; \
[alert show];

/**
 *  创建通知
 *
 *  @param name 通知的name
 *
 *  @return 创建的通知
 */
#define POST_NOTIFICATION(name) [[NSNotificationCenter defaultCenter] postNotificationName:name object:self];

/**
 *  判断是真机
 */
#if TARGET_OS_IPHONE
//iPhone Device
#endif

/**
 *  判断是模拟器
 */
#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif

/**
 *  创建imageview并设置偏移量
 *
 *  @param name   name
 *  @param top    top
 *  @param left   left
 *  @param bottom bottom
 *  @param right  right
 *
 *  @return 设置好的image
 */
#define RESIZABLE_IMAGE(name,top,left,bottom,right) [[UIImage imageNamed:name] resizableImageWithCapInsets:UIEdgeInsetsMake(top,left,bottom,right)]

/**
 *  创建imageview并设置偏移量
 *
 *  @param name   name
 *  @param top    top
 *  @param left   left
 *  @param bottom bottom
 *  @param right  right
 *  @param mode   mode
 *
 *  @return 设置好的image
 */
#define RESIZABLE_IMAGE_MODEL(name,top,left,bottom,right,mode) [[UIImage imageNamed:name] resizableImageWithCapInsets:UIEdgeInsetsMake(top,left,bottom,right) resizingMode:mode]

/**
 * 通过不同机型的设计稿像素值获取高度
 *
 *  @param iPhone5  iPhone5机型
 *  @param iPhone6  iPhone6机型
 *  @param iPhone6p iPhone6P机型
 *
 */
#define STYLE_BY_PIXEL(iPhone5, iPhone6, iPhone6p)\
(TARGET_IPHONE_6PLUS ? iPhone6p / 3.0 : (TARGET_IPHONE_6 ? iPhone6 / 2.0 : iPhone5 / 2.0))


/**
 *  通过设计稿中给的像素获取实际设备像素
 *
 *  @param designedPixel 设计稿中给的像素值
 */
#define REAL_PIXEL(designedPixel)\
(TARGET_IPHONE_6PLUS ? (designedPixel / 3.0) : (designedPixel / 2.0))

#define HEIGHT(px) (TARGET_IPHONE_6PLUS ? px*1.5 : px)
#define WIDTH(px) (TARGET_IPHONE_6PLUS ? px*1.5 : px)