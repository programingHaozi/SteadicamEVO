//
//  DetectReportPage.m
//  TorqueSDK
//
//  Created by sunxiaofei on 6/15/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import "DetectReportPage.h"

@implementation DetectReportPage

- (id)proxyForJson {
    return @{@"examReport" : _examReport};
}

@end
