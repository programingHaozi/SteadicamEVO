//
//  TFGCDGroup.m
//  TFBaseLib
//
//  Created by xiayiyong on 16/3/3.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFGCDGroup.h"

@interface TFGCDGroup ()

@property (strong, nonatomic, readwrite) dispatch_group_t dispatchGroup;

@end

@implementation TFGCDGroup

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        self.dispatchGroup = dispatch_group_create();
    }
    
    return self;
}

- (void)enter {
    
    dispatch_group_enter(self.dispatchGroup);
}

- (void)leave {
    
    dispatch_group_leave(self.dispatchGroup);
}

- (void)wait {
    
    dispatch_group_wait(self.dispatchGroup, DISPATCH_TIME_FOREVER);
}

- (BOOL)wait:(int64_t)delta {
    
    return dispatch_group_wait(self.dispatchGroup, dispatch_time(DISPATCH_TIME_NOW, delta)) == 0;
}

@end
