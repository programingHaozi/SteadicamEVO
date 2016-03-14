//
//  TFHotfixInfoModel.m
//  TFHotfixLib
//
//  Created by Chen Hao 陈浩 on 15/10/22.
//  Copyright © 2015年 Chen Hao 陈浩. All rights reserved.
//

#import "TFHotfixInfoModel.h"

@implementation TFHotfixInfoModel

@synthesize app_id;

@synthesize app_version;

@synthesize shot_version;

@synthesize shot_name;

@synthesize type;

@synthesize file_url;

@synthesize remark;

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.app_id       forKey:@"app_id"];
    [aCoder encodeObject:self.app_version  forKey:@"app_version"];
    [aCoder encodeObject:self.shot_version forKey:@"shot_version"];
    [aCoder encodeObject:self.shot_name    forKey:@"shot_name"];
    [aCoder encodeObject:self.type         forKey:@"type"];
    [aCoder encodeObject:self.file_url     forKey:@"file_url"];
    [aCoder encodeObject:self.remark       forKey:@"remark"];
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.app_id         = [aDecoder decodeObjectForKey:@"app_id"];
        self.app_version    = [aDecoder decodeObjectForKey:@"app_version"];
        self.shot_version   = [aDecoder decodeObjectForKey:@"shot_version"];
        self.shot_name      = [aDecoder decodeObjectForKey:@"shot_name"];
        self.type           = [aDecoder decodeObjectForKey:@"type"];
        self.file_url       = [aDecoder decodeObjectForKey:@"file_url"];
        self.remark         = [aDecoder decodeObjectForKey:@"remark"];
    }
    return self;
}

/**
 *  存储HotFixInfoModel
 *
 *  @param hotFixInfoModel 需要存储的HotFixInfoModel
 */
+ (void)saveHotfixInfoModel:(TFHotfixInfoModel *)hotFixInfoModel
{
    NSData *hotFixinfoData = [NSKeyedArchiver archivedDataWithRootObject:hotFixInfoModel];
    [[NSUserDefaults standardUserDefaults] setObject:hotFixinfoData forKey:@"hotFixInfoModel"];
}

/**
 *  返回存储的HotFixInfoModel
 *
 *  @return 存储的HotFixInfoModel
 */
+ (TFHotfixInfoModel *)getHotfixInfoModel
{
    NSData *hotFixinfoData = [[NSUserDefaults standardUserDefaults] objectForKey:@"hotFixInfoModel"];
    TFHotfixInfoModel *hotFixInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:hotFixinfoData];
    return hotFixInfoModel;
}

@end
