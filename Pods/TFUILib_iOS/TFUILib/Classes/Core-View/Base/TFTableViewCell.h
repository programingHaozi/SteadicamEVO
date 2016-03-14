//
//  TFTableViewCell.h
//  TFUILib
//
//  Created by xiayiyong on 16/1/12.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFTableView.h"

@interface TFTableViewCell : UITableViewCell

@property (nonatomic, strong) id data;
@property (nonatomic, assign) TFTableView *tableView;
@property (nonatomic, strong) id updateData;

-(CGFloat)cellHeight;
+(CGFloat)cellHeight;
/**
 *  根据data计算高度
 */
+(CGFloat)cellHeightWithData:(id)model width:(CGFloat)width;

/**
 *  更新cell
 *
 *  @param data
 */
- (void)updateCellForData:(id)data;
@end

