//
//  TFCollectionViewController.h
//  Treasure
//
//  Created by xiayiyong on 15/9/8.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFViewController.h"
#import "MJRefresh.h"
#import "Masonry.h"

@interface TFCollectionViewController : TFViewController<
                                                        UICollectionViewDataSource,
                                                        UICollectionViewDelegate
                                                        >

/**
 *  collectionView
 */
@property (nonatomic,strong) UICollectionView *collectionView;

/**
 *  collectionView的HeaderView
 */
@property (nonatomic, strong) UIView *headerView;

/**
 *  collectionView的FooterView
 */
@property (nonatomic, strong) UIView *footerView;

/**
 *  collectionView的Header高度
 */
@property (nonatomic, assign) CGFloat headerViewHeight;

/**
 *  collectionView的Footer高度
 */
@property (nonatomic, assign) CGFloat footerViewHeight;

/**
 *  是否需要使用JSON文件模板
 */
@property (nonatomic, assign) BOOL isUseTemplate;

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
 *  加载第一页
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
