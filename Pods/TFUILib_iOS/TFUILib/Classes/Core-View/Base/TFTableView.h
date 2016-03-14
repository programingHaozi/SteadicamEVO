//
//  TFTableView.h
//  TFUILib
//
//  Created by xiayiyong on 16/1/12.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFButton.h"
#import <MJRefresh.h>

@class TFTableViewCell;

/**
 *  tableview基类
 */
@interface TFTableView : UITableView<UITableViewDataSource, UITableViewDelegate>

#pragma mark -  辅助属性
@property (nonatomic, strong) NSDictionary *requestBody;
@property (nonatomic, strong) UINavigationController *navigationController;


#pragma mark - 计算高度
/**
 默认自动重用标识符
 */
@property (nonatomic, strong) NSString *defaultReusedIdentifier;

/**
 *  根据数据源 刷新默认Cell的标识符合当前计算Cell  用于多类型
 *
 *  @param data 当前数据
 */
- (void)updateDefalutCell:(id)data;

/**
 计算高度字典  reusedID:cell
 */
@property (nonatomic, strong, readonly) NSDictionary *plotHeightForCells;

#pragma mark - 数据源
@property (nonatomic, strong) NSMutableArray *datas;
/**
 *  if you want show TopButton,you must set after addSubView!!
 */
@property (nonatomic, assign) BOOL willShowTopButton;   //default NO. Must set after addsubview
@property (nonatomic, assign) BOOL willAutoHideNavigation;  //default NO. if YES, -> navigationController
@property (nonatomic, assign) BOOL willAutoFooterRefresh;   //default NO.

#pragma mark - 初始化
+ (instancetype)viewForStyle:(UITableViewStyle)style frame:(CGRect)frame;
- (void)initSomething;

#pragma mark - 重写
- (void)registerNib:(UINib *)nib forCellReuseIdentifier:(NSString *)identifier;
- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier;

#pragma mark - refresh
@property (nonatomic, assign) int currectPage;

- (void)addFooterWithCallback:(void (^)())callback;
- (void)addHeaderWithCallback:(void (^)())callback;
- (void)endRefreshing;
- (void)refreshData;
- (void)reloadDataEndRefresh;
- (void)refreshData :(void (^)())completed;



@end
