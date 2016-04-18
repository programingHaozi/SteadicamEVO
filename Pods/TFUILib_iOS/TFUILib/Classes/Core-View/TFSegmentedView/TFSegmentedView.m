//
//  TFSegmentedView.m
//  Treasure
//
//  Created by xiayiyong on 15/12/11.
//  Copyright © 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFSegmentedView.h"
#import <TFBaseLib.h>
#import <Masonry.h>
#import "UIView+Category.h"

@interface TFSegmentedView ()

@property (nonatomic, strong) UIView *upView;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *titleArr;

@property (nonatomic, strong) NSMutableArray *viewArr;

@end

@implementation TFSegmentedView

#pragma mark ---init

- (id)initWithTitles:(NSArray *)titleArr
               views:(NSArray *)viewArr
               block:(TFSegmentedViewTouchBlock)block
{
    if (self = [self initWithFrame:CGRectZero
                            titles:titleArr
                             views:viewArr
                             block:block])
    {
        
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
             titles:(NSArray *)titleArr
              views:(NSArray *)viewArr
              block:(TFSegmentedViewTouchBlock)block
{
    if (self = [super initWithFrame:frame])
    {
        
        self.titleHeight        = 44;
        self.titleColor         = HEXCOLOR(0x333333, 1);
        self.titleSelectedColor = HEXCOLOR(0x03a9f4, 1);
        
        self.lineColor  = HEXCOLOR(0X03A9F4,  1);
        self.lineHeight = 2;
        
        self.titleArr = [self createTitleArr:titleArr];
        self.viewArr  = [self createViewArr:viewArr];
        
        self.block = block;
        
        [self initViews];
        [self autolayoutViews];
        [self bindData];
    }
    
    return self;
}

- (void) initViews
{
    self.clipsToBounds=YES;
    
    self.upView = [[UIView alloc] init];
    self.upView.clipsToBounds=YES;
    [self.upView setBackgroundColor:HEXCOLOR(0XFFFFFF,  1)];
    [self addSubview:self.upView];
    
    self.lineView = [[UIView alloc] init];
    [self.lineView setBackgroundColor:self.lineColor];
    [self addSubview:self.lineView];

    self.scrollView                 = [UIScrollView new];
    self.scrollView.backgroundColor = [UIColor grayColor];
    self.scrollView.delegate        = self;
    self.scrollView.pagingEnabled   = YES;
    self.scrollView.bounces         = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    [self addSubview:self.scrollView];
}

-(void)autolayoutViews
{
    WS(weakSelf)
    
    NSInteger count = self.titleArr.count;
    
    // 上面的一排按钮
    [self.upView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.top.equalTo(weakSelf.mas_top);
        make.right.equalTo(weakSelf.mas_right);
        make.height.equalTo(@(weakSelf.titleHeight));
    }];
    
    [self horizontalWidthViews:self.titleArr inView:self.upView viewPadding:0 containerPadding:0];
    
    // 中间的线条
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.top.equalTo(weakSelf.upView.mas_bottom).offset(-weakSelf.lineHeight);
        make.width.equalTo(weakSelf.mas_width).multipliedBy(1.0/count);
        make.height.equalTo(@(weakSelf.lineHeight));
    }];
    
    // 下面的滚动试图
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.top.equalTo(weakSelf.lineView.mas_bottom);
        make.bottom.equalTo(weakSelf.mas_bottom);
        make.width.equalTo(weakSelf.mas_width);
    }];
    
    [self horizontalWidthViews:self.viewArr inScrollView:self.scrollView];
}

-(void)bindData
{
    
}

- (void)select:(NSInteger)page
{
    NSInteger count = self.titleArr.count;
    for (int i = 0; i < count; i ++)
    {
        UIButton *btn = self.titleArr[i];
        [btn setTitleColor:page == btn.tag?self.titleSelectedColor:self.titleColor forState:UIControlStateNormal];
    }
    
    int left=self.lineView.width*page;
    
    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(left));
    }];
    
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.width*page, 0) animated:YES];
    
    // 告诉self.view约束需要更新
    [self setNeedsUpdateConstraints];
    
    // 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
    [self updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self layoutIfNeeded];
    }];
    
    if (self.block)
    {
        UIButton *btn = self.titleArr[page];
        self.block(btn.titleLabel.text, page);
    }
}

