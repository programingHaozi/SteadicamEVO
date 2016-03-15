//
//  UIImageView+Placeholder.m
//  Treasure
//
//  Created by xiayiyong on 15/11/24.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "UIImageView+Placeholder.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (Placeholder)

- (void)setImageWithName:(NSString *)name placeholderImage:(NSString *)placeholder
{
    if (name==nil)
    {
        [self setImage:[UIImage imageNamed:placeholder]];
    }
    else if ([name hasPrefix:@"http"])
    {
        [self sd_setImageWithURL:[NSURL URLWithString:name] placeholderImage:[UIImage imageNamed:placeholder]];
    }
    else
    {
        if (name.length) {
            [self setImage:[UIImage imageNamed:name]];
        }
    }
}


@end
