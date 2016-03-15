//
//  TFWebViewModel.h
//  TFUILib
//
//  Created by xiayiyong on 15/10/29.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFModel.h"
#import <Foundation/Foundation.h>

@interface TFWebModel : TFModel

/**
 *  页面标题
 */
@property (nonatomic,strong) NSString *title;

/**
 *  H5链接
 */
@property (nonatomic,strong) NSString *url;

@end
