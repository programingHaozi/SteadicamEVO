//
//  TorqueCommon.m
//  TorqueSDK
//
//  Created by sunxiaofei on 15/3/9.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import "TorqueCommon.h"
#import <Availability.h>
#import "TorqueDevice.h"
#import "TorqueDataOperation.h"
#import "AFHTTPClient10.h"
#import "TorqueGlobal.h"
#import "TorqueUtility.h"
#import "TorqueRestKit.h"
#import <SBJson4.h>
#import "NSString+Date.h"

@interface BarCode : NSObject
@property (nonatomic, strong) NSString *encodeBarCode;
@end
@implementation BarCode

@end

@interface TorqueCommon()
@property (nonatomic, strong) ReleaseNote *currentVersion;

@end
@implementation TorqueCommon

+ (instancetype)sharedInstance {
    static TorqueCommon *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [TorqueCommon new];
        [instance initDDLog];
        
    });
    return instance;
}

- (void)initDDLog {
    // Enable XcodeColors
    setenv("XcodeColors", "YES", 0);
    // 支持将调试语句写入到苹果的日志中。一般针对对Mac开发
    //[DDLog addLogger:[DDASLLogger sharedInstance]];
    // 允许颜色, 需要安装插件xcodecolors
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor orangeColor] backgroundColor:nil forFlag:DDLogFlagDebug];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor purpleColor] backgroundColor:nil forFlag:DDLogFlagInfo];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor lightGrayColor] backgroundColor:nil forFlag:DDLogFlagVerbose];
    
    [DDLog addLogger:[DDTTYLogger sharedInstance] withLevel:ddLogLevel];
    
    DDFileLogger *fileLoger = [DDFileLogger new];
    fileLoger.rollingFrequency = 60 * 60 * 24;
    fileLoger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:fileLoger];
}
- (void)createDescriptors {
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    // barCode
    RKObjectMapping *barCodeMapping = [RKObjectMapping mappingForClass:[BarCode class]];
    [barCodeMapping addAttributeMappingsFromDictionary:@{@"barCode" : @"encodeBarCode"}];
    
    [self responseDescriptorWithMapping:barCodeMapping
                                 method:RKRequestMethodGET
                                   path:kGetBarCode
                            pathPattern:nil
                                keyPath:@"result"
                            statusCodes:statusCodes];
    
    // 车辆品牌
    RKObjectMapping *velBrandInfoMapping = [RKObjectMapping mappingForClass:[TorqueVelBrand class]];
    [velBrandInfoMapping addAttributeMappingsFromDictionary:@{@"velBrandId" : @"velBrandId",
                                                              @"velBrandName" : @"velBrandName",
                                                              @"velBrandLogoUrl" : @"velBrandLogoUrl"}];
    
    [self responseDescriptorWithMapping:velBrandInfoMapping
                                 method:RKRequestMethodGET
                                   path:kGetBrandInfoList
                            pathPattern:nil
                                keyPath:@"result"
                            statusCodes:statusCodes];
    
    // 车系
    RKObjectMapping *velSeriesInfoMapping = [RKObjectMapping mappingForClass:[TorqueVelSeries class]];
    [velSeriesInfoMapping addAttributeMappingsFromDictionary:@{@"velSeriesId" : @"velSeriesId",
                                                               @"velSeriesName" : @"velSeriesName",
                                                               @"velCoverImg" : @"velCoverImg",
                                                               @"obdPosImgUrl" : @"obdPosImgUrl"}];
    
    [self responseDescriptorWithMapping:velSeriesInfoMapping
                                 method:RKRequestMethodGET
                                   path:kGetSeriesInfoList
                            pathPattern:nil
                                keyPath:@"result"
                            statusCodes:statusCodes];
    
    // 车型
    RKObjectMapping *velModelInfoMapping = [RKObjectMapping mappingForClass:[TorqueVelModel class]];
    [velModelInfoMapping addAttributeMappingsFromDictionary:@{@"velModelId" : @"velModelId",
                                                              @"velModelName" : @"velModelName",
                                                              @"velModelCoverImg" : @"velCoverImg",
                                                              @"velSeriesId" : @"velSeriesId",
                                                              @"velSeriesName" : @"velSeriesName",
                                                              @"velBrandId" : @"velBrandId",
                                                              @"velBrandName" : @"velBrandName"}];
    
    [self responseDescriptorWithMapping:velModelInfoMapping
                                 method:RKRequestMethodGET
                                   path:kGetModelInfoList
                            pathPattern:nil
                                keyPath:@"result"
                            statusCodes:statusCodes];
    
    // 验证vin码合法性
    RKObjectMapping *validateVinCodeMapping = [RKObjectMapping mappingForClass:[ValidateVinCode class]];
    [validateVinCodeMapping addAttributeMappingsFromDictionary:@{@"status" : @"status"}];
    [validateVinCodeMapping addRelationshipMappingWithSourceKeyPath:@"model" mapping:velModelInfoMapping];
    [self responseDescriptorWithMapping:validateVinCodeMapping
                                 method:RKRequestMethodGET
                                   path:kValidateVinCode
                            pathPattern:nil
                                keyPath:@"result"
                            statusCodes:statusCodes];
}
//用户初始化--登录成功后 调用
- (void)userInit:(UserInfo *)userInfo
{
    //设置当前 user 信息
    [[TorqueGlobal sharedInstance] setUser:userInfo];
    
    //重新获取用户车辆信息--CurrentCarInfo
    [[TorqueDevice sharedInstance] getCarsForUser:userInfo compeltion:^(NSArray *cars, TorqueResult *result) {
        if (result.succeed) {
            //重置当前用户的 所有车辆信息
            [[TorqueDataOperation sharedInstance] resetCarInfo:cars];
        }
    }];
    
    //设置当前设备
    [[TorqueDevice sharedInstance] getDevicesForUser:userInfo compeltion:^(NSArray *devices, TorqueResult *result) {
        if (result.succeed) {
            //重置当前用户的 设备信息
            [[TorqueDataOperation sharedInstance] resetDevicesInfo:devices];
        }
    }];
}


