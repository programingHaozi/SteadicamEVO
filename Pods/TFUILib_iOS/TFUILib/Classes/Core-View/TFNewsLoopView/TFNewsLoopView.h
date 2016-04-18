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
typedef enum : NSUInteger
{
    /**
     *  竖直方向
     */
    kNewsLoopViewScrollDirectionVertical,
    /**
     *  水平方向
     */
    kNewsLoopViewScrollDirectionHorizontal,
} TFNewsLoopViewScrollDirection;

@interface TFNewsLoopViewItem : NSObject

/**
 *  显示的标题
 */
@property (nonatomic,strong)NSString  *title;

@end

@interface TFNewsLoopView : UIView

/**
 *  初始化
 *
 *  @param frame           frame大小
 *  @param teams           teams 里面包含的是 TFNewsLoopViewItem
 *  @param scrollDirection 滑动方向 默认垂直方向
 *
 */
- (instancetype)initWithFrame:(CGRect)frame
                        items:(NSArray*)teams
                    direction:(TFNewsLoopViewScrollDirection)scrollDirection
                        block:(void (^)(NSInteger index))block;

/**
 *   block监听点击方式
 */
@property (nonatomic, copy) void (^didSelectItemAtIndexHandler)(NSInteger index);

/**
 *  开始时间
 */
- (void)start;

/**
 *  关闭时间
 */
-(void)stop;

@end
