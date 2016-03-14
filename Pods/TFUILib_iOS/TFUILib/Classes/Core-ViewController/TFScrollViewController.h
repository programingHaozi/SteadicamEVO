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

@interface TFScrollViewController : TFViewController
<
UIScrollViewDelegate
>

@property (nonatomic, strong) UIScrollView *scrollView;

-(void)showRefreshHeader;
-(void)hideRefreshHeader;
-(void)showRefreshFooter;
-(void)hideRefreshFooter;

-(void)refreshNewData;       //下拉刷新
-(void)loadNewData;          //加载第一页
-(void)loadMoreData;      //加载下一页
-(void)endLoadData;       //结束加载

@end