- (void)isAllow3GUpload:(BOOL)allow
{
    [TorqueGlobal sharedInstance].is3GAllow = allow;
}

- (void)setAppId:(NSString *)appId
{
    [[TorqueGlobal sharedInstance] setAppId:appId];
}

- (void)setSDKHttpHeader:(NSString *)token
{
    HttpHeader *header = [[HttpHeader alloc] init];
    header.token = token;
    
    [[TorqueRestKit sharedInstance] setHeader:header];
}

- (void)setSereverUrl:(NSString *)serverUrl
{
    [[TorqueGlobal sharedInstance] setServerUrl:serverUrl];;
}

- (void)initTorqueSDK:(UserInfo *)userInfo appId:(NSString *)appId serverUrl:(NSString *)serverUrl token:(NSString *)token compeltion:(void (^)(TorqueResult *result))completion {
    TorqueResult *result = [[TorqueResult alloc] init];
    if (!userInfo ||
        !appId ||
        !token) {
        if (!userInfo) {
            result.message = kMessage_userIdNotNull;
        }
        if (!appId) {
            result.message = kMessage_appidNotNull;
        }
        if (!token) {
            result.message = kMessage_torkenNotNull;
        }
        if (completion) {
            completion(result);
        }
        return;
    }
    [self setSereverUrl:serverUrl];
    //    [[TorqueRestKit sharedInstance] config];
    [self setSDKHttpHeader:token];
    
    [self userInit:userInfo];
    [self setAppId:appId];
    
    
    result.succeed = YES;
    result.result = 0;
    if (completion) {
        completion(result);
    }
}

