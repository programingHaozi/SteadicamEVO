//
//  OBDDevice+Upgrade.m
//  TorqueSDK
//
//  Created by zhangjipeng on 2/10/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import "OBDDevice+Upgrade.h"
#import "OBDDeviceSelfDefineType.h"
#import "TorqueDevice.h"
#import "TorqueGlobal.h"
#import <objc/runtime.h>

static const void *key1 = &key1;
static const void *key2 = &key2;
static const void *key3 = &key3;

@implementation OBDDevice (Upgrade)
@dynamic enterUpgradeModeCompletionBlock;
@dynamic exitUpgradeModeCompletionBlock;

- (void (^)(BOOL))enterUpgradeModeCompletionBlock
{
    return objc_getAssociatedObject(self, key1);
}
- (void)setEnterUpgradeModeCompletionBlock:(void (^)(BOOL))enterUpgradeModeCompletionBlock
{
    objc_setAssociatedObject(self, key1, enterUpgradeModeCompletionBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)(BOOL))exitUpgradeModeCompletionBlock
{
    return objc_getAssociatedObject(self, key2);
}
- (void)setExitUpgradeModeCompletionBlock:(void (^)(BOOL))exitUpgradeModeCompletionBlock
{
    objc_setAssociatedObject(self, key2, exitUpgradeModeCompletionBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)binFileLength {
    NSNumber *number = objc_getAssociatedObject(self, key3);
    if (!number) {
        return 0;
    } else {
        return number.integerValue;
    }
}

- (void)setBinFileLength:(NSInteger)length {
    objc_setAssociatedObject(self, key3, @(length), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

/**
 *  升级固件
 *
 *  @param completion 升级结束后的回调
 */
- (void)upgradeWithSoftwarePath:(NSString *)softwarePath targetVersion:(NSString *)targetVersion progressBlock:(void (^)(float, NSString *))progress completion:(void (^)(OBDInfo *, TorqueResult *))completion {
#if 1
    [[TorqueDashboard sharedInstance]realTimeDataStreamSwitch:NO];
   
    //倒计时标记
    __block BOOL isStartCountDown = NO;
    //升级成功标记
    __block BOOL isUpgradeSuccess = NO;
    //升级进度百分比
    __block float progressPercent = 0.05;
    //结果调block
    __block void (^resultCompletion)(OBDInfo *, TorqueResult *) = completion;
    //进度回调block
    __block void (^progressBlock)(float, NSString *) = progress;
    
    if (progress) {
        progress(progressPercent, @"等待设备重启");
    }
    [self enterUpgradeMode:^(BOOL result) {
        if (!result) {
            DDLogDebug(@"设备未进入升级模式");
            self.log(@"设备未进入升级模式");
            TorqueResult *result = [TorqueResult new];
            result.message = @"设备未进入升级模式";
            if (resultCompletion) {
                resultCompletion(nil, result);
            }
            resultCompletion = nil;
            return;
        }
        DDLogDebug(@"设备进入升级模式");
        self.log(@"设备进入升级模式");
        if (progress) {
            progress(progressPercent += 0.05, @"发送升级握手信息");
        }
        
        
        // 倒计时Block 倒计时后将结果block和进度block全部置为nil
       __block void(^countDownBlock)() = ^() {
            DDLogDebug(@"进行失败倒计时");
            if (!isUpgradeSuccess) {
                progressBlock = nil;
                [self createCountDownTimerWithCompletion:^(TorqueResult *result) {
                    isStartCountDown = YES;
                    if (resultCompletion) {
                        resultCompletion(nil, result);
                    }
                    
                    // 倒计时结束
                    if (result.result == 0) {
                        isStartCountDown = NO;
                        resultCompletion = nil;
                    }
                }];
            }
       };
        
        // 进入固件升级模式
        self.dataProcessor.obdMode = OBDModeUpgrade;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kUpgradeWaitReconnectTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __block BOOL isRestart = NO;
            [self connectWithMode:TorqueDeviceConnetModeBT completion:^(NSInteger result) {
                if (result != 0) {
                    DDLogDebug(@"与蓝牙失去连接！");
                    self.log(@"与蓝牙失去连接！");
                    if (isStartCountDown) {
                        return ;
                    }
                    if (countDownBlock) {
                        countDownBlock();
                    }
                    
                    return;
                }
                [self handshake:^(BOOL result) {
                    if (!result) {
                        DDLogDebug(@"握手过程失败！");
                        self.log(@"握手过程失败！");
                        self.dataProcessor.obdMode = OBDModeNormal;
                        if (countDownBlock) {
                            countDownBlock();
                        };
                        return;
                    }
                    DDLogDebug(@"握手过程完成，查询OBD是否已准备就绪");
                    self.log(@"握手过程完成，查询OBD是否已准备就绪");
                    if (progress) {
                        progress(progressPercent += 0.05, @"完成升级握手");
                    }
                    
                    // 握手过程完成，查询OBD是否已准备就绪
                    [self OBDIsReadyForUpgrading:^(BOOL result) {
                        if (!result) {
                            DDLogDebug(@"OBD未准备就绪！");
                            self.log(@"OBD未准备就绪！");
                            self.dataProcessor.obdMode = OBDModeNormal;
                            if (countDownBlock) {
                                countDownBlock();
                            }
                            return;
                        }
                        
                        // OBD准备就绪，开始发包
                        DDLogDebug(@"OBD准备就绪，开始发包");
                        self.log(@"OBD准备就绪，开始发包");
                        [self sendDataPackageWithSoftwarePath:softwarePath progressPersent:^(NSString * packageNum, float transPercent) {
                            if (progress) {
                                progress(progressPercent + transPercent, packageNum);
                            }
                            
                        } completion:^(BOOL result) {
                            if (!result) {
                                self.log(@"发送包失败！");
                                self.dataProcessor.obdMode = OBDModeNormal;
                                if (countDownBlock) {
                                    countDownBlock();
                                }
                                return;
                            }
                            
                            // 发包结束，发送bin文件长度，校验长度
                            DDLogDebug(@"发包结束，发送bin文件长度，校验长度");
                            self.log(@"发包结束，发送bin文件长度，校验长度");
                            [self sendBinFileLength:self.binFileLength completion:^(BOOL result) {
                                if (!result) {
                                    DDLogDebug(@"bin 文件长度校验失败！");
                                    self.log(@"bin 文件长度校验失败！");
                                    self.dataProcessor.obdMode = OBDModeNormal;
                                    if (countDownBlock) {
                                        countDownBlock();
                                    }
                                    return;
                                }
                                if (progress) {
                                    progress(progressPercent += 0.75, @"升级包发送完成，等待设备重启");
                                }
                                
                                isRestart = YES;
                                // bin文件长度校验成功，发送bin文件结束
                                DDLogDebug(@"bin文件长度校验成功，发送bin文件结束\n设备即将重启");
                                self.log(@"bin文件长度校验成功，发送bin文件结束\n设备即将重启");
                                [self sendBinFileEnd:^(BOOL result) {
                                    if (!result) {
                                        if (countDownBlock) {
                                            countDownBlock();
                                        }
                                        return;
                                    }
                                    DDLogDebug(@"等待设备重启");
                                    self.log(@"等待设备重启");
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                        DDLogDebug(@"重新连接设备");
                                        self.log(@"重新连接设备");
                                        __block BOOL timeout = YES;
                                        
                                        //一分钟未重启成功 则视为失败
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(50 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            if (!self.deviceIsConnected && timeout) {
                                                if (countDownBlock) {
                                                    countDownBlock();
                                                }
                                            }
                                        });
                                        
                                        [self connectWithMode:TorqueDeviceConnetModeBT completion:^(NSInteger result) {
                                            timeout = NO;
                                            if (result != 0) {
                                                if (countDownBlock) {
                                                    countDownBlock();
                                                }
                                                return;
                                            }
                                            
                                            [self readObdInfo:^(OBDInfo *obdInfo, NSError *error) {
                                                if (!obdInfo ||
                                                    ![[NSString stringWithFormat:@"V%@", targetVersion] isEqualToString:[obdInfo.softwareVersion uppercaseString]]) {
                                                    DDLogDebug(@"升级失败！");
                                                    self.log(@"升级失败！");
                                                    if (countDownBlock) {
                                                        countDownBlock();
                                                    }
                                                    return;
                                                }
                                                
                                                if (progress) {
                                                    progress(progressPercent += 0.09, @"设备重新连接成功");
                                                }
                                                
                                                DeviceInfo *deviceInfo = [DeviceInfo new];
                                                deviceInfo.sn = obdInfo.sn;
                                                deviceInfo.hardwareVersion = [obdInfo.hardwareVersion isEqualToString: kEST530HardwareVersion]?@"EST530":[obdInfo.hardwareVersion isEqualToString: kEST531HardwareVersion]?@"EST531":@"";
                                                deviceInfo.softwareVersion = [obdInfo.softwareVersion substringFromIndex:1];
                                                
                                                deviceInfo.userId = [TorqueGlobal sharedInstance].user.userId;
                                                
                                                // 上传升级结果到服务端
                                                [[TorqueDevice sharedInstance] uploadUpgradeResultWithobdInfo:deviceInfo completion:^(TorqueResult *result) {
                                                    // 如果上传失败，则执行倒计时
                                                    if (!result.succeed) {
                                                        DDLogDebug(@"升级失败");
                                                        if (countDownBlock) {
                                                            countDownBlock();
                                                        }
                                                        return;
                                                    }
                                                    
                                                    if (progress) {
                                                        progress(1.00, @"升级完成");
                                                    }
                                                    DDLogDebug(@"升级成功！");
                                                    self.log(@"升级成功！");
                                                    if (resultCompletion) {
                                                        isUpgradeSuccess = YES;
                                                        result.result = 1;
                                                        resultCompletion(nil, result);
                                                    }
                                                    
                                                }];
                                            }];
                                        } disconnection:^(NSError *error) {
                                            DDLogDebug(@"重启失败！");
                                            if (countDownBlock) {
                                                countDownBlock();
                                            }
                                        }];
                                    });
                                }];
                            }];
                        }];
                    }];
                }];
            } disconnection:^(NSError *error) {
                DDLogDebug(@"进入固件升级模式连接失败");
                if (isStartCountDown) {
                    return ;
                }
                [self createCountDownTimerWithCompletion:^(TorqueResult *result) {
                    if (resultCompletion&&!isRestart) {
                        countDownBlock = nil;
                        resultCompletion(nil, result);
                    }
                }];
            }];
        });
    }];
