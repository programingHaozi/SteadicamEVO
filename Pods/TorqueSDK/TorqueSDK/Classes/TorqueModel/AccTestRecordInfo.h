//
//  AccTestRecordInfo.h
//  TorqueSDK
//
//  Created by zhangjipeng on 6/11/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccTestRecordInfo : NSObject

@property (nonatomic) NSUInteger recordId;
@property (nonatomic, strong) NSString *testTime;
@property (nonatomic) NSUInteger useTime;
@property (nonatomic) BOOL success;


@end
