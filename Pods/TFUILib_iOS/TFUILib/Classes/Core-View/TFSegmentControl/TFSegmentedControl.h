//
//  TFCustomSegmentedControl.h
//  Treasure
//
//  Created by xiayiyong on 16/1/15.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import "TFView.h"

/**
 *  TFSegmentedDelegate
 */
@protocol TFSegmentedDelegate <NSObject>

@optional

/**
 *  切换点击按钮
 *
 *  @param selection 按钮Index
 */
- (void)segumentSelectionChange:(NSInteger)selection;

@end

/**
 *  TFCustomSegmentedControl
 */
@interface TFSegmentedControl : TFView

/**
 *  代理
 */
@property(nonatomic,weak) id<TFSegmentedDelegate> delegate;

/**
 *  按钮title数组
 */
@property (nonatomic, strong) NSMutableArray *btnTitleSource;

/**
 *  title字体颜色（普通）
 */
@property (strong, nonatomic) UIColor *titleColor;

/**
 *  title字体按下颜色
 */
@property (strong, nonatomic) UIColor *selectColor;

/**
 *  title字体
 */
@property (strong, nonatomic) UIFont *titleFont;

/**
 *  下划线颜色
 */
@property (nonatomic, strong) UIColor *buttonDownColor;

/**
 *  初始化TFCustomSegmentedControl
 *
 *  @param frame           尺寸
 *  @param titleDataSouece 标题数组
 *  @param backgroundColor 背景色
 *  @param titleColor      标题颜色
 *  @param titleFont       标题字体
 *  @param selectColor     标题选择颜色
 *  @param buttonDownColor 按钮按下颜色
 *  @param delegate        大力
 *
 *  @return TFCustomSegmentedControl
 */
+ (TFSegmentedControl *)segmentedControlFrame:(CGRect)frame
                                    titleDataSource:(NSArray *)titleDataSouece
                                    backgroundColor:(UIColor *)backgroundColor
                                         titleColor:(UIColor *)titleColor
                                          titleFont:(UIFont *)titleFont
                                        selectColor:(UIColor *)selectColor
                                    buttonDownColor:(UIColor *)buttonDownColor
                                           delegate:(id)delegate;

/**
 *  选择Segment
 *
 *  @param segument segment index
 */
-(void)selectTheSegument:(NSInteger)segument;

@end
