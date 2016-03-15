//
//  OBDDataItem.h
//  TorqueSDK
//
//  Created by zhangjipeng on 1/27/15.
//  Copyright (c) 2015 chexiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OBDDataItem : NSObject

@property (nonatomic, readonly) NSUInteger index;
@property (nonatomic, readonly) NSString *splitString;
@property (nonatomic, strong, readonly) NSString *itemName;
@property (nonatomic, strong, readonly) NSString *unit;
@property (nonatomic, strong) NSString *value;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
