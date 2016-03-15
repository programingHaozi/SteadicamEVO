//
//  UITextField+LimitLength.h
//  TextLengthLimitDemo
//
//  Created by xiayiyong on 15/7/1.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (LimitLength)

/**
 *  限制UItextfield输入长度
 *
 *  @param length 限制输入长度
 */
- (void)limitTextLength:(int)length;

@end
