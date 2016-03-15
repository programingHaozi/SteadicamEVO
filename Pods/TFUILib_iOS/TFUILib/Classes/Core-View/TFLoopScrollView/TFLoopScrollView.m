//
//  TFLoopScrollView.m
//  TFLoopScrollView
//
//  Created by aier on 15-3-22.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import "TFLoopScrollView.h"
#import "TFLoopScrollViewCell.h"
#import "UIView+SDExtension.h"
#import "TFPageControl.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"

NSString * const ID = @"cycleCell";

@interface TFLoopScrollView () <UICollectionViewDataSource, UICollectionViewDelegate>


@property (nonatomic, weak) UICollectionView *collectionView; // 显示图片的collectionView
@property (nonatomic, weak) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) NSInteger totalItemsCount;
@property (nonatomic, weak) UIControl *pageControl;

@property (nonatomic, weak) UIImageView *backgroundImageView; // 当imageURLs为空时的背景图

@property (nonatomic, assign) NSInteger networkFailedRetryCount;

@end

@implementation TFLoopScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initialization];
        [self setupcollectionView];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initialization];
    [self setupcollectionView];
}

- (void)initialization
{
    _pageControlAliment = TFLoopScrollViewPageContolAlimentCenter;
    _autoScrollTimeInterval = 2.0;
    _titleLabelTextColor = [UIColor whiteColor];
    _titleLabelTextFont= [UIFont systemFontOfSize:14];
    _titleLabelBackgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _titleLabelHeight = 30;
    _autoScroll = YES;
    _infiniteLoop = YES;
    _showPageControl = YES;
    _pageControlDotSize = CGSizeMake(10, 10);
    _pageControlStyle = TFLoopScrollViewPageContolStyleClassic;
    _hidesForSinglePage = YES;
    _currentPageDotColor = [UIColor whiteColor];
    _pageDotColor = [UIColor lightGrayColor];
    _bannerImageViewContentMode = UIViewContentModeScaleToFill;
    
    _pageControlDistanceFormBottom=10;
    
    self.backgroundColor = [UIColor lightGrayColor];
    
}

+ (instancetype)initWithFrame:(CGRect)frame imagesGroup:(NSArray *)imagesGroup
{
    TFLoopScrollView *cycleScrollView = [[self alloc] initWithFrame:frame];
    cycleScrollView.imagesGroup = [NSMutableArray arrayWithArray:imagesGroup];
    return cycleScrollView;
}

+ (instancetype)initWithFrame:(CGRect)frame imagesGroup:(NSArray *)imagesGroup shouldInfiniteLoop:(BOOL)infiniteLoop
{
    TFLoopScrollView *cycleScrollView = [[self alloc] initWithFrame:frame];
    cycleScrollView.infiniteLoop = infiniteLoop;
    cycleScrollView.imagesGroup = [NSMutableArray arrayWithArray:imagesGroup];
    return cycleScrollView;
}

+ (instancetype)initWithFrame:(CGRect)frame delegate:(id<TFLoopScrollViewDelegate>)delegate placeholderImage:(UIImage *)placeholderImage
{
    TFLoopScrollView *cycleScrollView = [[self alloc] initWithFrame:frame];
    cycleScrollView.delegate = delegate;
    cycleScrollView.placeholderImage = placeholderImage;
    
    return cycleScrollView;
}

// 设置显示图片的collectionView
- (void)setupcollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _flowLayout = flowLayout;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    [collectionView registerClass:[TFLoopScrollViewCell class] forCellWithReuseIdentifier:ID];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self addSubview:collectionView];
    _collectionView = collectionView;
}

#pragma mark - properties

- (void)setPlaceholderImage:(UIImage *)placeholderImage
{
    _placeholderImage = placeholderImage;
    
    if (!self.backgroundImageView)
    {
        UIImageView *bgImageView = [UIImageView new];
        bgImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self insertSubview:bgImageView belowSubview:self.collectionView];
        self.backgroundImageView = bgImageView;
    }
    
    self.backgroundImageView.image = placeholderImage;
}

- (void)setPageControlDotSize:(CGSize)pageControlDotSize
{
    _pageControlDotSize = pageControlDotSize;
    [self setupPageControl];
    if ([self.pageControl isKindOfClass:[TFPageControl class]])
    {
        TFPageControl *pageContol = (TFPageControl *)_pageControl;
        pageContol.dotSize = pageControlDotSize;
    }
}

- (void)setShowPageControl:(BOOL)showPageControl
{
    _showPageControl = showPageControl;
    
    _pageControl.hidden = !showPageControl;
}

- (void)setCurrentPageDotColor:(UIColor *)currentPageDotColor
{
    _currentPageDotColor = currentPageDotColor;
    if ([self.pageControl isKindOfClass:[TFPageControl class]])
    {
        TFPageControl *pageControl = (TFPageControl *)_pageControl;
        pageControl.dotColor = currentPageDotColor;
    }
    else
    {
        UIPageControl *pageControl = (UIPageControl *)_pageControl;
        pageControl.currentPageIndicatorTintColor = currentPageDotColor;
    }
}

