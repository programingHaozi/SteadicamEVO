//
//  TFNavigationController.m
//  Treasure
//
//  Created by xiayiyong on 15/7/2.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFNavigationController.h"

@interface TFNavigationController ()

@end

@implementation TFNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.delegate = nil;
    }
}

@end
