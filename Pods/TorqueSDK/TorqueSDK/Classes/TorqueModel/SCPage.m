//
//  SCPage.m
//  TorqueSDK
//
//  Created by zhangjipeng on 6/11/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import "SCPage.h"

@implementation SCPage

@end

SCPage *newPage(BOOL isPage, NSInteger pageSize, NSInteger num, NSInteger total) {
    SCPage *page = [SCPage new];
    page.isPage = isPage;
    page.pageSize = pageSize;
    page.currentIndex = num;
    page.totalPages = total;
    
    return page;
}