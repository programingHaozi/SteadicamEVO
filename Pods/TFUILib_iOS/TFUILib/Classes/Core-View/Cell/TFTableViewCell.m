//
//  TFTableViewCell.m
//  TFUILib
//
//  Created by xiayiyong on 16/1/12.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFTableViewCell.h"

@implementation TFTableViewCell

- (void)initViews
{
    NSString *className=NSStringFromClass([self class]);
    if (![className isEqualToString:NSStringFromClass([TFTableViewCell class])])
    {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:[NSString stringWithFormat:@"You must override %@ in %@", NSStringFromSelector(_cmd), self.class]
                                     userInfo:nil];
    }
}

- (void)autolayoutViews
{
    NSString *className=NSStringFromClass([self class]);
    if (![className isEqualToString:NSStringFromClass([TFTableViewCell class])])
    {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:[NSString stringWithFormat:@"You must override %@ in %@", NSStringFromSelector(_cmd), self.class]
                                     userInfo:nil];
    }
}

- (void)bindData
{
    NSString *className=NSStringFromClass([self class]);
    if (![className isEqualToString:NSStringFromClass([TFTableViewCell class])])
    {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:[NSString stringWithFormat:@"You must override %@ in %@", NSStringFromSelector(_cmd), self.class]
                                     userInfo:nil];
    }
}

-(CGFloat)cellHeight
{
    return 44;
}

+(CGFloat)cellHeightWithData:(id)model width:(CGFloat)width
{
    return 0;
}

+(CGFloat)cellHeight
{
    return 44;
}

+(NSString*)reusableIdentifier
{
    return NSStringFromClass([self class]);
}

@end
