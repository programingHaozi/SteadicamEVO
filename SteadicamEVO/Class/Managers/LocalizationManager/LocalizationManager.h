//
//  LocalizationManager.h
//  LocaliztionDemo
//
//  Created by 耗子 on 16/3/13.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kUserLanguage             @"userLanguage"

#define LocalizedBundle           [LocalizationManager shareInstance].languageBundle

#define LocalizedLanguage         [LocalizationManager shareInstance].userLanguage

#define  Localized(key)           [[LocalizationManager shareInstance] locatizedStringForkey:key]

#define LocalizedImage(key)       [[LocalizationManager shareInstance] localizedImageForKey:key]

#define LocalizedNib(name)        [[LocalizationManager shareInstance] localizedNibWithName:name]

#define LocalizedStoryboard(name) [[LocalizationManager shareInstance] localizedStoryboardWithName:name]

/**
 *  应用内国际化Manager
 */
@interface LocalizationManager : NSObject

/**
 *  语言Bundle
 */
@property (nonatomic, strong) NSBundle *languageBundle;

/**
 *  用户选择语言
 */
@property (nonatomic, strong) NSString *userLanguage;

/**
 *  单例方法
 *
 *  @return LocalizationManager
 */
+ (LocalizationManager *)shareInstance;

/**
 *  根据Key获取国际化string值
 *
 *  @param key 国际化string的key
 *
 *  @return 国际化string的value
 */
- (NSString *)localizedStringForKey:(NSString *)key;

/**
 *  根据Key获取国际化图片
 *
 *  @param key 国际化图片的Key
 *
 *  @return 国际化图片
 */
- (UIImage *)localizedImageForKey:(NSString *)key;

/**
 *  根据名称获取storyboard
 *
 *  @param storyboardName storyboard的名称
 *
 *  @return storyboard
 */
- (UIStoryboard *)localizedStoryboardWithName:(NSString *)storyboardName;

/**
 *  根据名称获取nib
 *
 *  @param nibName nib名称
 *
 *  @return UINib
 */
-(UINib *)localizedNibWithName:(NSString *)nibName;

@end