- (ReleaseNote *)version {
    if (!_currentVersion) {
        NSData *data= [TorqueUtility readFileFromBundle:@"TorqueCommon" fileName:@"ReleaseNote" fileType:@"json"];
        if (!data) {
            return nil;
        }
        NSArray *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (!results) {
            return nil;
        }
        NSDictionary * item = results.firstObject;
        if (!item) {
            return nil;
        }
        NSString *version=[item objectForKey:@"version"];
        BOOL mandatory=[[item objectForKey:@"mandatory"] boolValue];
        NSString *dateString =[item objectForKey:@"publishDate"];
        NSDate *publishDate= [NSString dateFromString:dateString ForDateFormatter:@"yyyy-MM-dd"];
        NSString *logDescription=[item objectForKey:@"description"];
        
        _currentVersion = [ReleaseNote new];
        _currentVersion.version = version;
        _currentVersion.publishDate = publishDate;
        _currentVersion.mandatory = mandatory;
        _currentVersion.logDescription = logDescription;
    }
    return _currentVersion;
}
- (void)getCurrentVinCodeByDeviceSN:(NSString *)deviceSN compeltion:(void (^)(NSString *vinCode, TorqueResult *result))completion {
    TorqueResult *_result = [[TorqueResult alloc] init];
    if (!deviceSN) {
        if (!deviceSN) {
            _result.message = kMessage_deviceSnNotNull;
        }
        if (completion) {
            completion(nil,_result);
        }
        return;
    }
    [[TorqueDevice sharedInstance] getDevicesForUser:[TorqueGlobal sharedInstance].user compeltion:^(NSArray *devices, TorqueResult *result) {
        NSString *vin = nil;
        if (result.succeed) {
            if (devices) {
                
                for (DeviceInfo *info in devices) {
                    if ([info.sn isEqualToString:deviceSN]) {
                        vin = info.vinCode;
                        _result.result = 0;
                        _result.succeed = YES;
                        break;
                    }
                }
                if (!_result.succeed) {
                    _result.result = -1;
                    _result.message = kMessage_notFound;
                }
            } else {
                _result.result = -1;
                _result.message = kMessage_notFound;
            }
            if (completion) {
                completion(vin, _result);
            }
        } else {
            if (completion) {
                completion(nil, _result);
            }
        }
    }];
}
- (void)getQRCodeStringByUserId:(NSString *)userId deviceSN:(NSString *)deviceSN compeltion:(void (^)(NSString *codeString, TorqueResult *result))completion {
    TorqueResult *result = [[TorqueResult alloc] init];
    if (!deviceSN ||
        !userId) {
        if (!deviceSN) {
            result.message = kMessage_deviceSnNotNull;
        }
        if (!userId) {
            result.message = kMessage_userIdNotNull;
        }
        if (completion) {
            completion(nil,result);
        }
        return;
    }
    [self getObjectsAtPath:kGetBarCode
                parameters:kGetBarCodeParams(deviceSN, userId)
                   success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                       TorqueError *error = [[mappingResult dictionary] objectForKey:@"status"];
                       result.message = error.errorMessage;
                       
                       NSString *barCodeString = nil;
                       if (error.errorCode == 0) {
                           BarCode *barCode = [[mappingResult dictionary] objectForKey:@"result"];
                           if (barCode) {
                               result.succeed = YES;
                               result.result = 0;
                               barCodeString = barCode.encodeBarCode;
                           } else {
                               result.result = TorqueSDK_NerWorkOther;//-1;
                           }
                       }
                       if (completion) {
                           completion(barCodeString, result);
                       }
                   } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                       result.result = TorqueSDK_NetWorkFailed;//-1;
                       result.message = error.localizedDescription;
                       result.error = error;
                       if (completion) {
                           completion(nil, result);
                       }
                   }];
}

- (void)validateVinCode:(NSString *)vinCode compeltion:(void (^)(ValidateVinCode *validateVinCode, TorqueResult *result))completion {
    TorqueResult *result = [[TorqueResult alloc] init];
    if (!vinCode) {
        result.message = kMessage_vinCodeNotNull;
        if (completion) {
            completion(nil, result);
        }
        return;
    }
    vinCode = [vinCode uppercaseString];
    [self getObjectsAtPath:kValidateVinCode
                parameters:kValidateVinParams(vinCode)
                   success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                       TorqueError *error = [[mappingResult dictionary] objectForKey:@"status"];
                       result.message = error.errorMessage;
                       
                       ValidateVinCode *validateVinCode = nil;
                       if (error.errorCode == 0) {
                           validateVinCode = [[mappingResult dictionary] objectForKey:@"result"];
                           if (validateVinCode) {
                               result.succeed = YES;
                               result.result = 0;
                           } else {
                               result.result = TorqueSDK_NerWorkOther;//-1;
                           }
                       }
                       if (completion) {
                           completion(validateVinCode, result);
                       }
                   } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                       result.result = TorqueSDK_NetWorkFailed;//-1;
                       result.message = error.localizedDescription;
                       result.error = error;
                       if (completion) {
                           completion(nil, result);
                       }
                   }];
}

