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
#import "GifScrollView.h"

@interface GuideViewController ()

@property (weak, nonatomic) IBOutlet GifScrollView *guideScrollView;

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
    
        self.guideScrollView.showChoose = YES;
        self.guideScrollView.dataArray = self.viewModel.moviePathAry;
}

- (void)autolayoutViews
{
    [super autolayoutViews];
}

- (void)bindData
{
    [super bindData];
    
    @weakify(self)
    [RACObserve(self.guideScrollView, contentOffset) subscribeNext:^(NSValue * offset) {
        
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




@end
