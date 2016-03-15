//
//  TFDatePicker.h
//  Treasure
//
//  Created by xiayiyong on 16/1/12.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFView.h"

/**
 *  TFDatePicker类型
 */
typedef NS_ENUM(NSInteger, TFDatePickerType)
{
    /**
     *  显示时间
     */
    TFDatePickerTypeTime         = 0,
    
    /**
     *  显示日期
     */
    TFDatePickerTypeDate         = 1,
    
    /**
     *  显示时间和日期
     */
    TFDatePickerTypeDateAndTime  = 2,
};

/**
 *  选择日期回调Block
 *
 *  @param date       日期
 *  @param dateString 日期字符串
 */
typedef void (^TFDatePickerBlock)(NSDate *date, NSString *dateString);

/**
 *  TFDatePicker
 */
@interface TFDatePicker : TFView

/**
 *  显示TFDatePicker
 *
 *  @param type  TFDatePicker类型
 *  @param block 选择时间回调
 */
+ (void)showWithType:(TFDatePickerType)type
               block:(TFDatePickerBlock)block;

+ (void)showDatePickerWithType:(UIDatePickerMode)mode
                       maxDate:(NSDate *)maxDate
                       minDate:(NSDate *)minDate
                   currentDate:(NSDate *)currentDate
                  confirmBlock:(void (^)(NSDate *date, NSString *dateString))confirmBlock;

+ (instancetype)datePickerWithType:(UIDatePickerMode)mode
                           maxDate:(NSDate *)maxDate
                           minDate:(NSDate *)minDate
                       currentDate:(NSDate *)currentDate
                      confirmBlock:(void (^)(NSDate *date, NSString *dateString))confirmBlock;

@end
