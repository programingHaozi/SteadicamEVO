//
//  BTConnectTypeDefine.h
//  SteadicamEVO
//
//  Created by Chen Hao 陈浩 on 16/3/15.
//  Copyright © 2016年 haozi. All rights reserved.
//

#ifndef BTConnectTypeDefine_h
#define BTConnectTypeDefine_h

#define kBTConnectManager [BTConnectManager shareInstance]

#define kTorqueTrip         ([TorqueTrip sharedInstance])
#define kTorqueCommon       ([TorqueCommon sharedInstance])
#define kTorqueDevice       ([TorqueDevice sharedInstance])
#define kTorqueDataSync     ([TorqueDataSync sharedInstance])
#define KTorqueDashboard    ([TorqueDashboard sharedInstance])
#define kTorqueDataUpload   ([TorqueDataUpload sharedInstance])

#define kNotifactionConnectFinished                @"NotifactionConnecteFinished"

#define kNotifactionDisConnected                   @"NotifactionDisConnected"

#endif /* BTConnectTypeDefine_h */