- (void)setPageDotColor:(UIColor *)pageDotColor
{
    _pageDotColor = pageDotColor;
    
    if ([self.pageDotColor isKindOfClass:[UIPageControl class]])
    {
        UIPageControl *pageControl = (UIPageControl *)_pageControl;
        pageControl.pageIndicatorTintColor = pageDotColor;
    }
}

- (void)setCurrentPageDotImage:(UIImage *)currentPageDotImage
{
    _currentPageDotImage = currentPageDotImage;
    
    [self setCustomPageControlDotImage:currentPageDotImage isCurrentPageDot:YES];
}

- (void)setPageDotImage:(UIImage *)pageDotImage
{
    _pageDotImage = pageDotImage;
    
    [self setCustomPageControlDotImage:pageDotImage isCurrentPageDot:NO];
}

- (void)setCustomPageControlDotImage:(UIImage *)image isCurrentPageDot:(BOOL)isCurrentPageDot
{
    if (!image || !self.pageControl) return;
    
    if ([self.pageControl isKindOfClass:[TFPageControl class]])
    {
        TFPageControl *pageControl = (TFPageControl *)_pageControl;
        pageControl.dotSize = _pageControlDotSize;
        if (isCurrentPageDot)
        {
            pageControl.currentDotImage = image;
        }
        else
        {
            pageControl.dotImage = image;
        }
    }
    else
    {
        UIPageControl *pageControl = (UIPageControl *)_pageControl;
        if (isCurrentPageDot)
        {
            [pageControl setValue:image forKey:@"_currentPageImage"];
        }
        else
        {
            [pageControl setValue:image forKey:@"_pageImage"];
        }
    }
}

- (void)setInfiniteLoop:(BOOL)infiniteLoop
{
    _infiniteLoop = infiniteLoop;
    
    if (self.imagesGroup.count)
    {
        self.imagesGroup = self.imagesGroup;
    }
}

-(void)setAutoScroll:(BOOL)autoScroll
{
    _autoScroll = autoScroll;
    [_timer invalidate];
    _timer = nil;
    
    if (_autoScroll)
    {
        [self setupTimer];
    }
}

- (void)setAutoScrollTimeInterval:(CGFloat)autoScrollTimeInterval
{
    _autoScrollTimeInterval = autoScrollTimeInterval;
    
    [self setAutoScroll:self.autoScroll];
}

- (void)setPageControlStyle:(TFLoopScrollViewPageContolStyle)pageControlStyle
{
    _pageControlStyle = pageControlStyle;
    
    [self setupPageControl];
}

- (void)setImagesGroup:(NSArray *)imagesGroup
{
    _imagesGroup = imagesGroup;
    
    _totalItemsCount = self.infiniteLoop ? self.imagesGroup.count * 100 : self.imagesGroup.count;
    
    if (imagesGroup.count != 1)
    {
        self.collectionView.scrollEnabled = YES;
        [self setAutoScroll:self.autoScroll];
    }
    else
    {
        self.collectionView.scrollEnabled = NO;
    }
    
    [self setupPageControl];
    [self.collectionView reloadData];
}

#pragma mark - actions

- (void)setupPageControl
{
    if (_pageControl) [_pageControl removeFromSuperview]; // 重新加载数据时调整
    
    if ((self.imagesGroup.count <= 1) && self.hidesForSinglePage)
    {
        return;
    }
    
    switch (self.pageControlStyle)
    {
        case TFLoopScrollViewPageContolStyleAnimated:
        {
            TFPageControl *pageControl = [[TFPageControl alloc] init];
            pageControl.numberOfPages = self.imagesGroup.count;
            pageControl.dotColor = self.currentPageDotColor;
            pageControl.userInteractionEnabled = NO;
            pageControl.dotSize = _pageControlDotSize;
            [self addSubview:pageControl];
            _pageControl = pageControl;
        }
            break;
            
        case TFLoopScrollViewPageContolStyleClassic:
        {
            UIPageControl *pageControl = [[UIPageControl alloc] init];
            pageControl.numberOfPages = self.imagesGroup.count;
            pageControl.currentPageIndicatorTintColor = self.currentPageDotColor;
            pageControl.pageIndicatorTintColor = self.pageDotColor;
            pageControl.userInteractionEnabled = NO;
            [self addSubview:pageControl];
            _pageControl = pageControl;
        }
            break;
            
        default:
            break;
    }
    
    // 重设pagecontroldot图片
    self.currentPageDotImage = self.currentPageDotImage;
    self.pageDotImage = self.pageDotImage;
}

- (void)automaticScroll
{
    if (0 == _totalItemsCount) return;
    int currentIndex = _collectionView.contentOffset.x / _flowLayout.itemSize.width;
    int targetIndex = currentIndex + 1;
    if (targetIndex == _totalItemsCount)
    {
        if (self.infiniteLoop)
        {
            targetIndex = _totalItemsCount * 0.5;
        }
        else
        {
            return;
        }
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        return;
    }
    
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

- (void)setupTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)clearCache
{
    [[self class] clearImagesCache];
}

