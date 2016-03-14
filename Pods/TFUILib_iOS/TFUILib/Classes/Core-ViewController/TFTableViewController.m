//
//  TFTableViewController.m
//  Treasure
//
//  Created by xiayiyong on 15/7/2.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFTableViewController.h"
#import "UIView+Category.h"

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
    if(!(self = [super init])) return nil;
    self.style = style;
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

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.05;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.05;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    //config the cell
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)showRefreshHeader
{
    self.tableView.mj_header.hidden=NO;
}

-(void)hideRefreshHeader
{
    self.tableView.mj_header.hidden=YES;
}

-(void)showRefreshFooter
{
    self.tableView.mj_footer.hidden=NO;
}

-(void)hideRefreshFooter
{
    self.tableView.mj_footer.hidden=YES;
}

-(void)refreshNewData
{
    [self.tableView.mj_header beginRefreshing];
}

-(void)loadNewData
{
    
}

-(void)loadMoreData
{
    
}

-(void)endLoadData
{
    [super endLoadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

-(UITableView *)tableView
{
    if (_tableView==nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:_style];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.backgroundView = UIView.new;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
        _tableView.showsVerticalScrollIndicator=NO;
        _tableView.showsHorizontalScrollIndicator=NO;
        
        _tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        _tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        _tableView.mj_footer.automaticallyHidden = NO;
        _tableView.mj_header.hidden=YES;
        _tableView.mj_footer.hidden=YES;
        
    }
    
    return _tableView;
}

-(UIView *)tableHeaderView
{
    if (_tableHeaderView==nil)
    {
        _tableHeaderView=UIView.new;
        _tableHeaderView.height=0.1;
        self.tableView.tableHeaderView=_tableHeaderView;
    }
    
    return _tableHeaderView;
}

-(UIView *)tableFooterView
{
    if (_tableFooterView==nil)
    {
        _tableFooterView=UIView.new;
        _tableFooterView.height=0.1;
        self.tableView.tableFooterView=_tableFooterView;
    }
    
    return _tableFooterView;
}

-(void)setTableHeaderHeight:(CGFloat)height
{
    self.tableHeaderView.height=height;
    self.tableView.tableHeaderView=self.tableHeaderView;
}

-(void)setTableFooterHeight:(CGFloat)height
{
    self.tableFooterView.height=height;
    self.tableView.tableFooterView=self.tableFooterView;
}

@end
