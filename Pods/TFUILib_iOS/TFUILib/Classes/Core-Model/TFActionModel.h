//
//  TFActionModel.h
//  TFUILib
//
//  Created by xiayiyong on 16/1/14.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFModel.h"

@interface TFActionModel : TFModel

/**
 *  action
 */
@property (nonatomic,strong) NSString *action;

/**
 *  附加参数
 */
@property (nonatomic, strong) NSString *parameter;

/**
 *  是否原生
 */
@property (nonatomic, assign) BOOL isNative;

@end