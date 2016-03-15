//
//  TFCollectionView.m
//  TFUILib
//
//  Created by xiayiyong on 16/1/12.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFCollectionView.h"

@implementation TFCollectionView

-(void)registerCell:(Class)cellClass
{
    [self registerClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
}

-(void)registerHeaderClass:(Class)cellClass
{
    [self registerClass:cellClass forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(cellClass)];
}

-(void)registerFooterClass:(Class)cellClass
{
    [self registerClass:cellClass forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(cellClass)];
}

@end
