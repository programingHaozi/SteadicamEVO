//
//  TFNavigationDropdownMenutTableView.h
//  TFNavigationDropdownMenu
//
//  Created by xiayiyong on 02/08/2015.
//  Copyright (c) 2015 xiayiyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFNavigationDropdownMenuConfiguration.h"

@interface TFNavigationDropdownMenutTableView : UITableView <
                                                            UITableViewDelegate,
                                                            UITableViewDataSource
                                                            >

@property (nonatomic, strong) TFNavigationDropdownMenuConfiguration *configuration;

@property (nonatomic, copy) void(^selectRowAtIndexPathHandler)(NSUInteger indexPath);

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items configuration:(TFNavigationDropdownMenuConfiguration *)configuration;
@end
