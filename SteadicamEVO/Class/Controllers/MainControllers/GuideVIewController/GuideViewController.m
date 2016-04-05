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
        
        self.pageControl.hidden = point.x/SCREEN_WIDTH == 4;
    }];
}

#pragma mark - CollectionView layout -

- (UICollectionViewLayout *)getCollectionFlowLayout
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize                    = CGSizeMake(304, 204);
    layout.minimumLineSpacing          = (SCREEN_WIDTH - 304);
    layout.scrollDirection             = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset                = UIEdgeInsetsMake(20, (SCREEN_WIDTH - 304)/2, 30, (SCREEN_WIDTH - 304)/2);
    
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
    
    [cell removeSelectView];
    
    if (indexPath.row == 4)
    {
        [cell addSelectViewWithLeft:@"later"
                              right:@"ok"
                              title:@"would you like to balance now?"
                              block:^(NSInteger idx) {
            NSLog(@"%ld",(long)idx);
        }];
    }
    
    return cell;
}

@end
