//
//  TFCustomListAlertView.h
//  Orange
//
//  Created by Chen Yiliang on 3/30/15.
//  Copyright (c) 2015 Chexiang. All rights reserved.
//

#import "TFCustomAlertView.h"
#import "TFCustomListAlertViewProtocol.h"
#import "TFView.h"
#import "TFLabel.h"
#import "TFImageView.h"

@class TFCustomListAlertView, TFCustomListAlertContentView;

/**
 *  TFCustomListAlertViewDelegate
 */
@protocol TFCustomListAlertViewDelegate <NSObject>

/**
 *  TFCustomListAlertView点击回调
 *
 *  @param alert TFCustomListAlertView
 *  @param item  点击项
 *  @param index 点击项Index
 */
- (void)listAlertView:(TFCustomListAlertView *)alert
      didSelectedItem:(id)item
              atIndex:(NSInteger)index;

@end

/**
 *  TFCustomListAlertViewDataSource
 */
@protocol TFCustomListAlertViewDataSource <NSObject>

@optional

/**
 *  生成UITableViewCell
 *
 *  @param tableView tableView
 *  @param indexPath indexPath
 *
 *  @return UITableViewCell
 */
- (UITableViewCell *)listAlertTableView:(UITableView *)tableView
                        cellAtIndexPath:(NSIndexPath *)indexPath;

@end

/**
 *  TFCustomListAlertView
 */
@interface TFCustomListAlertView : TFCustomAlertView <UITableViewDelegate>

/**
 *  是否允许选择cell
 */
@property (nonatomic, assign) BOOL allowsSelection;

/**
 *  是否显示关闭按钮
 */
@property (nonatomic, assign) BOOL showCloseButton;

/**
 *  代理
 */
@property (nonatomic, weak) id<TFCustomListAlertViewDelegate> delegate;

/**
 *  初始化TFCustomListAlertView
 *
 *  @param title     标题
 *  @param dataArray 数据源
 *  @param delegate  代理
 *
 *  @return TFCustomListAlertView
 */
- (instancetype)initWithTitle:(NSString *)title
                    dataArray:(NSArray *)dataArray
                     delegate:(id)delegate;

/**
 *  初始化TFCustomListAlertView
 *
 *  @param title         标题
 *  @param dataArray     数据源
 *  @param delegate      代理
 *  @param selectedIndex 选择Index
 *
 *  @return TFCustomListAlertView
 */
- (instancetype)initWithTitle:(NSString *)title
                    dataArray:(NSArray *)dataArray
                     delegate:(id)delegate
                selectedIndex:(NSUInteger)selectedIndex;

@end

/**
 *  TFCustomListAlertContentView
 */
@interface TFCustomListAlertContentView : TFView <UITableViewDataSource>

/**
 *  标题Label
 */
@property (nonatomic, weak) IBOutlet TFLabel *titleLabel;

/**
 *  关闭按钮
 */
@property (nonatomic, weak) IBOutlet UIButton *closeButton;

/**
 *  按钮容器视图
 */
@property (nonatomic, weak) IBOutlet TFView *buttonContainerView;

/**
 *  分隔视图
 */
@property (nonatomic, weak) IBOutlet TFImageView *seperatorView;

/**
 *  TableView
 */
@property (nonatomic, weak) IBOutlet UITableView *tableView;

/**
 *  数据源
 */
@property (nonatomic, strong) NSArray *dataArray;

/**
 *  选择的Index
 */
@property (nonatomic, assign) NSUInteger selectedIndex;

/**
 *  数据源代理
 */
@property (nonatomic, weak) id<TFCustomListAlertViewDataSource> dataSource;

/**
 *  初始化TFCustomListAlertContentView
 *
 *  @param title         标题
 *  @param dataArray     数据数组
 *  @param dataSource    数据源
 *  @param selectedIndex 选择Index
 *
 *  @return TFCustomListAlertContentView
 */
+ (instancetype)contentViewWithTitle:(NSString *)title
                           dataArray:(NSArray *)dataArray
                          dataSource:(id)dataSource
                       selectedIndex:(NSUInteger)selectedIndex;

@end
