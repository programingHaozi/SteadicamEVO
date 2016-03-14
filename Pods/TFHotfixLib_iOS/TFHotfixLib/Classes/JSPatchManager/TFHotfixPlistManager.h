//
//  TFHotfixPlistManager.h
//  TFHotfixLib
//
//  Created by Chen Hao 陈浩 on 15/10/22.
//  Copyright © 2015年 Chen Hao 陈浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFHotfixPlistManager : NSObject

/**
 *  获取serverUrl 地址
 */
@property (nonatomic,strong) NSString *serverUrl;

/**
 *  获取当前appId
 */
@property (nonatomic,strong) NSString *appId;

/**
 *  初始化HotfixPlistManager
 *
 *  @return HotfixPlistManager实例
 */
+ (TFHotfixPlistManager *)sharedManager;

@end
