//
//  TFTableRowModel.h
//  TFUILib
//
//  Created by xiayiyong on 16/3/11.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFModel.h"

#pragma mark -
#pragma mark - TFTableRowModel
@protocol TFTableRowModel <NSObject>
@end

@interface TFTableRowModel : TFModel

/**
 *  vc
 */
@property (nonatomic,strong) NSString *vc;

/**
 *  method
 */
@property (nonatomic,strong) NSString *method;

/**
 *  url
 */
@property (nonatomic,strong) NSString *url;

@end