#endif
}

- (void)createCountDownTimerWithCompletion:(void (^)(TorqueResult *result))completion {
    TorqueResult *result = [[TorqueResult alloc]init];
    result.succeed = YES;
    result.result = 2;
    __block int num = 10;
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (completion) {
            result.message = [NSString stringWithFormat:@"正在初始化...(%d)",num];
            if (num == 0) {
                result.result = 0;
            }
            completion(result);
        }
        num -- ;
        if (num < 0) {
            dispatch_source_cancel(timer);
        }
    });
    dispatch_resume(timer);
}


/**
 *  升级失败时，恢复固件
 *
 *  @param completion 恢复结束后的回调
 */
- (void)restore:(void (^)(BOOL result))completion {
    
}

#pragma mark - Private Method
- (NSString *)binFilePath {
#ifdef DEBUG
    NSString *path = [[NSBundle mainBundle] pathForResource:kbinFileName ofType:@"bin"];
    return path;
#else
#endif
}

- (NSString *)documentsPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *docDir = [paths objectAtIndex:0];
    return docDir;
}

- (NSString *)packagesDirectory {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentDirectory = [self documentsPath];
    NSString *packagesDirectory = [documentDirectory stringByAppendingPathComponent:@"packages"];
    
    BOOL isDir = NO;
    BOOL isDirExist = [fileManager fileExistsAtPath:packagesDirectory isDirectory:&isDir];
    if (!isDirExist) {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:packagesDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir) {
            DDLogWarn(@"Create Packages Directory Failed.");
        } else {
            DDLogInfo(@"Create Packages Directory Success.");
        }
    }
    
    return packagesDirectory;
}

