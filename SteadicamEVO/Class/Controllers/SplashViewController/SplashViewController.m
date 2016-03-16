//
//  SplashViewController.m
//  Orange
//
//  Created by limingchen on 14/12/25.
//  Copyright (c) 2014年 Chexiang. All rights reserved.
//

#import "SplashViewController.h"

@interface SplashViewController ()

@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *imageIphone4Array;

@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

/**
 *  跳过按钮
 */
@property (nonatomic, strong) UIButton *dismissButton;

/**
 *  点击进入按钮
 */
@property (nonatomic, strong) UIButton *gotoButton;

@end

@implementation SplashViewController


- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initViews];
}

- (void)initViews
{
    self.imageArray = @[
                    @"splash_1.png",
                    @"splash_2.png",
                    @"splash_3.png",
                    @"splash_4.png",
                    @"splash_5.png"
                    ];
    
    self.imageIphone4Array = @[
                           @"splash_iphone4_1.png",
                           @"splash_iphone4_2.png",
                           @"splash_iphone4_3.png",
                           @"splash_iphone4_4.png",
                           @"splash_iphone4_5.png"
                           ];
    
    [self.view addSubview:self.mainScrollView];
    [self.view addSubview:self.pageControl];
    [self.view addSubview:self.dismissButton];
    [self.view addSubview:self.gotoButton];

    
    self.dismissButton.centerY=self.pageControl.centerY;
    self.gotoButton.centerY=self.pageControl.centerY;
    
    self.pageControl.hidden = NO;
    self.dismissButton.hidden = NO;
    self.gotoButton.hidden = YES;
    
    for (int i = 0; i < self.imageArray.count; i++)
    {
        TFImageView *imageView = [[TFImageView alloc] init];
        imageView.frame = CGRectMake(SCREEN_WIDTH * i , 0 , SCREEN_WIDTH, SCREEN_HEIGHT);
        imageView.image = IMAGE(TARGET_IPHONE_4?self.imageIphone4Array[i]:self.imageArray[i]);
        imageView.userInteractionEnabled = YES;
        [self.mainScrollView addSubview:imageView];
    }
}

- (void)autolayoutViews
{
    
}

- (void)bindData
{
    
}

#pragma mark -
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
    self.pageControl.currentPage = index;
    if (self.pageControl.currentPage == self.imageArray.count - 1)
    {
        self.pageControl.hidden = YES;
        self.dismissButton.hidden = YES;
        self.gotoButton.hidden = NO;
    }
    else
    {
        self.pageControl.hidden = NO;
        self.dismissButton.hidden = NO;
        self.gotoButton.hidden = YES;

    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

#pragma mark -- Uitility
- (void)pageTurning:(UIPageControl *)sender
{
    self.pageControl.currentPage = self.mainScrollView.contentOffset.x / self.mainScrollView.frame.size.width;
    [UIView animateWithDuration:0 animations:^{
        self.mainScrollView.contentOffset = CGPointMake(self.pageControl.currentPage * self.mainScrollView.frame.size.width, 0);
    }];
}

//点击跳过、立即体验
- (void)dismissButtonClickAction:(id)sender
{
    if (self.block)
    {
        self.block(nil);
    }
}

#pragma mark -- setter getter
-(UIScrollView *)mainScrollView
{
    if (_mainScrollView==nil)
    {
        _mainScrollView = [[UIScrollView alloc] init];
        _mainScrollView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.imageArray.count, SCREEN_HEIGHT);
        _mainScrollView.contentOffset = CGPointMake(0, 0);
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.maximumZoomScale = 2;
        _mainScrollView.minimumZoomScale = 1;
        _mainScrollView.bounces = NO;
        _mainScrollView.delegate = self;
        _mainScrollView.backgroundColor = [UIColor clearColor];
    }
    
    return _mainScrollView;
}

-(UIPageControl *)pageControl
{
    if (_pageControl==nil)
    {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.center = CGPointMake(self.view.center.x, SCREEN_HEIGHT - 30);
        _pageControl.numberOfPages = self.imageArray.count;
        _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
        _pageControl.pageIndicatorTintColor = HEXCOLOR(0x999999, 1);
        [_pageControl addTarget:self action:@selector(pageTurning:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _pageControl;
}

-(UIButton *)dismissButton
{
    if (_dismissButton==nil)
    {
        _dismissButton = [[UIButton alloc]init];
        _dismissButton.frame = CGRectMake(SCREEN_WIDTH - 100, SCREEN_HEIGHT - 54, 100, 44);
        _dismissButton.titleLabel.font = FONT(14);
        [_dismissButton setTitleColor:HEXCOLOR(0x666666, 1) forState:UIControlStateNormal];
        [_dismissButton setTitleColor:HEXCOLOR(0x999999, 1) forState:UIControlStateHighlighted];
        [_dismissButton setTitle:@"跳过" forState:UIControlStateNormal];
        [_dismissButton setImage:IMAGE(@"icon_arrow_splash") forState:UIControlStateNormal];
        _dismissButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, 80, 0.0, 0);
        _dismissButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 15, 0.0, 0);
        [_dismissButton addTarget:self action:@selector(dismissButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _dismissButton;
}

-(UIButton *)gotoButton
{
    if (_gotoButton == nil)
    {
        _gotoButton = [[UIButton alloc]init];
        _gotoButton.frame = CGRectMake(20, SCREEN_HEIGHT - 54, SCREEN_WIDTH - 40, 44);
        _gotoButton.titleLabel.font = FONT(14);
        [_gotoButton setTitleColor:HEXCOLOR(0X03A9F4,  1) forState:UIControlStateNormal];
        [_gotoButton setTitleColor:HEXCOLOR(0X0077DD,  1) forState:UIControlStateHighlighted];
        [_gotoButton setTitle:@"立即体验" forState:UIControlStateNormal];
        [_gotoButton setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0XFFFFFF,  1)] forState:UIControlStateNormal];
        [_gotoButton setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0XEEEEEE,  1)] forState:UIControlStateHighlighted];
        [_gotoButton addTarget:self action:@selector(dismissButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        _gotoButton.layer.masksToBounds=YES;
        _gotoButton.layer.cornerRadius=_gotoButton.frame.size.height/2;
        _gotoButton.layer.borderColor=HEXCOLOR(0XEFEFF4,  1).CGColor;
        _gotoButton.layer.borderWidth=1;
        _gotoButton.backgroundColor = [UIColor redColor];

    }
    
    return _gotoButton;
}

@end
