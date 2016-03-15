//
//  BTDeviceModel.h
//  SteadicamEVO
//
//  Created by Chen Hao 陈浩 on 16/3/15.
//  Copyright © 2016年 haozi. All rights reserved.
//

/**
 *  BTDeviceModel
 */
@interface BTDeviceModel : TFModel

/**
 *  蓝牙设备名称
 */
@property (nonatomic, strong) NSString *name;

/**
 *  蓝牙设备连接密码
 */
@property (nonatomic, strong) NSString *password;

@end
