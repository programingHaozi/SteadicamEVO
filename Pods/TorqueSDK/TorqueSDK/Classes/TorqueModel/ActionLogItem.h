//
//  ActionLogItem.h
//  TorqueSDK
//
//  Created by sunxiaofei on 15/4/14.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActionLogItem : NSObject

@property (nonatomic, strong) NSString *deviceId;
@property (nonatomic) NSInteger actionType;
@property (nonatomic, strong) NSString *parameter;

@end
