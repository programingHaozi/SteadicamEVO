//
//  JsonRequest.h
//  TorqueSDK
//
//  Created by sunxiaofei on 5/28/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import "BaseQueryModel.h"

@interface JsonRequest : BaseQueryModel

@property (nonatomic, strong) NSString *jsonString;
/**
 *  车辆ID
 */
@property (nonatomic, strong) NSString *carId;

@end
