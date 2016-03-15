//
//  TFTableViewController.m
//  Treasure
//
//  Created by xiayiyong on 15/7/2.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFTableViewController.h"
#import "UIView+Category.h"
#import "TFTableViewCell.h"
#import "TFActionModel.h"
#import "TFBaseMacro+Color.h"
#import "TFUIUtil.h"
#import "TFView.h"
#import "TFLabel.h"

@interface TFTableViewController ()

@property (nonatomic,assign) UITableViewStyle style;

@end

@implementation TFTableViewController

- (instancetype) init
{
    self = [self initWithStyle:UITableViewStyleGrouped];
    
    return self;
}

- (instancetype) initWithStyle:(UITableViewStyle)style
{
    if(!(self  = [super init])) return nil;
    self.style = style;
    self.headerViewHeight=0.1;
    self.footerViewHeight=0.1;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(super.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [self registerCell];
}

#pragma mark- init autolayout bind

- (void)initViews
{
    NSString *className=NSStringFromClass([self class]);
    if (![className isEqualToString:NSStringFromClass([TFTableViewController class])])
    {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:[NSString stringWithFormat:@"You must override %@ in %@", NSStringFromSelector(_cmd), self.class]
                                     userInfo:nil];
    }
}

- (void)autolayoutViews
{
    NSString *className=NSStringFromClass([self class]);
    if (![className isEqualToString:NSStringFromClass([TFTableViewController class])])
    {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:[NSString stringWithFormat:@"You must override %@ in %@", NSStringFromSelector(_cmd), self.class]
                                     userInfo:nil];
    }
}

- (void)bindData
{
    NSString *className=NSStringFromClass([self class]);
    if (![className isEqualToString:NSStringFromClass([TFTableViewController class])])
    {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:[NSString stringWithFormat:@"You must override %@ in %@", NSStringFromSelector(_cmd), self.class]
                                     userInfo:nil];
    }
}

- (void)registerCell
{
    NSString *className=NSStringFromClass([self class]);
    NSString *cellClassName   = [className stringByReplacingOccurrencesOfString:@"ViewController" withString:@"ViewCell"];
    Class cellClass = NSClassFromString(cellClassName);
    if (cellClass)
    {
        [self.tableView registerClass:cellClass forCellReuseIdentifier:cellClassName];
    }
    
    if (![className isEqualToString:NSStringFromClass([TFTableViewController class])])
    {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:[NSString stringWithFormat:@"You must override %@ in %@", NSStringFromSelector(_cmd), self.class]
                                     userInfo:nil];
    }
}

#pragma mark -  UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.isUseTemplate?[self.viewModel numberOfSections]:1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.isUseTemplate?[self.viewModel numberOfRowsInSection:section]:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isUseTemplate)
    {
        NSString *className=NSStringFromClass([self class]);
        NSString *cellClassName   = [className stringByReplacingOccurrencesOfString:@"ViewController" withString:@"ViewCell"];
        TFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellClassName];
        cell.data=[self.viewModel dataAtIndexPath:indexPath];
        return cell;
    }
    else
    {
        UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id data = [self.viewModel dataAtIndexPath:indexPath];
    [self handleData:data];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.isUseTemplate)
    {
       return !tf_isEmpty([self.viewModel titleAtSection:section])?44.0:0.05;
    }
    else
    {
        return 0.05;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.isUseTemplate)
    {
        TFLabel *label=[[TFLabel alloc]init];
        label.backgroundColor = [UIColor lightGrayColor];
        label.text=[self.viewModel titleAtSection:section];
        label.textColor=[UIColor blackColor];
        label.font=[UIFont systemFontOfSize:14];
        return label;
    }
    else
    {
        TFLabel *label=[[TFLabel alloc]init];
        return label;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.05;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    TFLabel *label=[[TFLabel alloc]init];
    return label;
}

#pragma mark -  对上拉和下拉控件操作

- (void)showRefreshHeader
{
    self.tableView.mj_header.hidden = NO;
}

- (void)hideRefreshHeader
{
    self.tableView.mj_header.hidden = YES;
}

- (void)showRefreshFooter
{
    self.tableView.mj_footer.hidden = NO;
}

- (void)hideRefreshFooter
{
    self.tableView.mj_footer.hidden = YES;
}

#pragma mark -  加载数据方法

- (void)refreshNewData
{
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadNewData
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in %@", NSStringFromSelector(_cmd), self.class]
                                 userInfo:nil];
}

- (void)loadMoreData
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in %@", NSStringFromSelector(_cmd), self.class]
                                 userInfo:nil];
}

- (void)endLoadData
{
    [super endLoadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark -  get set

- (UITableView *)tableView
{
    if (_tableView==nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:_style];
        _tableView.delegate                       = self;
        _tableView.dataSource                     = self;
        
        _tableView.backgroundColor                = [UIColor whiteColor];
        _tableView.backgroundView                 = UIView.new;
        _tableView.separatorStyle                 = UITableViewCellSeparatorStyleSingleLine;
        [_tableView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
        _tableView.showsVerticalScrollIndicator   = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
        _tableView.mj_footer.automaticallyHidden = NO;
        _tableView.mj_header.hidden              = YES;
        _tableView.mj_footer.hidden              = YES;
        
    }
    
    return _tableView;
}

- (UIView *)headerView
{
    if (_headerView==nil)
    {
        _headerView               = UIView.new;
        _headerView.height        = self.headerViewHeight;
        self.tableView.tableHeaderView = _headerView;
    }
    
    return _headerView;
}

- (UIView *)footerView
{
    if (_footerView==nil)
    {
        _footerView               = UIView.new;
        _footerView.height        = self.footerViewHeight;
        self.tableView.tableFooterView = _footerView;
    }
    
    return _footerView;
}

-(void)setHeaderViewHeight:(CGFloat)headerViewHeight
{
    _headerViewHeight=headerViewHeight;
    self.headerView.height    = headerViewHeight;
    self.tableView.tableHeaderView = self.headerView;
}

-(void)setFooterViewHeight:(CGFloat)footerViewHeight
{
    _footerViewHeight=footerViewHeight;
    self.footerView.height    = footerViewHeight;
    self.tableView.tableFooterView = self.footerView;
}

@end
