//
//  DataUpload.h
//  TorqueSDK
//
//  Created by huxianchen on 15/3/2.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import "BaseQueryModel.h"

@interface DataUpload : BaseQueryModel

/**
 *  数据内容
 */
@property (nonatomic, copy,readonly) NSString *jsonStr;

/**
 *  类型, action, trips,speedup,exam_reports
 */
@property (nonatomic,copy,readonly) NSString *type;

@end
