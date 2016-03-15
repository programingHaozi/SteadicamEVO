//
//  UITableViewCell+ShowHide.m
//  Treasure
//
//  Created by sunxiaofei on 15/11/24.
//  Copyright © 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "UITableViewCell+ShowHide.h"
#import <TFBaseLib.h>

@implementation UITableViewCell (ShowHide)

#pragma mark - public functions

- (void)showWithDuration:(NSTimeInterval)duration
{
    WS(weakSelf);
    [UIView animateWithDuration:duration
                     animations:^{
                         
                         weakSelf.contentView.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}
- (void)hideWithDuration:(NSTimeInterval)duration
{
    WS(weakSelf);
    [UIView animateWithDuration:duration
                     animations:^{
                         
                         weakSelf.contentView.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}
@end
