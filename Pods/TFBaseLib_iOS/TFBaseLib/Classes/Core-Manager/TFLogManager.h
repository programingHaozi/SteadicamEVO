//
//  TFLogManager.h
//  TFBaseLib
//
//  Created by xiayiyong on 15/11/4.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDLog.h"

@interface TFLogManager : NSObject

#define kTFLogManager  ([TFLogManager sharedManager])

+ (instancetype) sharedManager;

@end
