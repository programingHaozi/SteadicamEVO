//
//  TFUserDefaults.h
//  TFBaseLib
//
//  Created by xiayiyong on 15/10/21.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//  from https://github.com/gangverk/GVUserDefaults
//

#import <Foundation/Foundation.h>

@interface TFUserDefaults : NSObject

#define kTFUserDefaults  ([TFUserDefaults standardUserDefaults])

+ (instancetype)standardUserDefaults;

@end

