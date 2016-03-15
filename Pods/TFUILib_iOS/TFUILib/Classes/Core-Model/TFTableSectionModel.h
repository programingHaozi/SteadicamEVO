//
//  TFSectionModel.h
//  TFUILib
//
//  Created by xiayiyong on 16/3/11.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFTableRowModel.h"

#pragma mark -
#pragma mark - TFTableRowModel
@protocol TFTableSectionModel <NSObject>
@end

@interface TFTableSectionModel : TFModel

/**
 *  section的title
 */
@property (nonatomic,strong) NSString *title;

/**
 *
 */
@property (nonatomic,strong) NSArray<TFTableRowModel> *dataArray;

@end
