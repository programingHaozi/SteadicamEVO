//
//  TFScrollViewController.m
//  Treasure
//
//  Created by xiayiyong on 15/9/8.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFScrollViewController.h"

@implementation TFScrollViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.scrollView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(super.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

-(void)showRefreshHeader
{
    self.scrollView.mj_header.hidden=NO;
}

-(void)hideRefreshHeader
{
    self.scrollView.mj_header.hidden=YES;
}

-(void)showRefreshFooter
{
    self.scrollView.mj_footer.hidden=NO;
}

-(void)hideRefreshFooter
{
    self.scrollView.mj_footer.hidden=YES;
}

-(void)refreshNewData
{
    [self.scrollView.mj_header beginRefreshing];
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
    [self.scrollView.mj_header endRefreshing];
    [self.scrollView.mj_footer endRefreshing];
}

-(UIScrollView *)tableView
{
    if (_scrollView==nil)
    {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        //_scrollView.frame =CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        //_scrollView.frame=self.view.bounds;
        _scrollView.delegate = self;
        
        _scrollView.backgroundColor = [UIColor whiteColor];
        [_scrollView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
        _scrollView.showsVerticalScrollIndicator=NO;
        _scrollView.showsHorizontalScrollIndicator=NO;
        
        _scrollView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        _scrollView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        _scrollView.mj_footer.automaticallyHidden = NO;
        _scrollView.mj_header.hidden=YES;
        _scrollView.mj_footer.hidden=YES;
    }
    
    return _scrollView;
}


@end
