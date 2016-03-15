//
//  TFTableViewController.h
//  Treasure
//
//  Created by xiayiyong on 15/7/2.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFViewController.h"
#import "Masonry.h"
#import "MJRefresh.h"
#import "TFTableView.h"

@interface TFTableViewController : TFViewController<
                                                    UITableViewDelegate,
                                                    UITableViewDataSource
                                                    >

/**
 *  TableView风格
 */
@property (nonatomic, readonly) UITableViewStyle style;

/**
 *  tableView
 */
@property (nonatomic, strong) UITableView *tableView;

/**
 *  tableView的HeaderView
 */
@property (nonatomic, strong) UIView *headerView;

/**
 *  tableView的FooterView
 */
@property (nonatomic, strong) UIView *footerView;

/**
 *  tableView的Header高度
 */
@property (nonatomic, assign) CGFloat headerViewHeight;

/**
 *  tableView的Footer高度
 */
@property (nonatomic, assign) CGFloat footerViewHeight;

/**
 *  是否需要使用JSON文件模板
 */
@property (nonatomic, assign) BOOL isUseTemplate;

/**
 *  初始化TableView
 *
 *  @param style TableView风格
 *
 *  @return TableView
 */
- (instancetype)initWithStyle:(UITableViewStyle)style;

/**
 *  显示Header
 */
- (void)showRefreshHeader;

/**
 *  隐藏Header
 */
- (void)hideRefreshHeader;

/**
 *  显示Footer
 */
- (void)showRefreshFooter;

/**
 *  隐藏Footer
 */
- (void)hideRefreshFooter;

/**
 *  下拉刷新
 */
- (void)refreshNewData;

/**
 *  加载第一页  无下拉效果
 */
- (void)loadNewData;

/**
 *  加载下一页
 */
- (void)loadMoreData;

/**
 *  结束加载
 */
- (void)endLoadData;

@end
