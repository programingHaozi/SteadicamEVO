//
//  GuideViewCollectionCell.h
//  SteadicamEVO
//
//  Created by Chen Hao 陈浩 on 16/3/30.
//  Copyright © 2016年 haozi. All rights reserved.
//


@interface GuideViewCollectionCell : TFCollectionViewCell

@property (nonatomic, strong) NSString *gitPath;

- (void)addSelectViewWithLeft:(NSString *)left
                        right:(NSString *)right
                        title:(NSString *)title
                        block:(void(^)(NSInteger idx))selectBlock;

- (void)removeSelectView;

@end