- (void)removePackageDirectory {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentDirectory = [self documentsPath];
    NSString *packagesDirectory = [documentDirectory stringByAppendingPathComponent:@"packages"];
    
    BOOL isDirExist = [fileManager fileExistsAtPath:packagesDirectory isDirectory:nil];
    if (isDirExist) {
        [fileManager removeItemAtPath:packagesDirectory error:nil];
    }
}

- (NSUInteger)packagesWithSoftwarePath:(NSString *)softwarePath {
    //    const char *filePath = [[self binFilePath] cStringUsingEncoding:NSUTF8StringEncoding];
    const char *filePath = [softwarePath cStringUsingEncoding:NSUTF8StringEncoding];
    FILE *binFile = NULL;
    FILE *outfile = NULL;
    Byte package[kOBDUpgradePackageSize] = {0};
    Byte dataInPackage[kOBDUpgradePackageDataSize] = {0};
    UInt16 sizeOfBinFile = 0;
    size_t numRead = 0;
    int index = 0;
    
    binFile = fopen(filePath, "r");
    if (!binFile) {
        DDLogError(@"Open bin file %s failed!",filePath);
        return 0;
    }
    
    fseek(binFile,0,SEEK_END);
    sizeOfBinFile = ftell(binFile);
    fseek(binFile,0,SEEK_SET);
    
    self.binFileLength = (UInt16)sizeOfBinFile;
    DDLogDebug(@"Bin File Length %ld",(long)self.binFileLength);
    
    if (sizeOfBinFile < kOBDUpgradePackageSize) {
        DDLogDebug(@"bin file %s size error!",filePath);
        return 0;
    }
    
    [self removePackageDirectory];
    while (!feof(binFile)) {
        memset(dataInPackage, 0, kOBDUpgradePackageDataSize * sizeof(Byte));
        memset(package, 0, kOBDUpgradePackageSize * sizeof(Byte));
        
        numRead = fread(dataInPackage, sizeof(Byte), kOBDUpgradePackageDataSize, binFile);
        
        package[0] = numRead;  // 第一个字节为有效数据包长度
        memcpy(&package[1], dataInPackage, kOBDUpgradePackageDataSize * sizeof(Byte)); // 拷贝有效数据包
        
        int chechsum = 0;
        for (int i = 0; i < numRead; i++) {
            chechsum += dataInPackage[i];
        }
        package[numRead + 1] = chechsum; // 最后一个字节（第96字节）为有效数据包的校验和
        
        NSString *outFileName = [[self packagesDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld",(long)index++]];
        const char *outFilePath = [outFileName cStringUsingEncoding:NSUTF8StringEncoding];
        outfile = fopen(outFilePath, "w");
        if (!outfile) {
            DDLogError(@"Write package file %s failed!",outFilePath);
            return 0;
        }
        
        fwrite(package, sizeof(Byte), numRead + 2, outfile);
        fclose(outfile);
    }
    return index;
}

- (NSData *)packageDataFor:(NSUInteger)index {
    NSString *packageFileName = [[self packagesDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld",(long)index]];
    const char *packageFilePath = [packageFileName cStringUsingEncoding:NSUTF8StringEncoding];
    FILE *binFile = NULL;
    long sizeOfBinFile = 0;
    Byte *p = NULL;
    
    binFile = fopen(packageFilePath, "r");
    if (!binFile) {
        DDLogError(@"Read package file %s failed!",packageFilePath);
        return 0;
    }
    
    fseek(binFile,0,SEEK_END);
    sizeOfBinFile = ftell(binFile);
    fseek(binFile,0,SEEK_SET);
    
    p = (Byte *)malloc(sizeOfBinFile * sizeof(Byte));
    fread(p, sizeof(Byte), sizeOfBinFile * sizeof(Byte), binFile);
    fclose(binFile);
    
    NSData *data = [[NSData alloc] initWithBytes:p length:sizeOfBinFile * sizeof(Byte)];
    
    free(p);
    p = NULL;
    
    return data;
}

- (void)enterUpgradeMode:(void (^)(BOOL result))completion {
    self.enterUpgradeModeCompletionBlock  = completion;
    [self.dataProcessor fetchDataStreamForType:OBDDataStreamTypeEnterUpgradeMode
                                      AndParam:nil
                                    completion:^(OBDDataStream *stream, NSError *error) {
                                        __block BOOL timeOut = YES;
//                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kATBackCallTimer * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                                            if (timeOut) {
//                                                if (self.enterUpgradeModeCompletionBlock) {
//                                                    self.enterUpgradeModeCompletionBlock(NO);
//                                                    self.enterUpgradeModeCompletionBlock = nil;
//                                                }
//                                            }
//                                        });
                                        if (error) {
                                            return;
                                        }
//                                        timeOut = NO;
                                        BOOL succeed = NO;
                                        if (stream) {
                                            OBDDataItem *item = [stream.items firstObject];
                                            succeed = [item.value isEqualToString:@"OK"];
                                        }
                                        
                                        if (self.enterUpgradeModeCompletionBlock) {
                                            self.enterUpgradeModeCompletionBlock(succeed);
                                            self.enterUpgradeModeCompletionBlock = nil;
                                        }
                                    }];
}

- (void)exitUpgradeMode:(void (^)(BOOL result))completion {
    self.exitUpgradeModeCompletionBlock = completion;
    [self.dataProcessor fetchDataStreamForType:OBDDataStreamTypeExitUpgradeMode
                                      AndParam:nil
                                    completion:^(OBDDataStream *stream, NSError *error) {
                                        __block BOOL timeOut = YES;
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kATBackCallTimer * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            if (timeOut) {
                                                if (self.exitUpgradeModeCompletionBlock) {
                                                    self.exitUpgradeModeCompletionBlock(NO);
                                                    self.exitUpgradeModeCompletionBlock = nil;
                                                }
                                            }
                                        });
                                        if (error) {
                                            return;
                                        }
                                        timeOut = NO;
                                        BOOL succeed = NO;
                                        if (stream) {
                                            OBDDataItem *item = [stream.items firstObject];
                                            succeed = [item.value isEqualToString:@"OK"];
                                        }
                                        
                                        if (self.exitUpgradeModeCompletionBlock) {
                                            self.exitUpgradeModeCompletionBlock(succeed);
                                            self.exitUpgradeModeCompletionBlock = nil;
                                        }
                                    }];
}

- (void)handshake:(void (^)(BOOL result))completion {
    __block BOOL timeOut = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kUpgradeResendHandshake * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (timeOut) {
            [self.dataProcessor upgradeHandshake:^(OBDDataStream *stream, NSError *error) {
                OBDDataItem *item = [stream.items firstObject];
                if ([item.value isEqualToString:kOBDUpgradeAckHandshakeEnd]) {
                    completion(YES);
                } else {
                    completion(NO);
                }
            }];
        }
    });
    
    [self.dataProcessor upgradeHandshake:^(OBDDataStream *stream, NSError *error) {
        timeOut = NO;
        OBDDataItem *item = [stream.items firstObject];
        if ([item.value isEqualToString:kOBDUpgradeAckHandshakeEnd]) {
            DDLogDebug(@"Handshake Completed");
            completion(YES);
        } else {
            completion(NO);
        }
    }];
}

