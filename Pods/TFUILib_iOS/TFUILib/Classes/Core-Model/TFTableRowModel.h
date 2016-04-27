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
 *  action
 */
@property (nonatomic,strong) NSString *action;

/**
 *  附加参数
 */
@property (nonatomic, strong) NSString *parameter;

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

/**
 *  title
 */
@property (nonatomic,strong) NSString *title;

/**
 *  content
 */
@property (nonatomic,strong) NSString *content;

/**
 *  icon
 */
@property (nonatomic,strong) NSString *icon;

/**
 *  webModel
 */
@property (nonatomic, strong) id webModel;

@end
