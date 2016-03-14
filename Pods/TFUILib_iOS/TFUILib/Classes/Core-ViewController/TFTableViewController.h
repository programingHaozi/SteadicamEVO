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

@interface TFTableViewController : TFViewController
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, readonly) UITableViewStyle style;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UIView *tableFooterView;

@property (nonatomic, assign) CGFloat tableHeaderHeight;
@property (nonatomic, assign) CGFloat tableFooterHeight;

-(instancetype) initWithStyle:(UITableViewStyle)style;

-(void)showRefreshHeader;
-(void)hideRefreshHeader;
-(void)showRefreshFooter;
-(void)hideRefreshFooter;

-(void)refreshNewData;       //下拉刷新
-(void)loadNewData;          //加载第一页  无下拉效果
-(void)loadMoreData;      //加载下一页
-(void)endLoadData;       //结束加载

@end
