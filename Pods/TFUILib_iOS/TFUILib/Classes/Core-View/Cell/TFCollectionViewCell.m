//
//  TFCollectionViewCell.m
//  TFUILib
//
//  Created by xiayiyong on 16/1/12.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFCollectionViewCell.h"

@implementation TFCollectionViewCell

- (void)initViews
{
    NSString *className=NSStringFromClass([self class]);
    if (![className isEqualToString:NSStringFromClass([TFCollectionViewCell class])])
    {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:[NSString stringWithFormat:@"You must override %@ in %@", NSStringFromSelector(_cmd), self.class]
                                     userInfo:nil];
    }
}

- (void)autolayoutViews
{
    NSString *className=NSStringFromClass([self class]);
    if (![className isEqualToString:NSStringFromClass([TFCollectionViewCell class])])
    {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:[NSString stringWithFormat:@"You must override %@ in %@", NSStringFromSelector(_cmd), self.class]
                                     userInfo:nil];
    }
}

- (void)bindData
{
    NSString *className=NSStringFromClass([self class]);
    if (![className isEqualToString:NSStringFromClass([TFCollectionViewCell class])])
    {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:[NSString stringWithFormat:@"You must override %@ in %@", NSStringFromSelector(_cmd), self.class]
                                     userInfo:nil];
    }
}


@end
