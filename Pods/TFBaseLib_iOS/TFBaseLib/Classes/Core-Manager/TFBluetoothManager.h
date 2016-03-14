//
//  TFBluetoothManager.h
//  Treasure
//
//  Created by xiayiyong on 15/9/2.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

/**
 *  蓝牙状态变化时的回调
 *
 *  @param bluetoothStatus 蓝牙状态
 */
typedef void(^BluetoothStatusChangedBlock)(CBCentralManagerState state);

@interface TFBluetoothManager : NSObject

/**
 *  蓝牙开的状态
 */
@property (nonatomic, assign, getter = isOpen) BOOL open;

/**
 *  蓝牙的状态
 */
@property (nonatomic, assign) CBCentralManagerState bluetoothStatus;

/**
 *  蓝牙状态变化时的回调
 */
@property (nonatomic, copy) BluetoothStatusChangedBlock bluetoothStatusChangedBlock;

#define kTFBluetoothManager  ([TFBluetoothManager sharedManager])

+ (instancetype) sharedManager;

@end
