//
//  TFTableView.m
//  TFUILib
//
//  Created by xiayiyong on 16/1/12.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFTableView.h"
#import <UIScrollView+MJRefresh.h>
#import "TFTableViewCell.h"
#import "TFModel.h"


@interface TFTableView ()
{
    void (^_footerCallback)();  //默认下拉一定程度刷新
    BOOL _isFootering;
    CGFloat _contentOffsetY;
    CGFloat _topButtonY;
    
    NSCache *_cacheForHeight;
}

@property (nonatomic, strong) UIButton *topButton;
@end

static NSString* const _CXModel = @"CXModel";

@implementation TFTableView


/**
 *  初始化
 */
- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView = UIView.new;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    self.showsVerticalScrollIndicator=NO;
    self.showsHorizontalScrollIndicator=NO;
    return self;
}


+ (instancetype)viewForStyle:(UITableViewStyle)style frame:(CGRect)frame {
    TFTableView *view = [[self alloc] initWithFrame:frame style:style];
    view.defaultReusedIdentifier = @"cell";
    view.willShowTopButton = NO;
    view.willAutoHideNavigation = NO;
    view.willAutoFooterRefresh = NO;
    [view initSomething];
    view.delegate = view;
    view.dataSource = view;
    
    [view initCells];
    return view;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        TFTableView *view = self;
        view.defaultReusedIdentifier = @"cell";
        view.willShowTopButton = NO;
        view.willAutoHideNavigation = NO;
        view.willAutoFooterRefresh = NO;
        [view initSomething];
        view.delegate = view;
        view.dataSource = view;
        
        [view initCells];
    }
    return self;
}

- (void)initCells{
    [self registerClass:[TFModel class] forCellReuseIdentifier:@"UITableViewCell"];
}

/*
 在基于此tableview的子类中实现该方法
 */
- (void)initSomething{
    
}

- (NSMutableArray *)datas {
    if (_datas) {
        return _datas;
    }
    _datas = [NSMutableArray array];
    _cacheForHeight = [[NSCache alloc] init];
    return _datas;
}

#pragma mark - 刷新

- (void)refreshData {
    [self endRefreshing];
}

/*
 数据较多时也分页显示
 */
- (void)setCurrectPage:(int)currectPage {
    if (currectPage<1) {
        _currectPage = 1;
    } else {
        _currectPage = currectPage;
    }
}

/*
 “返回顶部”按钮
 */
