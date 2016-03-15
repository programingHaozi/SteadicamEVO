//
//  TFNewsLoopView.h
//  TFUILib
//
//  Created by 张国平 on 16/3/8.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
    滑动方向
 */
typedef enum : NSUInteger {
    TFNewsLoopViewScrollDirectionVertical, // 竖直方向
    TFNewsLoopViewScrollDirectionHorizontal, // 水平方向
} TFNewsLoopViewScrollDirection;

@interface LoopObj : NSObject

/**
 *  显示的标题
 */
@property (nonatomic,strong)NSString  *labelName;

@end

@interface TFNewsLoopView : UIView

/**
 *  初始化
 *
 *  @param frame           frame大小
 *  @param teams           teams 里面包含的是 LoopObj 请自行组装LoopOb
 *  @param scrollDirection 滑动方向 默认垂直方向
 *
 */
- (instancetype)initWithFrame:(CGRect)frame
      withItemArray:(NSArray*)teams
    scrollDirection:(TFNewsLoopViewScrollDirection)scrollDirection;

@property (nonatomic, assign) TFNewsLoopViewScrollDirection loopViewScrollDirection;

/**
 *   当前位置
 */
@property(nonatomic,readonly) CGPoint  currentOffset;

/**
 *  返回数据
 */
@property(nonatomic,strong) NSArray   *itemArray;

/**
 *   block监听点击方式
 */
@property (nonatomic, copy) void (^clickItemOperationBlock)(NSInteger currentIndex);


/**
 *  开始时间
 */
- (void)startTimer;

/**
 *  关闭时间
 */
-(void)releaseTimer;

@end
