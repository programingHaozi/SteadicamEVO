//
//  TFPageControl.h
//  TFPageControl
//
//  Created by Tanguy Aladenise on 2015-01-21.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TFPageControlDelegate;


@interface TFPageControl : UIControl


@property (nonatomic) Class dotViewClass;

/**
 *  dot普通状态下image
 */
@property (nonatomic) UIImage *dotImage;

/**
 *  dot选中状态下image
 */
@property (nonatomic) UIImage *currentDotImage;

/**
 *  dot普通状态下size
 */
@property (nonatomic) CGSize dotSize;

/**
 *  dot选中状态下size
 */
@property (nonatomic, strong) UIColor *dotColor;

/**
 *  dot间距
 */
@property (nonatomic) NSInteger spacingBetweenDots;

/**
 *  TFPageControl的代理
 */
@property(nonatomic,assign) id<TFPageControlDelegate> delegate;

/**
 *  总页数
 */
@property (nonatomic) NSInteger numberOfPages;

/**
 *  当前页
 */
@property (nonatomic) NSInteger currentPage;


@property (nonatomic) BOOL hidesForSinglePage;


@property (nonatomic) BOOL shouldResizeFromCenter;


- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount;

@end


@protocol TFPageControlDelegate <NSObject>

@optional
- (void)TFPageControl:(TFPageControl *)pageControl didSelectPageAtIndex:(NSInteger)index;

@end