- (void)setWillShowTopButton:(BOOL)willShowTopButton {
    if (willShowTopButton == _willShowTopButton) {
        return;
    }
    _willShowTopButton = willShowTopButton;
    if (_willShowTopButton) {
        self.topButton =  [[TFButton alloc]init];
        [self.topButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        self.topButton.frame = CGRectMake(0, 0, 40, 40);
        [self.topButton addTarget:nil action:@selector(topButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        CGRect frame = self.frame;
        frame.origin.x += self.frame.size.width - 60;
        frame.origin.y += self.frame.size.height - 60;
        frame.size = self.topButton.frame.size;
        [self.topButton setFrame:frame];
        self.topButton.hidden = YES;
        _topButtonY = self.topButton.frame.origin.y;
        [self.superview insertSubview:self.topButton aboveSubview:self];
    } else {
        [self.topButton removeFromSuperview];
        self.topButton = nil;
    }
}

/*
 返回顶部按钮点击事件
 */
- (void)topButtonClick:(UIButton *)sender {
    [self setContentOffset:CGPointZero animated:YES];
}

/*
 添加下拉刷新
 */
- (void)addHeaderWithCallback:(void (^)())callback {
    [super mj_header];
}

/*
 添加上拉加载
 */
- (void)addFooterWithCallback:(void (^)())callback {
    if (_willAutoFooterRefresh) {
        _isFootering = NO;
        _footerCallback = callback;
    } else {
        [super mj_footer];
    }
}

- (void)headerBeginRefreshing {
    [[super mj_header] beginRefreshing];
}

/**
 *  结束刷新
 */
- (void)endRefreshing {
    [[super mj_header] endRefreshing];
    [[super mj_footer] endRefreshing];
}

#pragma mark - 重写
- (void)registerNib:(UINib *)nib forCellReuseIdentifier:(NSString *)identifier {
    [super registerNib:nib forCellReuseIdentifier:identifier];
    
    [self savePlotCellForIdentifier:identifier];
}

- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier {
    [super registerClass:cellClass forCellReuseIdentifier:identifier];
    
    [self savePlotCellForIdentifier:identifier];
}

- (void)savePlotCellForIdentifier:(NSString *)identifier {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:_plotHeightForCells];
    if (nil == dictionary) {
        dictionary = [NSMutableDictionary dictionary];
    }
    UITableViewCell* cell = [self dequeueReusableCellWithIdentifier:identifier] ;
    if (nil != cell) {
        [dictionary setObject:cell forKey:identifier];
        _plotHeightForCells = dictionary;
    }
    
}

- (void)reloadData {
    [_cacheForHeight removeAllObjects];
    
    [super reloadData];
}

- (void)reloadDataEndRefresh {
    
    NSLog(@"datas=%@", [self.datas description] );
    
    [self reloadData];
    [self endRefreshing];
}

/**
 *  插入行
 *
 *  @param indexPaths
 *  @param animation
 */
- (void)insertRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    [_cacheForHeight removeAllObjects];
    [super insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

/**
 *  删除行
 *
 *  @param indexPaths
 *  @param animation
 */
- (void)deleteRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    [_cacheForHeight removeAllObjects];
    [super deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

/**
 *  删除群组
 *
 *  @param sections
 *  @param animation
 */
- (void)deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    [_cacheForHeight removeAllObjects];
    [super deleteSections:sections withRowAnimation:animation];
}

/**
 *  重新加载群组
 *
 *  @param sections
 *  @param animation
 */
- (void)reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    [_cacheForHeight removeAllObjects];
    
    [super reloadSections:sections withRowAnimation:animation];
}

/**
 *  重新加载某行
 *
 *  @param indexPaths
 *  @param animation
 */
- (void)reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    
    [indexPaths enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [_cacheForHeight removeObjectForKey:obj];
    }];
    
    [super reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

/**
 *  在具体子类中实现该方法
 *
 *  @param data 要使用的数据
 */
- (void)updateDefalutCell:(id)data {
    
}

#pragma mark -  <UITableViewDataSource, UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    _contentOffsetY = 500;
    NSLog(@"%ld %ld",self.style, UITableViewStylePlain);
    return (self.style == UITableViewStylePlain)?1:_datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
    
}

/**
 *  加载tableview内容
 *
 *  @param tableView 列表
 *  @param indexPath 行信息
 *
 *  @return <#return value description#>
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    TFModel *model = (self.style == UITableViewStylePlain)? _datas[indexPath.row] : _datas[indexPath.section][indexPath.row];
    [self updateDefalutCell:model];
    
    TFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.defaultReusedIdentifier];
    [cell setTableView:self];
    
    //在相关cell中定义具体的updateCellForData方法
    [cell updateCellForData:model];
    
    return cell;
}



- (void)setFrame:(CGRect)frame {
    CGRect headerFrame = self.tableHeaderView.frame;
    [super setFrame:frame];
    [self.tableHeaderView setFrame:headerFrame];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (!scrollView.contentSize.height) {
        return;
    }
    
    CGFloat a = scrollView.contentSize.height - scrollView.contentOffset.y;
    CGFloat b = scrollView.frame.size.height;
    if (_willAutoFooterRefresh) {
        if (a < b
            && !_isFootering) {
            _isFootering = YES;
            if (_footerCallback) {
                _footerCallback();
            }
        } else if (a > b) {
            _isFootering = NO;
        }
    }
    if (_willShowTopButton) {
        if (self.contentOffset.y < b || self.contentOffset.y <= 0) {
            self.topButton.hidden = YES;
        } else {
            self.topButton.hidden = NO;
        }
    }
    if (_willAutoHideNavigation) {
        if (self.contentOffset.y < self.contentSize.height-b-100 && ( self.contentOffset.y < _contentOffsetY || self.contentOffset.y < scrollView.frame.size.height)) {
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            
            [self.topButton setFrame:CGRectMake(self.topButton.frame.origin.x, _topButtonY - 44,
                                                self.topButton.frame.size.width, self.topButton.frame.size.height)];
        } else {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            
            [self.topButton setFrame:CGRectMake(self.topButton.frame.origin.x, _topButtonY,
                                                self.topButton.frame.size.width, self.topButton.frame.size.height)];
        }
        _contentOffsetY = self.contentOffset.y;
    }
}

- (void)refreshData :(void (^)())completed{
    
}

@end