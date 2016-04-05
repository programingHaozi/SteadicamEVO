//
//  TFScrollViewController.h
//  Treasure
//
//  Created by xiayiyong on 15/9/8.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "Masonry.h"
#import "TFViewController.h"
#import "MJRefresh.h"
#import "TFView.h"

@interface TFScrollViewController : TFViewController<
                                                    UIScrollViewDelegate
                                                    >

/**
 *  scrollView
 */
@property (nonatomic, strong) UIScrollView *scrollView;


/**
 *  scrollView的HeaderView
 */
@property (nonatomic, strong) TFView *headerView;

/**
 *  scrollView的Header高度
 */
@property (nonatomic, assign) CGFloat headerViewHeight;

/**
 *  显示Header
 */
- (void)showRefreshHeader;

/**
 *  隐藏Header
 */
- (void)hideRefreshHeader;

/**
 *  下拉刷新
 */
- (void)refreshNewData;

/**
 *  加载第一页
 */
- (void)loadNewData;

/**
 *  结束加载
 */
- (void)endLoadData;

@end
