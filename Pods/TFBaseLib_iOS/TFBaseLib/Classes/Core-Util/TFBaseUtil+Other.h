//
//  TFBaseUtil+Other.h
//  TFBaseLib
//
//  Created by xiayiyong on 16/2/4.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TFBaseUtil.h"

/**
 *  设置屏幕是否常亮
 *
 *  @param enable
 */
void tf_idleTimerDisabled(BOOL enable);

/**
 *  从xib中获取view
 *
 *  @param className xib的文件名
 *
 *  @return 返回view
 */
id tf_getViewFromNib(NSString *className);

/**
 *  从xib中获取VC
 *
 *  @param className vc的文件名
 *
 *  @return 返回VC
 */
id tf_getVCFromNib(NSString *className);

/**
 *  判读是否为空或输入只有空格
 *
 *  @param string string
 *
 *  @return 如果是空或者空格返回YES
 */
BOOL tf_isEmpty(NSString *string);

/**
 *  禁止输入表情 判断驶入的字段为表情的时候，用空字符替换。
 *
 *  @param string string
 *
 *  @return 处理好的字符串
 */
NSString *tf_disableEmoji(NSString *string);

/**
 *  判断驶入的字段为表情
 *
 *  @param string string
 *
 *  @return 是表情返回YES
 */

BOOL tf_isContainsEmoji(NSString *string);


@interface TFBaseUtil (Other)

/**
 *  设置屏幕是否常亮
 *
 *  @param enable
 */
+ (void)idleTimerDisabled:(BOOL)enable;

/**
 *  从xib中获取view
 *
 *  @param className xib的文件名
 *
 *  @return 返回view
 */
+ (id)getViewFromNib:(NSString *)className;

/**
 *  从xib中获取VC
 *
 *  @param className vc的文件名
 *
 *  @return 返回VC
 */
+ (id)getVCFromNib:(NSString *)className;

/**
 *  判断字符串是否为空
 *
 *  @param string string
 *
 *  @return 空返回YES
 */
+(BOOL) isEmpty:(NSString *)string;

/**
 *  禁止输入表情 判断驶入的字段为表情的时候，用空字符替换。
 *
 *  @param string string
 *
 *  @return 处理好的字符串
 */
+(NSString *) disableEmoji:(NSString *)string;

/**
 *  判断驶入的字段为表情
 *
 *  @param string string
 *
 *  @return 是表情返回YES
 */
+(BOOL) isContainsEmoji:(NSString *)string;

@end
