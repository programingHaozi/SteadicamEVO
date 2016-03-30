//
//  TFTableViewCell.h
//  TFUILib
//
//  Created by xiayiyong on 16/1/12.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFTableView.h"
#import "TFModel.h"

@interface TFTableViewCell : UITableViewCell

/**
 *  cell数据
 */
@property (nonatomic, strong) id data;

/**
 *  cell所属表单
 */
@property (nonatomic, assign) TFTableView *tableView;

/**
 *  初始化视图
 */
- (void)initViews;

/**
 *  自动布局视图
 */
- (void)autolayoutViews;

/**
 *  绑定数据
 */
- (void)bindData;

/**
 *  返回cell高度
 *
 *  @return cell高度
 */
-(CGFloat)cellHeight;

/**
 *  获取cell高度
 *
 *  @return cell高度
 */
+(CGFloat)cellHeight;

/**
 *  获取reusableIdentifier
 *
 *  @return reusableIdentifier
 */
+(NSString*)reusableIdentifier;

/**
 *  根据data计算高度
 *
 *  @param model cell数据
 *  @param width cell宽度
 *
 *  @return cell高度
 */
+(CGFloat)cellHeightWithData:(id)model width:(CGFloat)width;


@end

