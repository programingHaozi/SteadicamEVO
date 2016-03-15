//
//  TorqueFeature.h
//  TorqueSDK
//
//  Created by zhangjipeng on 1/29/15.
//  Copyright (c) 2015 chexiang. All rights reserved.
//

#ifndef TorqueSDK_TorqueFeature_h
#define TorqueSDK_TorqueFeature_h


#ifdef DEBUG
#define USE_EST527   0
#define USE_EST530   1
#define USE_ANONYMOUS_MODE 0
#define OBDDeviceRTDefaultOff 0
#define USE_QualityChecking_Mode 0   // 质检模式，发现设备超时时间10s，鉴权次数3次

/*
 *  USE_EncryptedCoreData
 *      0 : Core Data
 *      1 : EncryptedStore makeStore:passcode:
 *      2 : EncryptedStore makeStoreWithOptions:managedObjectModel:
 *      3 : EncryptedStore makeStoreWithStructOptions:managedObjectModel:
 */
#define USE_EncryptedCoreData 3


#else
#define USE_EST527   0
#define USE_EST530   1
#define OBDDeviceRTDefaultOff 0

/*
 *  USE_EncryptedCoreData
 *      0 : Core Data
 *      1 : EncryptedStore makeStore:passcode:
 *      2 : EncryptedStore makeStoreWithOptions:managedObjectModel:
 *      3 : EncryptedStore makeStoreWithStructOptions:managedObjectModel:
 */
#define USE_EncryptedCoreData 3

#endif


#endif