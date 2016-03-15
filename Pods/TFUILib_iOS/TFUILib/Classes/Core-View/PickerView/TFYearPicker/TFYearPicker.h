//
//  TFYearPicker.h
//  TFUILib
//
//  Created by xiayiyong on 16/1/12.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFView.h"

typedef void (^TFYearPickerBlock)(NSString *year);

@interface TFYearPicker : TFView

+ (void)showWithBlock:(TFYearPickerBlock)block;

@end

