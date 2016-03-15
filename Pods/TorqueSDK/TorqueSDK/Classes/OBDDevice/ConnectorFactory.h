//
//  ConnectorFactory.h
//  TorqueSDK
//
//  Created by zhangjipeng on 1/26/15.
//  Copyright (c) 2015 chexiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TorqueTypeDefine.h"
#import "Connector.h"

@interface ConnectorFactory : NSObject

+ (id<Connector>)connectorForMode:(TorqueDeviceConnetMode)mode;

@end
