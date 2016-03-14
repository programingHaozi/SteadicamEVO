//
//  TFBaseUtil+System.h
//  TFBaseLib
//
//  Created by xiayiyong on 15/10/16.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFBaseUtil.h"

/**
 *  获取系统版本号
 *
 *  @return 系统版本号
 */
NSInteger tf_iOSVersion(void);

/**
 *  设备是否是iPad
 *
 *  @return 是返回YES否则返回NO
 */
BOOL tf_isiPad(void);

/**
 *  设备是否是iPhone
 *
 *  @return 是返回YES否则返回NO
 */
BOOL tf_isiPhone(void);

/**
 *  设备是否是Retina
 *
 *  @return 是返回YES否则返回NO
 */
BOOL tf_isRetina(void);

/**
 *  设备是否是RetinaHD
 *
 *  @return 是返回YES否则返回NO
 */
BOOL tf_isRetinaHD(void);

/**
 *  设备是否是Landscape
 *
 *  @return 是返回YES否则返回NO
 */
BOOL tf_isLandscape(void);

@interface TFBaseUtil (System)

/**
 *  获取系统版本号
 *
 *  @return 系统版本号
 */
+ (NSInteger)iOSVersion;

/**
 *  设备是否是iPad
 *
 *  @return 是返回YES否则返回NO
 */
+ (BOOL)isiPad;

/**
 *  设备是否是iPhone
 *
 *  @return 是返回YES否则返回NO
 */
+ (BOOL)isiPhone;

/**
 *  设备是否是Retina
 *
 *  @return 是返回YES否则返回NO
 */
+ (BOOL)isRetina;

/**
 *  设备是否是RetinaHD
 *
 *  @return 是返回YES否则返回NO
 */
+ (BOOL)isRetinaHD;

/**
 *  设备是否是Landscape
 *
 *  @return 是返回YES否则返回NO
 */
+ (BOOL)isLandscape;

@end
