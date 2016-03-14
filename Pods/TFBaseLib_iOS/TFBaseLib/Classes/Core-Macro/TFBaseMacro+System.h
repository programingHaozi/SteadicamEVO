//
//  TFMacro+System.h
//  Treasure
//
//  Created by xiayiyong on 15/9/14.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

/**
 *  手机系统的版本
 */
#define SYSTEM_VERSION [[UIDevice currentDevice] systemVersion]

/**
 *  手机系统的语言
 */
#define SYSTEM_LANGUAGE ([[NSLocale preferredLanguages] objectAtIndex:0])

/**
 *  APP版本
 */
#define APP_VERSION      [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

/**
 *  app的主window
 */
#define APP_KEY_WINDOW                [[UIApplication sharedApplication] keyWindow]

/**
 *  app的delegate
 */
#define APP_DELEGATE      ((AppDelegate *)[[UIApplication sharedApplication] delegate])

/**
 *  系统版本是ios9
 */
#define TARGET_IOS9X [[[UIDevice currentDevice] systemVersion] floatValue] >=9.0f

/**
 *  系统版本是ios8
 */
#define TARGET_IOS8X [[[UIDevice currentDevice] systemVersion] floatValue] >=8.0f

/**
 *  系统版本是ios7
 */
#define TARGET_IOS7X [[[UIDevice currentDevice] systemVersion] floatValue] >=7.0f

/**
 *  设备是手机5
 */
#define TARGET_IPHONE      (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

/**
 *  设备是iPad
 */
#define TARGET_IPAD   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

/**
 *  设备是模拟器
 */
#define TARGET_SIMULATOR   (NSNotFound != [[[UIDevice currentDevice] model] rangeOfString:@"Simulator"].location)
/**
 *  设备是iPhone4
 */
#define TARGET_IPHONE_4  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

/**
 *  设备是iPhone5
 */
#define TARGET_IPHONE_5  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

/**
 *  设备是iPhone6
 */
#define TARGET_IPHONE_6    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334),[[UIScreen mainScreen] currentMode].size) : NO)

/**
 *  设备是iPhone6P
 */
#define TARGET_IPHONE_6PLUS    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208),[[UIScreen mainScreen] currentMode].size) : NO)



