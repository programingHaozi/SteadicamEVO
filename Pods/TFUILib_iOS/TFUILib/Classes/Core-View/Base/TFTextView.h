//
//  TFTextView.h
//  TFUILib
//
//  Created by xiayiyong on 16/1/12.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextView+Category.h"

/**
 *  TextView的基类 实现placeholder
 */
@interface TFTextView : UITextView

/**
 *  text最大长度
 */
@property (nonatomic, assign) NSUInteger maxLength;

@end
