//
//  TFCollectionViewController.m
//  Treasure
//
//  Created by xiayiyong on 15/9/8.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFBaseLib.h"
#import "TFCollectionViewController.h"
#import "TFCollectionViewCell.h"

@implementation TFCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.collectionView];
    
    WS(weakSelf)
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(super.view).with.insets(UIEdgeInsetsMake(weakSelf.top, 0, 0, 0));
        
    }];
    
    [self.collectionView registerClass:[TFCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([TFCollectionViewCell class])];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    
    NSString *cellClassName   = [NSStringFromClass([self class]) stringByReplacingOccurrencesOfString:@"ViewController" withString:@"ViewCell"];
    
    Class cellClass = NSClassFromString(cellClassName);
    if (cellClass)
    {
        [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:cellClassName];
    }
    
    [self registerCell];
}

#pragma mark- init autolayout bind

- (void)registerCell
{
    
}

#pragma mark -  UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark -  对上拉和下拉控件操作

- (void)showRefreshHeader
{
    self.collectionView.mj_header.hidden=NO;
}

- (void)hideRefreshHeader
{
    self.collectionView.mj_header.hidden=YES;
}

- (void)showRefreshFooter
{
    self.collectionView.mj_footer.hidden=NO;
}

- (void)hideRefreshFooter
{
    self.collectionView.mj_footer.hidden=YES;
}

#pragma mark -  加载数据方法

- (void)refreshNewData
{
    [self.collectionView.mj_header beginRefreshing];
}

- (void)loadNewData
{
    
}

- (void)loadMoreData
{
    
}

- (void)endLoadData
{
    [super endLoadData];
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}

#pragma mark -  get set

- (UICollectionViewLayout *)list_CollectionViewLayout
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize                    = CGSizeMake(100, 100);
    layout.minimumInteritemSpacing     = 5;
    layout.minimumLineSpacing          = 5;
    
    return layout;
}

- (UICollectionView *)collectionView
{
    if(_collectionView == nil)
    {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)[self list_CollectionViewLayout];
        
        _collectionView                 = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.dataSource      = self;
        _collectionView.delegate        = self;

        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.backgroundView  = UIView.new;
        
        [_collectionView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
        _collectionView.showsVerticalScrollIndicator   = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        _collectionView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        
        _collectionView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        _collectionView.mj_footer.automaticallyHidden = NO;
        _collectionView.mj_header.hidden              = YES;
        _collectionView.mj_footer.hidden              = YES;
    }
    
    return _collectionView;
}

@end