/**
 *  获取所有品牌信息
 *
 *  @param completion 完成时的回调block，succeed:YES[成功]/NO[失败], array为品牌信息列表
 */
- (void)getBrandInfoList:(void (^)(NSArray *array, TorqueResult *result))completion {
    TorqueResult *result = [[TorqueResult alloc] init];
    
    [self getObjectsAtPath:kGetBrandInfoList
                parameters:nil
                   success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                       TorqueError *error = [[mappingResult dictionary] objectForKey:@"status"];
                       result.message = error.errorMessage;
                       NSArray *info = nil;
                       if (error.errorCode == 0) {
                           info = [[mappingResult dictionary] objectForKey:@"result"];
                           if (info) {
                               result.succeed = YES;
                               result.result = 0;
                           }
                       }
                       if (completion) {
                           completion(info, result);
                       }
                   } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                       result.message = error.localizedDescription;
                       result.error = error;
                       result.result = TorqueSDK_NetWorkFailed;
                       if (completion) {
                           completion(nil, result);
                       }
                   }];
}
/**
 *  通过品牌ID查询车系信息
 *
 *  @param brandId    品牌ID
 *  @param completion 完成时的回调block，succeed:YES[成功]/NO[失败], array为车系信息列表
 */
- (void)getSeriesInfoListByBrandId:(NSNumber *)brandId completion:(void (^)(NSArray *array, TorqueResult *result))completion {
    TorqueResult *result = [[TorqueResult alloc] init];
    
    [self getObjectsAtPath:kGetSeriesInfoList
                parameters:kGetSeriesInfoListParams(brandId)
                   success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                       TorqueError *error = [[mappingResult dictionary] objectForKey:@"status"];
                       result.message = error.errorMessage;
                       NSArray *info = nil;
                       if (error.errorCode == 0) {
                           info = [[mappingResult dictionary] objectForKey:@"result"];
                           if (info) {
                               result.succeed = YES;
                               result.result = 0;
                           }
                       }
                       if (completion) {
                           completion(info, result);
                       }
                   } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                       result.message = error.localizedDescription;
                       result.error = error;
                       result.result = TorqueSDK_NetWorkFailed;
                       if (completion) {
                           completion(nil, result);
                       }
                   }];
}
/**
 *  通过车系ID查询车型信息
 *
 *  @param seriesId    车系ID
 *  @param completion 完成时的回调block，succeed:YES[成功]/NO[失败], array为车型信息列表
 */
- (void)getModelInfoListBySeriesId:(NSNumber *)seriesId completion:(void (^)(NSArray *array, TorqueResult *result))completion {
    TorqueResult *result = [[TorqueResult alloc] init];
    
    [self getObjectsAtPath:kGetModelInfoList
                parameters:kGetModelInfoListParams(seriesId)
                   success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                       TorqueError *error = [[mappingResult dictionary] objectForKey:@"status"];
                       result.message = error.errorMessage;
                       NSArray *info = nil;
                       if (error.errorCode == 0) {
                           info = [[mappingResult dictionary] objectForKey:@"result"];
                           if (info) {
                               result.succeed = YES;
                               result.result = 0;
                           }
                       }
                       if (completion) {
                           completion(info, result);
                       }
                   } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                       result.message = error.localizedDescription;
                       result.error = error;
                       result.result = TorqueSDK_NetWorkFailed;
                       if (completion) {
                           completion(nil, result);
                       }
                   }];
}
@end