+ (void)clearImagesCache
{
    [[[SDWebImageManager sharedManager] imageCache] clearDisk];
}

#pragma mark - life circles

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _flowLayout.itemSize = self.frame.size;
    
    _collectionView.frame = self.bounds;
    if (_collectionView.contentOffset.x == 0 &&  _totalItemsCount)
    {
        int targetIndex = 0;
        if (self.infiniteLoop)
        {
            targetIndex = _totalItemsCount * 0.5;
        }
        else
        {
            targetIndex = 0;
        }
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
    CGSize size = CGSizeZero;
    if ([self.pageControl isKindOfClass:[TFPageControl class]])
    {
        TFPageControl *pageControl = (TFPageControl *)_pageControl;
        pageControl.dotSize = _pageControlDotSize;
        size = [pageControl sizeForNumberOfPages:self.imagesGroup.count];
    }
    else
    {
        size = CGSizeMake(self.imagesGroup.count * self.pageControlDotSize.width * 1.2, self.pageControlDotSize.height);
    }
    
    CGFloat x = (self.sd_width - size.width) * 0.5;
    if (self.pageControlAliment == TFLoopScrollViewPageContolAlimentRight)
    {
        x = self.collectionView.sd_width - size.width - 10;
    }
    CGFloat y = self.collectionView.sd_height - size.height - self.pageControlDistanceFormBottom;
    
    if ([self.pageControl isKindOfClass:[TFPageControl class]])
    {
        TFPageControl *pageControl = (TFPageControl *)_pageControl;
        pageControl.dotSize = _pageControlDotSize;
        [pageControl sizeToFit];
    }
    
    self.pageControl.frame = CGRectMake(x, y, size.width, size.height);
    self.pageControl.hidden = !_showPageControl;
    
    if (self.backgroundImageView)
    {
        self.backgroundImageView.frame = self.bounds;
    }
    
}

//解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview)
    {
        [_timer invalidate];
        _timer = nil;
    }
}

//解决当timer释放后 回调scrollViewDidScroll时访问野指针导致崩溃
- (void)dealloc
{
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}

#pragma mark - public actions


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _totalItemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TFLoopScrollViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    long itemIndex = indexPath.item % self.imagesGroup.count;
    
    NSString *imagePath = self.imagesGroup[itemIndex];
    
    if ([imagePath isKindOfClass:[NSString class]])
    {
        if ([imagePath hasPrefix:@"http"])
        {
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:self.placeholderImage];
        }
        else
        {
            cell.imageView.image = [UIImage imageNamed:imagePath];
        }
    }
    else if ([imagePath isKindOfClass:[UIImage class]])
    {
        cell.imageView.image = (UIImage *)imagePath;
    }
    
    if (_titlesGroup.count && itemIndex < _titlesGroup.count)
    {
        cell.title = _titlesGroup[itemIndex];
    }
    
    if (!cell.hasConfigured)
    {
        cell.titleLabelBackgroundColor = self.titleLabelBackgroundColor;
        cell.titleLabelHeight = self.titleLabelHeight;
        cell.titleLabelTextColor = self.titleLabelTextColor;
        cell.titleLabelTextFont = self.titleLabelTextFont;
        cell.hasConfigured = YES;
        cell.imageView.contentMode = self.bannerImageViewContentMode;
        cell.clipsToBounds = YES;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didSelectItemAtIndex:)])
    {
        [self.delegate cycleScrollView:self didSelectItemAtIndex:indexPath.item % self.imagesGroup.count];
    }
    
    if (self.clickItemOperationBlock)
    {
        self.clickItemOperationBlock(indexPath.item % self.imagesGroup.count);
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int itemIndex = (scrollView.contentOffset.x + self.collectionView.sd_width * 0.5) / self.collectionView.sd_width;
    if (!self.imagesGroup.count) return; // 解决清除timer时偶尔会出现的问题
    int indexOnPageControl = itemIndex % self.imagesGroup.count;
    
    if ([self.pageControl isKindOfClass:[TFPageControl class]])
    {
        TFPageControl *pageControl = (TFPageControl *)_pageControl;
        pageControl.dotSize = _pageControlDotSize;
        pageControl.currentPage = indexOnPageControl;
    }
    else
    {
        UIPageControl *pageControl = (UIPageControl *)_pageControl;
        pageControl.currentPage = indexOnPageControl;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.autoScroll)
    {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.autoScroll)
    {
        [self setupTimer];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    int itemIndex = (scrollView.contentOffset.x + self.collectionView.sd_width * 0.5) / self.collectionView.sd_width;
    if (!self.imagesGroup.count) return; // 解决清除timer时偶尔会出现的问题
    int indexOnPageControl = itemIndex % self.imagesGroup.count;
    
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didScrollToIndex:)])
    {
        [self.delegate cycleScrollView:self didScrollToIndex:indexOnPageControl];
    }
}


@end
