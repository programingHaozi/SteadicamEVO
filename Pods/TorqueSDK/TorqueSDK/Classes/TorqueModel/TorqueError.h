//
//  TorqueError.h
//  TorqueSDK
//
//  Created by zhangjipeng on 2/8/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TorqueError : NSObject

@property (nonatomic, assign, readonly) NSInteger errorCode;
@property (nonatomic, strong, readonly) NSString *errorMessage;

@end
