//
//  TFCustomListAlertViewProtocol.h
//  Orange
//
//  Created by Chen Yiliang on 3/30/15.
//  Copyright (c) 2015 Chexiang. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  TFCustomListAlertViewProtocol
 */
@protocol TFCustomListAlertViewProtocol <NSObject>

/**
 *  cell文本
 */
@property (nonatomic, readonly) NSString *cellText;

@end

/**
 *  NSString的TFCustomListAlertViewProtocol扩展
 */
@interface NSString (TFCustomListAlertViewProtocol) <TFCustomListAlertViewProtocol>

@end
