//
//  LGProgressObject.h
//  LGProgressHud
//
//  Created by AQ on 15-5-29.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGProgressObject : NSObject

@property (nonatomic,assign) long long fileLength;

@property (nonatomic,assign) long long loadedLength;
@end
