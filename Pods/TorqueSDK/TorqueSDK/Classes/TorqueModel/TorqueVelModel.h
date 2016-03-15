//
// VelModel.h
// Mongo
//
//  Created by CodeRobot on 2014-11-4
//  Copyright (c) 2014年 com.saike.chexiang All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TorqueVelModel : NSObject

@property (nonatomic, strong) NSNumber *velModelId;
@property (nonatomic, copy) NSString *velModelName;
@property (nonatomic, copy) NSString *velCoverImg;

@property (nonatomic, strong) NSNumber *velSeriesId;
@property (nonatomic, copy) NSString *velSeriesName;

@property (nonatomic, strong) NSNumber *velBrandId;
@property (nonatomic, copy) NSString *velBrandName;


@end
