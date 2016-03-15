//
//  SCPage.h
//  TorqueSDK
//
//  Created by zhangjipeng on 6/11/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCPage : NSObject

@property (nonatomic) BOOL isPage;
@property (nonatomic) NSInteger pageSize;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic) NSInteger totalPages;

@end

SCPage *newPage(BOOL isPage, NSInteger pageSize, NSInteger num, NSInteger total);
