//
//  TipsView.h
//  SteadicamEVO
//
//  Created by 耗子 on 16/4/5.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ConfirmBlock)();

@interface TipsView : TFView

@property (nonatomic, strong) ConfirmBlock confirmBlock;

- (instancetype)initWithMessage:(NSString *)message
            buttonTitle:(NSString *)title;

@end
