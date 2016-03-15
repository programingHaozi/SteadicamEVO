//
//  BaseRsp.m
// Treasure
//
//  Created by xiayiyong on 15/7/1.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFBaseResponse.h"

@implementation TFBaseResponse

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        self.errorCode=0;
        self.errorMessage=@"";
    }
    return self;
}

-(instancetype)initWithErrorCode:(int)errorCode
{
    self = [super init];
    if (self)
    {
        self.errorCode=errorCode;
        self.errorMessage=@"";
    }
    return self;
}

-(instancetype)initWithErrorCode:(int)errorCode errorMessage:(NSString*)errorMessage
{
    self = [super init];
    if (self)
    {
        self.errorCode=errorCode;
        self.errorMessage=errorMessage;
    }
    return self;
}

@end
