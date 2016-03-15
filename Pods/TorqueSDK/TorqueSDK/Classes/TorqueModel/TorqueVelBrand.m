//
// VelBrand.m
// Mongo
//
//  Created by CodeRobot on 2014-10-28
//  Copyright (c) 2014年 com.saike.chexiang All rights reserved.
//

#import "TorqueVelBrand.h"
#import "SBJson4Writer.h"

@implementation TorqueVelBrand

@synthesize velBrandId;
@synthesize velBrandName;
@synthesize velBrandLogoUrl;


- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init])
    {
        self.velBrandId = [decoder decodeObjectForKey:@"velBrandId"];
        self.velBrandName = [decoder decodeObjectForKey:@"velBrandName"];
        self.velBrandLogoUrl = [decoder decodeObjectForKey:@"velBrandLogoUrl"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.velBrandId forKey:@"velBrandId"];
    [encoder encodeObject:self.velBrandName forKey:@"velBrandName"];
    [encoder encodeObject:self.velBrandLogoUrl forKey:@"velBrandLogoUrl"];
}

- (id)copy
{
    TorqueVelBrand *velbrand = [[TorqueVelBrand alloc] init];
    velbrand.velBrandId = self.velBrandId;
    velbrand.velBrandName = self.velBrandName;
    velbrand.velBrandLogoUrl = self.velBrandLogoUrl;
    return velbrand;
}

- (NSString *)description
{
    SBJson4Writer *write = [[SBJson4Writer alloc] init];
    return [write stringWithObject:self];
}


@end
