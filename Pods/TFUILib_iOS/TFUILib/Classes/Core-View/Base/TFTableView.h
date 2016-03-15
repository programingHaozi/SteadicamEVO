//
//  TFTableView.h
//  TFUILib
//
//  Created by xiayiyong on 16/1/12.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableView+Category.h"

/**
 *  tableview基类
 */
@interface TFTableView : UITableView

/**
 *  注册cell
 *
 *  @param cellClass
 */
-(void)registerCell:(Class)cellClass;

@end