- (void)OBDIsReadyForUpgrading:(void (^)(BOOL result))completion {
    __block BOOL timeOut = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kUpgradeWaitReadyTimeout * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (timeOut) {
            CloseDataStreamForType(OBDDataStreamTypeUpgradeReady);
            if (completion) {
                completion(NO);
            }
        }
    });
    
    [self.dataProcessor fetchDataStreamForType:OBDDataStreamTypeUpgradeReady
                                      AndParam:nil
                                    completion:^(OBDDataStream *stream, NSError *error) {
                                        timeOut = NO;
                                        OBDDataItem *item = [stream.items firstObject];
                                        if ([item.value isEqualToString:kOBDUpgradeAckReady]) {
                                            DDLogDebug(@"OBD is ready for upgrading");
                                            completion(YES);
                                        } else {
                                            completion(NO);
                                        }
                                    }];
}

- (void)sendOnePackage:(NSData *)data completion:(void (^)(BOOL result))completion {
#if 0
    FILE *outfile = NULL;
    
    NSString *outFileName = [[self documentsPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"send"]];
    const char *outFilePath = [outFileName cStringUsingEncoding:NSUTF8StringEncoding];
    Byte *p = NULL;
    outfile = fopen(outFilePath, "a+");
    if (!outfile) {
        DDLogError(@"Write package file %s failed!",outFilePath);
        return;
    }
    
    p = (Byte *)[data bytes];
    fwrite(p + 1, sizeof(Byte), kOBDUpgradePackageDataSize, outfile);
    fclose(outfile);
#endif
    
    [self.dataProcessor upgradeSendPackage:data
                                completion:^(OBDDataStream *stream, NSError *error) {
                                    OBDDataItem *item = [stream.items firstObject];
                                    if ([item.value isEqualToString:kOBDUpgradeAckChecksumOk]) {
                                        // 已发送包，校验通过，发送下一个包
                                        completion(YES);
                                    }  else if ([item.value isEqualToString:kOBDUpgradeAckSizeTooBig]) {
                                        DDLogWarn(@"bin文件超长（63K）");
                                        self.log([NSString stringWithFormat:@"bin文件超长（63K）！"]);
                                        completion(NO);
                                    } else if ([item.value isEqualToString:kOBDUpgradeAckSaveFailed]) {
                                        DDLogWarn(@"外部flash存入校验错误");
                                        self.log([NSString stringWithFormat:@"外部flash存入校验错误！"]);
                                        completion(NO);
                                    } else if ([item.value isEqualToString:kOBDUpgradeAckChecksumError]) {
                                        DDLogWarn(@"数据包校验和错误");
                                        self.log([NSString stringWithFormat:@"数据包校验和错误！"]);
                                        completion(NO);
                                    } else if ([item.value isEqualToString:kOBDUpgradeAckSizeError]) {
                                        DDLogWarn(@"数据包长度错误");
                                        self.log([NSString stringWithFormat:@"数据包长度错误！"]);
                                        completion(NO);
                                    }else {//if ([item.value isEqualToString:kOBDUpgradeChecksumError]) {
                                        // 已发送包，校验失败，重发该包
                                        completion(NO);
                                    }
                                }];
}