#pragma mark ---UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    NSInteger count = self.titleArr.count;
    for (int i = 0; i < count; i ++)
    {
        UIButton *btn = self.titleArr[i];
        [btn setTitleColor:page == btn.tag?self.titleSelectedColor:self.titleColor forState:UIControlStateNormal];
    }
    
    int left=self.lineView.width*page;
    
    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(left));
    }];
    
    // 告诉self.view约束需要更新
    [self setNeedsUpdateConstraints];
    
    // 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
    [self updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self layoutIfNeeded];
    }];
    
    if (self.block)
    {
        UIButton *btn = self.titleArr[page];
        self.block(btn.titleLabel.text, page);
    }
}

-(void)clickedButton:(UIButton*)sender
{
    [self select:sender.tag];
}

-(NSMutableArray*)createViewArr:(NSArray*)arr
{
    NSMutableArray *tmpArr = [[NSMutableArray alloc]init];

    NSInteger count = arr.count;
    for (int i = 0; i < count; i ++)
    {
        id obj = arr[i];
        if ([obj isKindOfClass:[UIView class]])
        {
            [tmpArr addObject:obj];
        }
        else if ([obj isKindOfClass:[UIViewController class]])
        {
            [tmpArr addObject:((UIViewController*)obj).view];
        }
    }
    
    return tmpArr;
}

-(NSMutableArray*)createTitleArr:(NSArray*)arr
{
    NSMutableArray *tmpArr = [[NSMutableArray alloc]init];
    
    NSInteger count = arr.count;
    for (int i = 0; i < count; i ++)
    {
        UIButton *btn = UIButton.new;
        
        btn.backgroundColor = [UIColor clearColor];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setTitleColor:self.titleColor forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        btn.titleLabel.font = FONT_BY_PIXEL(26, 28 , 42);
        
        [tmpArr addObject:btn];
    }

    return tmpArr;
}

#pragma mark ---setter getter
-(void)setTitleColor:(UIColor *)titleColor
{
    _titleColor=titleColor;
}

-(void)setTitleSelectedColor:(UIColor *)titleSelectedColor
{
    _titleSelectedColor=titleSelectedColor;
}

-(void)setTitleFont:(UIFont *)titleFont
{
    _titleFont=titleFont;
}

-(void)setTitleSelectedFont:(UIFont *)titleSelectedFont
{
    _titleSelectedFont=titleSelectedFont;
}

-(void)setLineColor:(UIColor *)lineColor
{
    _lineColor=lineColor;
}

-(void)setLineHeight:(CGFloat)lineHeight
{
    _lineHeight=lineHeight;
}

#pragma mark ---commonn method

/**
 *  将若干view等宽布局于容器containerView中
 *
 *  @param views         viewArray
 *  @param containerView 容器view
 *  @param containerPadding     距容器的左右边距
 *  @param viewPadding   各view的左右边距
 */
-(void)horizontalWidthViews:(NSArray *)views inView:(UIView *)containerView viewPadding:(CGFloat)viewPadding containerPadding:(CGFloat)containerPadding
{
    UIView *lastView;
    for (UIView *view in views)
    {
        [containerView addSubview:view];
        if (lastView)
        {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.bottom.equalTo(containerView);
                make.left.equalTo(lastView.mas_right).offset(viewPadding);
                make.width.equalTo(lastView);
            }];
        }
        else
        {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(containerView).offset(containerPadding);
                make.top.bottom.equalTo(containerView);
            }];
        }
        lastView=view;
    }
    
    [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(containerView).offset(-containerPadding);
    }];
}

-(void)horizontalWidthViews:(NSArray *)views inScrollView:(UIScrollView *)scrollView
{
    UIView *container = [UIView new];
    [scrollView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.height.equalTo(scrollView);
    }];
    
    NSInteger count = views.count;
    
    UIView *lastView = nil;
    
    for ( int i = 0 ; i < count ; ++ i )
    {
        UIView *subv = views[i];
        [container addSubview:subv];
        subv.backgroundColor = [UIColor randomColor];
        
        [subv mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.and.bottom.equalTo(container);
            make.width.mas_equalTo(scrollView.mas_width);
            
            if ( lastView )
            {
                make.left.mas_equalTo(lastView.mas_right);
            }
            else
            {
                make.left.mas_equalTo(container.mas_left);
            }
            
        }];
        
        lastView = subv;
        
    }
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lastView.mas_right);
    }];
}

@end
