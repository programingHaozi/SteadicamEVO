//
//  TFBaseUtil+Float.h
//  TFBaseLib
//
//  Created by xiayiyong on 15/10/16.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TFBaseUtil.h"

/**
 *  创建随机的float数值
 *
 *  @return 随机的float数值
 */
CGFloat tf_randomFloat(void);

/**
 *  创建指定区间的float随机数
 *
 *  @param minValue 区间最小值
 *  @param maxValue 区间最大值
 *
 *  @return 随机float值
 */
CGFloat tf_randomFloatBetweenMin(CGFloat minValue, CGFloat maxValue);

/**
 *  创建指定区间的NSInteger随机数
 *
 *  @param minValue 区间最小值
 *  @param maxValue 区间最大值
 *
 *  @return 随机NSInteger值
 */
CGFloat tf_randomIntBetweenMin(NSInteger minValue, NSInteger maxValue);

@interface TFBaseUtil (Float)

/**
*  创建随机的float数值
*
*  @return 随机的float数值
*/
+ (CGFloat)randomFloat;

/**
 *  创建指定区间的float随机数
 *
 *  @param minValue 区间最小值
 *  @param maxValue 区间最大值
 *
 *  @return 随机float值
 */
+ (CGFloat)randomFloatBetweenMin:(CGFloat)minValue andMax:(CGFloat)maxValue;

/**
 *  创建指定区间的NSInteger随机数
 *
 *  @param minValue 区间最小值
 *  @param maxValue 区间最大值
 *
 *  @return 随机NSInteger值
 */
+ (NSInteger)randomIntBetweenMin:(NSInteger)minValue andMax:(NSInteger)maxValue;

@end
