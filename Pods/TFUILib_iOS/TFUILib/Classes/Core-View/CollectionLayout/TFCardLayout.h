//
//  TFHeadFloatLayout.h
//  demo
//
//  Created by xiayiyong on 16/3/4.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//  一个像UITableView那样可以使得headView浮动的布局
//  copy from https://github.com/BetterFatMan/CollectionView
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TFCardAnimType)
{
    TFCardAnimTypeLinear,
    TFCardAnimTypeRotary,
    TFCardAnimTypeCarousel,
    TFCardAnimTypeCarousel1,
    TFCardAnimTypeCoverFlow,
};

@interface TFCardLayout : UICollectionViewLayout

- (instancetype)initWithAnim:(TFCardAnimType)anim;

@property (readonly)  TFCardAnimType carouselAnim;

@property (nonatomic) CGSize itemSize;
@property (nonatomic) NSInteger visibleCount;
@property (nonatomic) UICollectionViewScrollDirection scrollDirection;

@end
