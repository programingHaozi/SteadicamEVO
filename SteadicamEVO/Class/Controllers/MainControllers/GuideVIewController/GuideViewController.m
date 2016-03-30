//
//  GuideViewController.m
//  SteadicamEVO
//
//  Created by Chen Hao 陈浩 on 16/3/30.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import "GuideViewController.h"
#import "GuideViewCollectionCell.h"

@interface GuideViewController ()<
                                  UICollectionViewDataSource,
                                  UICollectionViewDelegate
                                  >
/**
 *  滚动视图
 */
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

/**
 *  标签
 */
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation GuideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

#pragma mark- init autolayout bind

- (void)initViews
{
    [super initViews];
    
    [self.collectionView registerClass:[GuideViewCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([GuideViewCollectionCell class])];
    
    self.collectionView.contentSize                    = CGSizeMake(5* SCREEN_WIDTH, 0);
    self.collectionView.bounces                        = NO;
    self.collectionView.pagingEnabled                  = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
}

- (void)autolayoutViews
{
    [super autolayoutViews];
    
    self.collectionView.collectionViewLayout = [self getCollectionFlowLayout];
}

- (void)bindData
{
    [super bindData];
    
    @weakify(self)
    [RACObserve(self.collectionView, contentOffset) subscribeNext:^(NSValue * offset) {
        
        @strongify(self)
        
        CGPoint point = [offset CGPointValue];
        
        self.pageControl.currentPage = point.x/SCREEN_WIDTH;
    }];
}

#pragma mark - CollectionView layout -

- (UICollectionViewLayout *)getCollectionFlowLayout
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize                    = CGSizeMake(SCREEN_WIDTH - 120*2, SCREEN_HEIGHT - 20 - 30 - 64);
    layout.minimumLineSpacing          = 240;
    layout.scrollDirection             = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset                = UIEdgeInsetsMake(20, 120, 30, 120);
    
    return layout;
}

#pragma mark - CollectionView delegate -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GuideViewCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GuideViewCollectionCell class]) forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor randomColor];
    
    return cell;
}

@end
