//
//  TFTextField.h
//  TFUILib
//
//  Created by xiayiyong on 16/1/12.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextField+Category.h"

/**
 *  输入限制类型
 */
typedef NS_ENUM(NSUInteger, TFTextfieldInputType)
{
    /**
     *  字母和数组
     */
    TFTextfieldInputTypeLettersAndNumbersOnly = 0,
    /**
     *  大写
     */
    TFTextfieldInputTypeAllCharacters,
    /**
     *  英文汉字
     */
    TFTextfieldInputTypeAllCharactersAndNoPunctuation
};

@interface TFTextField : UITextField

/**
 *  文本离左边框的距离
 */
@property (nonatomic, strong) NSNumber *leftMargin;

/**
 *  底边颜色
 */
@property (nonatomic, strong) UIColor *bottomBorderColor;

/**
 *  text最大长度
 */
@property (nonatomic, assign) NSUInteger maxLength;

/**
 *  输入限制类型
 */
@property (nonatomic, assign) TFTextfieldInputType inputType;


/**
 *  初始化Textfield
 *
 *  @param frame       尺寸
 *  @param text        输入文字
 *  @param placeholder 占位符
 *
 *  @return Textfield
 */
- (instancetype)initWithFrame:(CGRect)frame
                         text:(NSString *)text
                  placeholder:(NSString *)placeholder;

@end
