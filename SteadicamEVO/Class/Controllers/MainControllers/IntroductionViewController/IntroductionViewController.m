//
//  IntroductionViewController.m
//  SteadicamEVO
//
//  Created by Chen Hao 陈浩 on 16/3/30.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import "IntroductionViewController.h"
#import "IntroductionViewCollectionCell.h"

@interface IntroductionViewController ()<
                                        UICollectionViewDataSource,
                                        UICollectionViewDelegate
                                        >

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation IntroductionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self hideRightButton];
}

- (void)initViews
{
    [super initViews];
    
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:99.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1];
    
    [self.collectionView registerClass:[IntroductionViewCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([IntroductionViewCollectionCell class])];
    
    self.collectionView.contentSize                    = CGSizeMake(4* SCREEN_WIDTH, 0);
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
    layout.itemSize                    = CGSizeMake(304, 204);
    layout.minimumLineSpacing          = (SCREEN_WIDTH - 304);
    layout.scrollDirection             = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset                = UIEdgeInsetsMake(20, (SCREEN_WIDTH - 304)/2, 30, (SCREEN_WIDTH - 304)/2);
    
    return layout;
}

#pragma mark - CollectionView delegate -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IntroductionViewCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([IntroductionViewCollectionCell class]) forIndexPath:indexPath];
    
    return cell;
}



@end
