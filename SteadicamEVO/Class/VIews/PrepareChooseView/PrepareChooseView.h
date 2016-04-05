//
//  PrepareChooseView.h
//  SteadicamEVO
//
//  Created by Chen Hao 陈浩 on 16/3/31.
//  Copyright © 2016年 haozi. All rights reserved.
//

typedef void(^SelectBlock)(NSInteger idx);

@interface PrepareChooseView : TFView

@property (nonatomic, strong) SelectBlock selectBlock;

- (instancetype)initWithLeft:(NSString *)left right:(NSString *)right title:(NSString *)title;

@end
