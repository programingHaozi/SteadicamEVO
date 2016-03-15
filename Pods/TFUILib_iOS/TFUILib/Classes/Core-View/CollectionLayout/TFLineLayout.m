//
//  TFLineLayout.m
//  demo
//
//  Created by xiayiyong on 16/3/4.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFLineLayout.h"

@implementation TFLineLayout

- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

///当collectionView显示范围发生改变的时候会调用,  它会再调用, prepare和layoutAttributesForElementsInRect:(CGRect)rect 方法
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

//每次界面布局改变都会调用的方法
- (void)prepareLayout
{
    //必须调用父类, 父类也有一些操作
    [super prepareLayout];
    
    //设置滚动方向(只有流水布局才有这个属性)
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    //设置cell的尺寸  这里的collectionView应该是  viewController
    CGFloat itemH = self.collectionView.frame.size.height * 0.8;
    
    //itemSize  这个属性是流水布局中设置, item的size
    self.itemSize = CGSizeMake(itemH, itemH);
    
    //增加内边距, 解决当我们最左/右边,   item应该停在中间放大的问题
    CGFloat inset = (self.collectionView.frame.size.width - self.itemSize.width) * 0.5;
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
    
}

///返回collectionView上面每个元素的布局属性
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    //1. 拿到父类的cell的属性
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    //2. 计算当前collectionView的x   偏移量加上, collectionView的width一半
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width * 0.5;
    
    //3. 循环 拿到UICollectionViewFlowLayout  对当前的属性的布局
    for (UICollectionViewLayoutAttributes *attrs in array)
    {
        
        //计算item的中心点的x 到   collectionView之间的距离
        CGFloat distance = ABS(centerX - attrs.center.x);
        
        //根据距离计算缩放比例（成反比）  离中心线越远, item越小
        CGFloat scale = 1 - distance/ (self.collectionView.bounds.size.width + self.itemSize.width);
        attrs.transform = CGAffineTransformMakeScale(scale, scale);
    }
    return array;
}

/**
 *  targetContentOffset：CollectionView最终的偏移量
 *  proposedContentOffset：CollectionView预期的偏移量
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    //1. rect
    CGRect rect;
    rect.origin.x = proposedContentOffset.x;
    rect.size = self.collectionView.frame.size;
    
    //2. 得到cell的属性 数组
    NSArray *array = [self layoutAttributesForElementsInRect:rect];
    
    //3. 得到collectionView中心线x
    CGFloat centerX = proposedContentOffset.x + self.collectionView.bounds.size.width * 0.5;
    
    CGFloat miniX = MAXFLOAT;
    //4. 遍历可见cell的属性
    for (UICollectionViewLayoutAttributes *attrs in array) {
        CGFloat delta = attrs.center.x - centerX;
        //取得到中线的最小值
        if(ABS(delta) <= ABS(miniX))
        {
            miniX = delta;
        }
    }
    return  CGPointMake(proposedContentOffset.x + miniX, proposedContentOffset.y);
}

@end
