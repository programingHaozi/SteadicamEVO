//
//  TFGridLayout.m
//  demo
//
//  Created by xiayiyong on 16/3/4.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFGridLayout_LRR.h"

@interface TFGridLayout_LRR()
/**
*  所有的布局属性
*/
@property (nonatomic, strong) NSMutableArray *attrsArray;

@end

@implementation TFGridLayout_LRR

- (NSMutableArray *)attrsArray
{
    if (!_attrsArray)
    {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    [self.attrsArray removeAllObjects];
    
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < count; i++)
    {
        // 创建UICollectionViewLayoutAttributes
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        // 设置布局属性
        CGFloat width = self.collectionView.frame.size.width * 0.5;
        if (i == 0)
        {
            CGFloat height = width;
            CGFloat x = 0;
            CGFloat y = 0;
            attrs.frame = CGRectMake(x, y, width, height);
        }
        else if (i == 1)
        {
            CGFloat height = width * 0.5;
            CGFloat x = width;
            CGFloat y = 0;
            attrs.frame = CGRectMake(x, y, width, height);
        }
        else if (i == 2)
        {
            CGFloat height = width * 0.5;
            CGFloat x = width;
            CGFloat y = height;
            attrs.frame = CGRectMake(x, y, width, height);
        }
        else if (i == 3)
        {
            CGFloat height = width * 0.5;
            CGFloat x = 0;
            CGFloat y = width;
            attrs.frame = CGRectMake(x, y, width, height);
        }
        else if (i == 4)
        {
            CGFloat height = width * 0.5;
            CGFloat x = 0;
            CGFloat y = width + height;
            attrs.frame = CGRectMake(x, y, width, height);
        }
        else if (i == 5)
        {
            CGFloat height = width;
            CGFloat x = width;
            CGFloat y = width;
            attrs.frame = CGRectMake(x, y, width, height);
        }
        else
        {
            UICollectionViewLayoutAttributes *lastAttrs = self.attrsArray[i - 6];
            CGRect lastFrame = lastAttrs.frame;
            lastFrame.origin.y += 2 * width;
            attrs.frame = lastFrame;
        }
        
        // 添加UICollectionViewLayoutAttributes
        [self.attrsArray addObject:attrs];
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArray;
}

@end

