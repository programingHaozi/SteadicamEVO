//
// VelSeries.m
// Mongo
//
//  Created by CodeRobot on 2014-10-28
//  Copyright (c) 2014年 com.saike.chexiang All rights reserved.
//

#import "TorqueVelSeries.h"
#import "SBJson4Writer.h"

@implementation TorqueVelSeries

@synthesize velCoverImg;
@synthesize obdPosImgUrl;
@synthesize velSeriesName;
@synthesize velModelsList;
@synthesize velSeriesId;


- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init])
    {
        self.velCoverImg = [decoder decodeObjectForKey:@"velCoverImg"];
        self.obdPosImgUrl = [decoder decodeObjectForKey:@"obdPosImgUrl"];
        self.velSeriesName = [decoder decodeObjectForKey:@"velSeriesName"];
        self.velModelsList = [decoder decodeObjectForKey:@"velModelsList"];
        self.velSeriesId = [decoder decodeObjectForKey:@"velSeriesId"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.velCoverImg forKey:@"velCoverImg"];
    [encoder encodeObject:self.obdPosImgUrl forKey:@"obdPosImgUrl"];
    [encoder encodeObject:self.velSeriesName forKey:@"velSeriesName"];
    [encoder encodeObject:self.velModelsList forKey:@"velModelsList"];
    [encoder encodeObject:self.velSeriesId forKey:@"velSeriesId"];
}

- (id)copy
{
    TorqueVelSeries *velseries = [[TorqueVelSeries alloc] init];
    velseries.velCoverImg = self.velCoverImg;
    velseries.obdPosImgUrl = self.obdPosImgUrl;
    velseries.velSeriesName = self.velSeriesName;
    velseries.velModelsList = self.velModelsList;
    velseries.velSeriesId = self.velSeriesId;
    return velseries;
}

- (NSString *)velModelsListClassName
{
    return @"VelModels";
}

- (NSString *)description {
    SBJson4Writer *write = [[SBJson4Writer alloc] init];
    return [write stringWithObject:self];
}


@end
