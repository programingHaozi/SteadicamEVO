//
//  TFJPushManager.h
//  TFBaseLib
//
//  Created by xiayiyong on 15/9/17.
//  Copyright © 2015年 上海赛可电子商务有限公司. All rights reserved.
//  sdk version 2.1.0
//

#import <Foundation/Foundation.h>

/**
 *  激光推送管理类
 */
@interface TFJPushManager : NSObject

/**
 *  设置标签别名
 *
 *  @param alias 别名
 */
+ (void)setAlias:(NSString*)alias;

/**
 *  重置脚标(为0)
 */
+ (void)resetBadge;

@end
