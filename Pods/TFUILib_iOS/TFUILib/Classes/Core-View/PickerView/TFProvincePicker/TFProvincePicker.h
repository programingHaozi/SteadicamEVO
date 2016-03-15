//
//  TFProvincePicker.h
//  Treasure
//
//  Created by xiayiyong on 16/1/25.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFView.h"

typedef void (^TFProvincePickerBlock)(NSString *province);

@interface TFProvincePicker : TFView

+ (void)showWithBlock:(TFProvincePickerBlock)block;

@end
