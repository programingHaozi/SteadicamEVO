//
//  UITextField+Placeholder.m
//  Treasure
//
//  Created by xiayiyong on 15/7/1.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "UITextField+Placeholder.h"

@implementation UITextField (Placeholder)

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
  [self setValue:placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont
{
  [self setValue:placeholderFont forKeyPath:@"_placeholderLabel.font"];
}

@end
