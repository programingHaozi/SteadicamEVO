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
        [self initViews];
        [self autolayoutViews];
        [self bindData];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initViews];
        [self autolayoutViews];
        [self bindData];
    }
    
    return self;
}

-(void)initViews
{
    _subViews = [[NSMutableArray alloc]init];
    
    if (self.dataArray)
    {
        [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            GifViews * gifView = [[GifViews alloc]init];
            
            gifView.moviePath = obj;
            
            [self addSubview:gifView];
            
            [self.subViews addObject:gifView];
            
        }];
    }
    
//    self.chooseView = [[PrepareChooseView alloc]initWithLeft:@"Later"
//                                                       right:@"Later"
//                                                       title:@"would you like to balance now?"];
//    [self addSubview:self.chooseView];
    
    
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
    
//    [self.chooseView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        
//        make.width.equalTo(@304);
//        make.height.equalTo(@124);
//        make.top.equalTo(@60);
//        make.left.equalTo(@((self.subViews.count + 1) * SCREEN_WIDTH + (SCREEN_WIDTH - 304)/2));
//    }];
    
    
}

-(void)bindData
{
    [RACObserve(self, dataArray) subscribeNext:^(NSArray *ary) {
        
        NSInteger count = ary.count + [NSNumber numberWithBool:self.showChoose].integerValue;
        
        self.contentSize                    = CGSizeMake(count* SCREEN_WIDTH, 0);
        self.bounces                        = NO;
        self.pagingEnabled                  = YES;
        self.showsHorizontalScrollIndicator = NO;
        
        [self initViews];
        
        [self autolayoutViews];
    }];
    
    [RACObserve(self, showChoose) subscribeNext:^(NSNumber *show) {
        
        NSInteger count = self.dataArray.count + [NSNumber numberWithBool:show].integerValue;
        
        self.contentSize = CGSizeMake(count* SCREEN_WIDTH, 0);
        
//        self.chooseView.hidden = show;
        
    }];
}



@end