- (void)sendDataPackageWithSoftwarePath:(NSString *)softwarePath progressPersent:(void (^) (NSString * packageNum, float transPercent))progressPercent completion:(void (^)(BOOL result))completion {
    NSUInteger num = [self packagesWithSoftwarePath:softwarePath];
    
    __block int index = 0;
    __block int lastSendIndex = 0;
    __block int reSendTimes = 0;
    
    DDLogDebug(@"Begin Send Package, Total: %ld",(long)num);
    self.log([NSString stringWithFormat:@"开始发包, Total: %ld",(long)num]);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *outFileName = [[self documentsPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"send"]];
    [fileManager removeItemAtPath:outFileName error:nil];
    
    __weak OBDDevice *weakSelf = self;
    NSData *sendData = [weakSelf packageDataFor:index];
    [self sendOnePackage:sendData completion:^(BOOL result) {
        lastSendIndex = index;
        if (result) {
            DDLogDebug(@"Send Package %ld Success",(long)index);
            self.log([NSString stringWithFormat:@"总共%ld个包\n包 %ld 发送成功！",(long)num,(long)(index + 1)]);
            
            //粗略测试固件传输时间占固件升级总时间的66%
            
            progressPercent([NSString stringWithFormat:@"发送%ld/%ld升级包",(long)(index + 1),(long)num], ((float)(index + 1)/(float)num)*0.75);
            
            reSendTimes = 0;
            index++;
            if (index >= num) {
                DDLogDebug(@"All Package Is Send");
                [weakSelf removePackageDirectory];
                [weakSelf.dataProcessor closeSpecialDataStreamForType:OBDDataStreamTypeUpgradeSendPackage];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.dataProcessor upgradeSendPackageCompleted:^(OBDDataStream *stream, NSError *error) {
                        OBDDataItem *item = [stream.items firstObject];
                        if ([item.value isEqualToString:kOBDUpgradeAckPackageSendEnd]) {
                            DDLogDebug(@"OBD received all packages");
                            completion(YES);
                        } else {
                            completion(NO);
                        }
                    }];
                });
                return;
            }
        } else {
            DDLogWarn(@"Send Package %ld Failed",(long)index);
            self.log([NSString stringWithFormat:@"包 %ld 发送失败！",(long)index]);
            if (lastSendIndex == index) {
                reSendTimes++;
                if (reSendTimes >= kOBDUpgradePackageResendTimes) {
                    DDLogWarn(@"Resend Package %ld 3 Times, Send Package Failed!",(long)index);
                    self.log([NSString stringWithFormat:@"重新发送包 %ld！超过3次",(long)index]);
                    [weakSelf removePackageDirectory];
                    [weakSelf.dataProcessor closeSpecialDataStreamForType:OBDDataStreamTypeUpgradeSendPackage];
                    if (completion) {
                        completion(NO);
                    }
                }
                self.log([NSString stringWithFormat:@"第%ld次重新发送包 %ld！",(long)reSendTimes,(long)index]);
            }
        }
        
        NSData *sendData = [weakSelf packageDataFor:index];
        [weakSelf sendOnePackage:sendData completion:nil];
    }];
}


