//
//  TipsView.h
//  SteadicamEVO
//
//  Created by 耗子 on 16/4/5.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ConfirmBlock)();

typedef void(^CancelBlock)();

@interface TipsView : TFView

@property (nonatomic, strong) ConfirmBlock confirmBlock;

@property (nonatomic, strong) CancelBlock cancelBlock;

- (instancetype)initWithMessage:(NSString *)message
            buttonArray:(NSArray *)titleAry;


@end
