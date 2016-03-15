//
// VelSeries.h
// Mongo
//
//  Created by CodeRobot on 2014-10-28
//  Copyright (c) 2014年 com.saike.chexiang All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TorqueVelSeries : NSObject

@property (nonatomic, strong) NSNumber *velSeriesId;
@property (nonatomic, copy) NSString *velSeriesName;
@property (nonatomic, copy) NSString *obdPosImgUrl;
@property (nonatomic, copy) NSString *velCoverImg;
@property (nonatomic, strong) NSArray *velModelsList;
@property (nonatomic, copy) NSString *velModelsListClassName;


@end
