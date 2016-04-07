//
//  GuideViewController.m
//  SteadicamEVO
//
//  Created by Chen Hao 陈浩 on 16/3/30.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import "GuideViewController.h"
#import "GuideViewCollectionCell.h"
#import "GuideViewModel.h"

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

@property (nonatomic, strong) GuideViewModel *viewModel;

@end

@implementation GuideViewController
@dynamic viewModel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark- init autolayout bind

- (void)initViews
{
    [super initViews];
    
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:99.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1];
    
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
        
        if (point.x/SCREEN_WIDTH >= 1)
        {
            [self hideLeftButton];
            [self showRightButton];
        }
        
       if (point.x/SCREEN_WIDTH == 0)
       {
            [self hideRightButton];
            [self showLeftButton];
       }
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
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
        cell.moviePath = self.viewModel.moviePathAry[indexPath.row];
//    });
    
    if (indexPath.row == 4)
    {
        [cell addSelectViewWithLeft:@"Later"
                              right:@"OK"
                              title:@"would you like to balance now?"
                              block:^(NSInteger idx) {
                                  [self back];
        }];
    }
    
    return cell;
}

@end
