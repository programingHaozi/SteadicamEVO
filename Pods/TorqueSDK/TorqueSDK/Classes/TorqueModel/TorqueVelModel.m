//
// VelModel.m
// Mongo
//
//  Created by CodeRobot on 2014-11-4
//  Copyright (c) 2014年 com.saike.chexiang All rights reserved.
//

#import "TorqueVelModel.h"
#import "SBJson4Writer.h"

@implementation TorqueVelModel

@synthesize velModelId;
@synthesize velCoverImg;
@synthesize velModelName;


- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init])
    {
        self.velModelId = [decoder decodeObjectForKey:@"velModelId"];
        self.velCoverImg = [decoder decodeObjectForKey:@"velCoverImg"];
        self.velModelName = [decoder decodeObjectForKey:@"velModelName"];
        
        self.velSeriesId = [decoder decodeObjectForKey:@"velSeriesId"];
        self.velSeriesName = [decoder decodeObjectForKey:@"velSeriesName"];
        
        self.velBrandId = [decoder decodeObjectForKey:@"velBrandId"];
        self.velBrandName = [decoder decodeObjectForKey:@"velBrandName"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.velModelId forKey:@"velModelId"];
    [encoder encodeObject:self.velCoverImg forKey:@"velCoverImg"];
    [encoder encodeObject:self.velModelName forKey:@"velModelName"];
    
    [encoder encodeObject:self.velSeriesId forKey:@"velSeriesId"];
    [encoder encodeObject:self.velSeriesName forKey:@"velSeriesName"];
    
    [encoder encodeObject:self.velBrandId forKey:@"velBrandId"];
    [encoder encodeObject:self.velBrandName forKey:@"velBrandName"];
}

- (id)copy
{
    TorqueVelModel *velmodel = [[TorqueVelModel alloc] init];
    velmodel.velModelId = self.velModelId;
    velmodel.velCoverImg = self.velCoverImg;
    velmodel.velModelName = self.velModelName;
    velmodel.velSeriesId = self.velSeriesId;
    velmodel.velSeriesName = self.velSeriesName;
    velmodel.velBrandId = self.velBrandId;
    velmodel.velBrandName = self.velBrandName;
   
    return velmodel;
}

- (NSString *)description {
    SBJson4Writer *write = [[SBJson4Writer alloc] init];
    return [write stringWithObject:self];
}

@end
