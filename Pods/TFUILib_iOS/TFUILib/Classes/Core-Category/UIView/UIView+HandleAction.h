//
//  TFView+HandleAction.h
//  TFUILib
//
//  Created by xiayiyong on 16/4/22.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFTableRowModel.h"
#import <UIKit/UIKit.h>

@interface UIView (HandleAction)

/**
 *  统一数据处理
 *
 *  @param data 数据
 */
-(void) handleData:(TFTableRowModel*)data;

/**
 *  统一数据处理
 *
 *  @param data 数据
 *  @param completion 处理不了的通过回调函数提交给APP去处理
 */
-(void) handleData:(TFTableRowModel*)data completion:(void (^)(TFTableRowModel*))completion;

@end
