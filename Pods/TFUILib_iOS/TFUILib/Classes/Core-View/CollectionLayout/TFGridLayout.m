//
//  TFGridLayout.m
//  demo
//
//  Created by xiayiyong on 16/3/4.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFGridLayout.h"

@interface TFGridLayout()
/**
 *  所有的布局属性
 */
@property (nonatomic, strong) NSMutableArray *attrsArray;

@end

@implementation TFGridLayout

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
        CGFloat width = self.collectionView.frame.size.width /self.numberOfColumns;
        CGFloat height = self.collectionView.frame.size.height /self.numberOfRows;
        CGFloat x = i%self.numberOfColumns*width;
        CGFloat y = i/self.numberOfColumns*height;;
        attrs.frame = CGRectMake(x, y, width, height);
        
        if (i>=self.numberOfColumns*self.numberOfRows)
        {
            width=0;
            height=0;
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