- (void)sendBinFileLength:(int16_t)length completion:(void (^)(BOOL result))completion {
    [self.dataProcessor upgradeSendBinFileLength:length completion:^(OBDDataStream *stream, NSError *error) {
        OBDDataItem *item = [stream.items firstObject];
        if ([item.value isEqualToString:kOBDUpgradeAckLengthOk]) {
            DDLogDebug(@"Bin File Length Is Ok!");
            completion(YES);
        } else if ([item.value isEqualToString:kOBDUpgradeAckLengthError]) {
            DDLogWarn(@"Bin File Length Is Error!");
            completion(NO);
        } else {
            completion(NO);
        }
    }];
}

- (void)sendBinFileEnd:(void (^)(BOOL result))completion {
    __block BOOL timeOut = YES;
    [self startTimeout:kATBackCallTimer completion:^(TorqueResult *result) {
        if (timeOut) {
            self.dataProcessor.obdMode = OBDModeNormal;
            DDLogDebug(@"sendBinFileEnd timeOut !");
            CloseDataStreamForType(OBDDataStreamTypeUppradeSendBinEnd);
            if (completion) {
                completion(NO);
            }
        }
    }];
    [self.dataProcessor upgradeSendBinFileCompleted:^(OBDDataStream *stream, NSError *error) {
        timeOut = NO;
        self.dataProcessor.obdMode = OBDModeNormal;
        OBDDataItem *item = [stream.items firstObject];
        if ([item.value isEqualToString:kOBDUpgradeAckBinFileEnd]) {
            DDLogDebug(@"Bin File Send Completed!");
            completion(YES);
        } else {
            completion(NO);
        }
    }];
}

@end