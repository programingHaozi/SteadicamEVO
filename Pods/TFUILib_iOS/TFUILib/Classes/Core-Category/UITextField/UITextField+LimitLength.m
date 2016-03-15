//
//  UITextField+LimitLength.m
//  TextLengthLimitDemo
//
//  Created by xiayiyong on 15/7/1.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "UITextField+LimitLength.h"
#import <objc/objc.h>
#import <objc/runtime.h>

@implementation UITextField (LimitLength)

static NSString *kLimitTextLengthKey = @"kLimitTextLengthKey";

- (void)limitTextLength:(int)length
{
    objc_setAssociatedObject(self, (__bridge const void *)(kLimitTextLengthKey), [NSNumber numberWithInt:length], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self addTarget:self
             action:@selector(textFieldTextLengthLimit:)
   forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldTextLengthLimit:(id)sender
{
    NSNumber *lengthNumber = objc_getAssociatedObject(self, (__bridge const void *)(kLimitTextLengthKey));
    
    int length = [lengthNumber intValue];
    
    if(self.text.length > length)
    {
        self.text = [self.text substringToIndex:length];
    }
}

@end
