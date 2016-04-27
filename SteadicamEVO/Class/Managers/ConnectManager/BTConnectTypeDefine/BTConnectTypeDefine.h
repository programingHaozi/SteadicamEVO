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

#define kDeviceName1                @"eVo    "
#define kDeviceName2                @"BlueNRG"

#define kBLEService1UUID            @"01366E80-CF3A-11E1-9AB4-0002A5D5C51B"
//#define kBLEService1UUID            @"FFF0"
#define kBLEService2UUID            @"04366E80-CF3A-11E1-9AB4-0002A5D5C51B"

#define kBLECharacteristicWrite     @"02366E80-CF3A-11E1-9AB4-0002A5D5C51B"

#define kBLECharacteristicNofiy1    @"05366E80-CF3A-11E1-9AB4-0002A5D5C51B"
#define kBLECharacteristicNofiy2    @"06366E80-CF3A-11E1-9AB4-0002A5D5C51B"
#define kBLECharacteristicNofiy3    @"07366E80-CF3A-11E1-9AB4-0002A5D5C51B"
#define kBLECharacteristicNofiy4    @"08366E80-CF3A-11E1-9AB4-0002A5D5C51B"

#define kScanPeripheralTimeoutSeconds   (40)

#define ErrorDomain                 @"com.yuneec.SteadicamEVO"

#define kNotifactionConnectFinished                @"NotifactionConnecteFinished"

#define kNotifactionDisConnected                   @"NotifactionDisConnected"

#endif /* BTConnectTypeDefine_h */
