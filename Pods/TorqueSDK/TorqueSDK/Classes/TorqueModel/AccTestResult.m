//
//  AccTestResult.m
//  TorqueSDK
//
//  Created by zhangjipeng on 6/10/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import "AccTestResult.h"

@implementation AccTestResult

- (void)setItems:(NSArray *)items {
    _items = items;
    NSMutableString *detailString = [NSMutableString stringWithString:@"["];
    NSInteger n = items.count;
    for (AccelerationTestItem *item in items) {
        n--;
        [detailString appendFormat:@"{\"time\":%lu,\"speed\":%f,\"engine_speed\":%lu}",(unsigned long)item.duration, item.carSpeed, (unsigned long)item.rotationSpeed];
        if (n) {
            [detailString appendString:@","];
        }
    }
    [detailString appendString:@"]"];
    _itemsString = detailString;
    
    DDLogDebug(@"AccTestResult itemsString:%@",_itemsString);
}

@end
