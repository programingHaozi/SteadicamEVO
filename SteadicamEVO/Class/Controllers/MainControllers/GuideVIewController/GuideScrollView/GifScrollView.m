//
//  GifScrollView.m
//  SteadicamEVO
//
//  Created by Chen Hao 陈浩 on 16/4/19.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import "GifScrollView.h"
#import "PrepareChooseView.h"
#import "GifViews.h"

@interface GifScrollView()

@property (nonatomic, strong) NSMutableArray<GifViews *> *subViews;

/**
 *  选择视图
 */
@property (nonatomic, strong) PrepareChooseView *chooseView;

@end


@implementation GifScrollView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        
        [self bindData];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        
        [self bindData];
    }
    
    return self;
}

-(void)initViews
{
    _subViews = [[NSMutableArray alloc]init];
    
    
    WS(weakSelf)
    if (self.dataArray)
    {
        [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            GifViews * gifView = [[GifViews alloc]init];
            
            gifView.bounds = CGRectMake(0, 0, 304, 204);
            
            gifView.moviePath = obj;
            
            [weakSelf addSubview:gifView];
            
            [weakSelf.subViews addObject:gifView];
            
        }];
    }

    self.chooseView = [[PrepareChooseView alloc]initWithLeft:@"Later"
                                                       right:@"OK"
                                                       title:@"would you like to balance now?"];
    
    self.chooseView.selectBlock = ^(NSInteger idx){
        
        weakSelf.contentSize = CGSizeMake(0, 0);
        
        [weakSelf.chooseView.superview.viewController.navigationController popViewControllerAnimated:YES];
    };
    
    [self addSubview:self.chooseView];
    
    
}

-(void)autolayoutViews
{
    if (self.subViews)
    {
        [self.subViews enumerateObjectsUsingBlock:^(GifViews * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [obj mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.width.equalTo(@304);
                make.height.equalTo(@204);
                make.top.equalTo(@((SCREEN_HEIGHT - 268)/2 - 10));
                make.left.equalTo(@(idx * SCREEN_WIDTH + (SCREEN_WIDTH - 304)/2));
            }];
        }];
    }
    
    WS(weakSelf)
    [self.chooseView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@304);
        make.height.equalTo(@124);
        make.top.equalTo(@60);
        make.left.equalTo(@(weakSelf.subViews.count * SCREEN_WIDTH + (SCREEN_WIDTH - 304)/2));
    }];
    
    
}

-(void)bindData
{
    @weakify(self)
    [RACObserve(self, dataArray) subscribeNext:^(NSArray *ary) {
        @strongify(self)
        
        NSInteger count = ary.count + [NSNumber numberWithBool:self.showChoose].integerValue;
        
        self.contentSize                    = CGSizeMake(count* SCREEN_WIDTH, 0);
        self.bounces                        = NO;
        self.pagingEnabled                  = YES;
        self.showsHorizontalScrollIndicator = NO;
        
        if (ary.count != 0)
        {
            [self initViews];
            [self autolayoutViews];
        }
        
    }];
    
    [RACObserve(self, showChoose) subscribeNext:^(NSNumber *show) {
        @strongify(self)
        
        NSInteger count = self.dataArray.count + [NSNumber numberWithBool:show].integerValue;
        
        self.contentSize = CGSizeMake(count* SCREEN_WIDTH, 0);
        
    }];
}



@end
