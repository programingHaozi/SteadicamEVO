//
//  OBDDevice+Upgrade.h
//  TorqueSDK
//
//  Created by zhangjipeng on 2/10/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import "OBDDevice.h"

#define kOBDUpgradePackageSize         (96)   // bin文件分包后，每个包的最大值（字节）
#define kOBDUpgradePackageDataSize     (kOBDUpgradePackageSize - 2)   // bin文件分包后，每个包中有效数据的大小（字节）
#define kOBDUpgradePackageResendTimes  (3)    // 包校验失败后，重传次数
#define kOBDUpgradePackageSendInterval (100)  // 发送握手信号的时间间隔（ms）

#define kOBDUpgradeAckHandshakeEnd       @"A1"     // App收到 "A1" 表示握手过程完成
#define kOBDUpgradeAckReady              @"A2"     // App收到 "A2" 表示设备FLASH擦除完成，可以发送bin文件
#define kOBDUpgradeAckNotReady           @"E1"     // App收到 "E1" 表示设备FLASH擦除失败
#define kOBDUpgradeAckChecksumOk         @"A3"     // App收到包后，校验通过，并存入成功
#define kOBDUpgradeAckSizeTooBig         @"E2"     // App收到包后，bin文件超长（63K）
#define kOBDUpgradeAckSaveFailed         @"E3"     // App收到包后，外部flash存入校验错误
#define kOBDUpgradeAckChecksumError      @"E4"     // App收到包后，数据包校验和错误
#define kOBDUpgradeAckSizeError          @"E5"     // App收到包后，数据包长度错误
#define kOBDUpgradeAckPackageSendEnd     @"A4"     // App发送给设备，表示所有包已发送完毕
#define kOBDUpgradeAckLengthOk           @"A5"     // App收到该消息，表示Bin文件长度校验成功
#define kOBDUpgradeAckLengthError        @"E7"     // App收到该消息，表示Bin文件长度校验失败
#define kOBDUpgradeAckBinFileEnd         @"A6"     // App收到该消息，表示Bin文件发送完毕




@interface OBDDevice (Upgrade)

@property (assign, nonatomic) NSInteger binFileLength;
@property (nonatomic, copy) void (^enterUpgradeModeCompletionBlock)(BOOL result);
@property (nonatomic, copy) void (^exitUpgradeModeCompletionBlock)(BOOL result);

/**
 *  升级固件
 *
 *  @param targetVersion 固件的版本
 *
 *  @param completion 升级结束后的回调
 */
- (void)upgradeWithSoftwarePath:(NSString *)softwarePath
                  targetVersion:(NSString *)targetVersion
                  progressBlock:(void(^)(float progressPercent, NSString * message))progress
                     completion:(void (^)(OBDInfo *obdInfo, TorqueResult * result))completion;

/**
 *  升级失败时，恢复固件
 *
 *  @param completion 恢复结束后的回调
 */
- (void)restore:(void (^)(BOOL result))completion;


@end