//
//  OBDPowerOn.h
//  TorqueSDK
//
//  Created by zhangjipeng on 2/9/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import "TorqueData.h"

@interface OBDPowerOn : TorqueData

@property (nonatomic, assign, readonly) OBDPowerOnReason reason;
@property (nonatomic, strong, readonly) NSDate *date;

@end
