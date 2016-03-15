//
//  DataProcessor.m
//  OBD-DEMO
//
//  Created by zhangjipeng on 1/26/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import "DataProcessor.h"
#import "DataStreamFactory.h"
#import "OBDDataItem.h"

#import "NSString+CompatibleMehod.h"

@interface DataProcessor ()
{
    NSDictionary *errors;
    void (^suspendedCompletion)(OBDDataStream *stream, NSError *error);
    dispatch_semaphore_t sema;
}

@property (nonatomic, assign) OBDDataStreamType readDataStreamType;
@property (nonatomic, strong) NSMutableDictionary *typeAndCompletion;
@property (nonatomic, strong) NSMutableDictionary *specialTypeAndCompletion;
/**
 *  超时字典
 */
@property (nonatomic, strong) NSMutableDictionary *timeOutDict;
/**
 *  pid命令返回数据字典
 */
@property (nonatomic, strong) NSMutableDictionary *pidReturnDataDict;
/**
 *  pid命令列表，用于判断超时
 */
@property (nonatomic, strong) NSMutableArray *pidCommandArray;

@property (nonatomic, copy) void(^processValueCompletionBlock)(BOOL isSpeicalType, OBDDataStreamType type, OBDDataStream *stream, NSError *error);

@end

@implementation DataProcessor

+ (instancetype)sharedInstance {
    static DataProcessor *dataProcessor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataProcessor = [DataProcessor new];
        DDLogVerbose(@"Created dataProcessor!");
    });
    return dataProcessor;
}

- (NSDictionary *)errors {
    if (errors) {
        return errors;
    } else {
        NSString *resourceName = [@"DataStreamConfig" stringByAppendingString:kDeviceName];
        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:resourceName ofType:@"bundle"];
        if (resourcePath.length > 0) {
            NSBundle *bundle = [[NSBundle alloc] initWithPath:resourcePath];
            NSString *filePath = [bundle pathForResource:@"obdError" ofType: @"json"];
            
            NSData *data = [NSData dataWithContentsOfFile:filePath];
            if (!data) {
                NSLog(@"the datastream config file obdError.json not found!");
                return nil;
            }
            
            errors = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            return errors;
        } else {
            NSLog(@"the bundle %@ not found!",resourceName);
            return nil;
        }
    }
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)init {
    if (self = [super init]) {
        _typeAndCompletion = [NSMutableDictionary dictionary];
        _specialTypeAndCompletion = [NSMutableDictionary dictionary];
        _obdMode = OBDModeNormal;
        sema = dispatch_semaphore_create(0);
        
        _log = ^(NSString *value) { };
        __weak DataProcessor *weakSelf = self;
        
        [[NSNotificationCenter defaultCenter] addObserverForName:kTorqueNetworkReachabilityStatusOFF object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.errorHandler) {
                    weakSelf.errorHandler(@"与网络断开连接");
                }
            });
        }];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:kNotifactionDisConnectedInSDK object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.errorHandler) {
                    weakSelf.errorHandler(kDeviceDisConnectedString);
                }
            });
        }];
        
        _dataReceived = ^(NSString *value) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                DDLogVerbose(@"value:%@",value);
                
                if (weakSelf.log) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakSelf.log(value);
                    });
                }
                
                if ([weakSelf processError:value]) {
                    return;
                }
                
                switch (weakSelf.obdMode) {
                    case OBDModeNormal:
                    {
                        NSArray *allKeys = [weakSelf.typeAndCompletion allKeys];
                        for (NSNumber *type in allKeys) {
                            DDLogVerbose(@"try to process value by type: %ld",(long)type.integerValue);
#if 1
                            if ([weakSelf processValue:value forType:type.integerValue]) {
                                return;
                            }
#else
                            if ([weakSelf processValueUpdate:value forType:type.integerValue]) {
                                return;
                            }
#endif
                            DDLogVerbose(@"try to next type");
                        }
                        DDLogVerbose(@"no appropriate type to process value !\n");
                    }
                        break;
                        
                    case OBDModePID:
                    {
                        NSArray *allKeys = [weakSelf.specialTypeAndCompletion allKeys];
                        for (NSString *type in allKeys) {
                            DDLogVerbose(@"try to process value by type: %@",type);
                            [weakSelf pidCommandProcessValue:value forType:type];
                            DDLogVerbose(@"try to next type");
                        }
                        DDLogVerbose(@"no appropriate type to process value !\n");
                    }
                        break;
                        
                        
                    case OBDModeUpgrade:
                    {
                        NSArray *allKeys = [weakSelf.specialTypeAndCompletion allKeys];
                        for (NSNumber *type in allKeys) {
                            DDLogVerbose(@"try to process value by type : %ld",(long)type.integerValue);
                            if ([weakSelf specialProcessValue:value forType:type.integerValue]) {
                                return;
                            }
                            DDLogVerbose(@"try to next type");
                        }
                        DDLogVerbose(@"no appropriate type to process value !\n");
                    }
                        break;
                        
                    default:
                        break;
                }
            });
        };
        
        // 初始化处理数据完成回调
        __weak typeof(self) weakself = self;
        _processValueCompletionBlock = ^(BOOL isSpeicalType, OBDDataStreamType type, OBDDataStream *stream, NSError *error){
            // 根据当前类型，从监视字典中查找对应的回调
            void (^completion)(OBDDataStream *stream, NSError *error) = isSpeicalType ?
            [[weakself.specialTypeAndCompletion objectForKeyedSubscript:@(type)] copy]:
            [[weakself.typeAndCompletion objectForKeyedSubscript:@(type)] copy];
            if (!completion) {
                DDLogVerbose(@"processValue_类型为:%ld的回调未找到", (long)type);
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(stream, error);
            });
            
            if (stream.disposable) {
                DDLogVerbose(@"remove disposable processor for type: %ld\n", (long)type);
                if (isSpeicalType) {
                    [weakself.specialTypeAndCompletion removeObjectForKey:@(type)];
                } else {
                    [weakself.typeAndCompletion removeObjectForKey:@(type)];
                }
            }
            
            DDLogVerbose(@"did process value by type: %ld",(long)type);
        };
    }
    return self;
}


- (void)setObdMode:(OBDMode)obdMode {
    @synchronized(self) {
        if (_obdMode == obdMode) {
            return;
        }
        [self.specialTypeAndCompletion removeAllObjects];
        _obdMode = obdMode;
        
        if (_obdMode == OBDModeNormal) {
            DDLogError(@"Enter Normal Mode");
        } else if (_obdMode == OBDModePID) {
            DDLogError(@"Enter PID Mode");
        } else if (_obdMode == OBDModeUpgrade) {
            DDLogError(@"Enter Upgrade Mode");
        }
    }
}
//
///**
// *  获取数据头
// *
// *  @param string obd读取到的数据
// *
// *  @return 获取数据头 比如:$EST530,+HIS: 
// *  warning  obd传回的时间也有:哦！！！！！
// */
//- (NSString *)getDataHead:(NSString *)string
//{
//    NSString *terminalstring = nil;
//    
//    NSRange ran = [string rangeOfString:@":" options:NSCaseInsensitiveSearch];
//    if ((ran.location != NSNotFound) && (ran.length > 0)) {
//        terminalstring = [string substringToIndex:ran.location];
//    }
//    DDLogVerbose(@"getDataHead terminalstring = %@",terminalstring);
//    return terminalstring;
//}

/**
 *  获取消息头
 *
 */
- (NSString *)getHeadData:(NSString *)value
{
    NSArray *array = [value componentsSeparatedByString:@":"];
    
    if (!array || array.count < 2) {
        return nil;
    }
    
    return array[0];
}

/**
 *  获取数据项格式
 *
 *  @param string obd读取到的数据
 *
 *  @return 返回数据项原格式
 */
- (NSString *)getDataItems:(NSString *)string
{
    NSString *terminalstring = nil;
    
    NSRange ran = [string rangeOfString:@":" options:NSCaseInsensitiveSearch];
    if ((ran.location != NSNotFound) && (ran.length > 0)) {
        if (ran.location + 1 <= [string length]) {
            terminalstring  = [string substringFromIndex:(ran.location+1)];
        }
    }
    DDLogVerbose(@"getDataItems terminalstring = %@",terminalstring);
    return terminalstring;
}

/**
 *  检测返回的数据头是否正确
 *
 *  @param referenceString json文件定义的dataHead
 *  @param targetString    从OBD读取的data
 *
 *  @return 数据头是否正确
 */
- (BOOL)checkHeadValidWithReference:(NSString *)referenceHead toTarget:(NSString *)targetHead {
    DDLogVerbose(@"checkDataValidWithReference referenceHead = %@ targetHead = %@",referenceHead,targetHead);
    //采用 : 进行分割协议
    
    NSArray *array = [targetHead componentsSeparatedByString:@":"];
    
    if (!array || array.count < 2) {
        return NO;
    }
    return [array[0] isEqualToString:referenceHead];
}

- (BOOL)processError:(NSString *)value {
    @synchronized(self){
        
        __block typeof(self) weakself = self;
        OBDDataStream *stream = [DataStreamFactory dataStreamForType:OBDDataStreamTypeError];
        if ([value hasPrefix:stream.dataHead]) {
            // 去除数据头（dataHead）及其后的符号
            NSUInteger headLenth = [stream.dataHead length];
            NSString *valueNoHead = [value substringFromIndex:headLenth + 1];
            
            DDLogVerbose(@"%@",stream.name);
            DDLogVerbose(@"%@",stream.dataHead);
            
            // 分割数据项
            NSString *split = [stream.splitString length] ? stream.splitString : @"\r";
            NSArray *components = [valueNoHead componentsSeparatedByString:split];
            NSArray *items = stream.items;
            NSInteger index = 0;
            for (NSString *component in components) {
                if (index >= [items count]) {
                    // error
                    DDLogWarn(@"process value error! the count of items in datastream file is not correct!\n");
                    return YES;
                }
                
                if ([items count]) {
                    OBDDataItem *item = items[index];
                    NSString *rawValue = nil;
                    if ([[item splitString] length]) {
                        NSArray *datas = [component componentsSeparatedByString:[item splitString]];
                        rawValue = [datas lastObject];
                    } else {
                        rawValue = component;
                    }
                    
                    if (item.unit.length) {
                        item.value = [rawValue stringByReplacingOccurrencesOfString:item.unit withString:@""];
                    } else {
                        item.value = rawValue;
                    }
                    
                    DDLogVerbose(@"%@ = %@%@",item.itemName,item.value,item.unit);
                    
                    index++;
                }
            }
            
            
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSArray *array = stream.items;
                    OBDDataItem *item = [array firstObject];
                    if (weakself.errorHandler) {
                        weakself.errorHandler(item.value);
                    }
                });
            
            return YES;
        }
        return NO;
    }
}

/**
 *  处理normal command
 *
 *  @param value OBD获取的数据
 *  @param type  当前要处理的command的type
 *
 *  @return 返回数据是否正确
 */
- (BOOL)processValueUpdate:(NSString *)value forType:(OBDDataStreamType)type
{
     __block typeof(self) weakself = self;
    __block BOOL isDataValid = NO;
    __block BOOL isValidSourceData = NO;
    __block BOOL isValidSourceItems = NO;
    
    @synchronized(self) {
//        根据type 获取json中得dataHead
        OBDDataStream *stream = [DataStreamFactory dataStreamForType:type];
        DDLogVerbose(@"当前的head = %@  源数据位%@",stream.dataHead,value);
        
        if ((type == OBDDataStreamTypeHistoryTripRecord) && value && [value containsStringDiffFromVersion:@"$EST530,+HISEND:OK"]) {
            NSError *error = [NSError errorWithDomain:@"com.saike.cn" code:1050 userInfo:[NSDictionary dictionaryWithObject:@"批量读取成功" forKey:NSLocalizedDescriptionKey]];
            
            if (_processValueCompletionBlock) {
                _processValueCompletionBlock(NO, type, stream, error);
            }
            return YES;
        }
        
//        检测数据头是否有效
        isValidSourceData = [weakself checkHeadValidWithReference:stream.dataHead toTarget:value];
        
//        如果数据头有效，则检测数据项是否个数正确
        if (isValidSourceData) {
            
            NSString *sourceItems = [self getDataItems:value];
            if ([sourceItems length] > 0){
                
//                获取json文件定义的items
                 NSArray *items = stream.items;
                
//                使用json文件的item的分隔符进行数据分隔
                NSString *split = [stream.splitString length] ? stream.splitString : @"\r";
                NSArray *components = [sourceItems componentsSeparatedByString:split];
                
//                只有items 相同，才处理数据
                if([components count] == [items count])
                {
//                    数据有效
                    isValidSourceItems = YES;
                    
                    NSString *rawValue = nil;
                    
                    for(NSUInteger index = 0;index < [items count];index++)
                    {
                        OBDDataItem *item = items[index];
                        
                        rawValue = nil;
                        
                        if ([[item splitString] length] <= 0)
                        {
                            rawValue = components[index];
                        }
                        else
                        {
                            NSArray *datas = [components[index] componentsSeparatedByString:[item splitString]];
                            rawValue = [datas lastObject];
                        }
                        
                        if ([item.unit length] > 0) {
                            item.value = [rawValue stringByReplacingOccurrencesOfString:item.unit withString:@""];
                        } else {
                            item.value = rawValue;
                        }
                        
                        DDLogVerbose(@"数据项 %@ = %@%@",item.itemName,item.value,item.unit);
                        
                    }//for  处理item的value
                }//if  处理items
            }//
            
        }//数据头有效
        
//      returnvalue
        isDataValid = NO;
        if(isValidSourceData && isValidSourceItems)
        {
            isDataValid = YES;
            if (_processValueCompletionBlock) {
                _processValueCompletionBlock(NO, type, stream, nil);
            }
        }
        else
        {
            if ((type == OBDDataStreamTypeHistoryTripRecord) || (type == OBDDataStreamTypeEngineIdling))
            {
                if (_processValueCompletionBlock) {
                    _processValueCompletionBlock(NO, type, stream, nil);
                }
            }
        }
        
       return isDataValid;
    };//@synchronized
}

- (BOOL)processValue:(NSString *)value forType:(OBDDataStreamType)type {
    @synchronized(self) {
        // 根据当前类型，从配置文件中实例化出协议对象
        OBDDataStream *stream = [DataStreamFactory dataStreamForType:type];
        
        // 如果协议对象为空，返回NO
        if (!stream) {
            if (!stream) {
                DDLogVerbose(@"processValue_从json文件解析协议对象失败");
            }
            return NO;
        }
        
        // 异常数据解析,判断收到数据是否为异常数据，如果为异常数据，则返回
        // 去除数据头（dataHead）及其后的符号
        NSUInteger headLenth = [stream.dataHead length];
        if (value.length <= headLenth) {
            //////////////////GSY    ？和null FF数据
            DDLogVerbose(@"接收到的异常数据:%@",value);
            NSError *error = [NSError errorWithDomain:@"com.saike.cn"
                                                 code:106
                                             userInfo:@{ NSLocalizedDescriptionKey : @"返回的数据格式头不正确" }];
            if (_processValueCompletionBlock) {
                _processValueCompletionBlock(NO, type, stream, error);
            }
            return NO;
        }
        
        // 解析数据
        // 按协议头匹配数据，匹配不到：返回NO，匹配到：（1）解析数据、封装数据 （2）回调（3）判断是否需要把当前类型从监视字典移除，
        
        BOOL isEqual = NO;
        
        //        批量读取行程结束标示 特殊处理
        if (type == OBDDataStreamTypeHistoryTripRecord) {
            
            OBDDataStream *tripEndStream = [DataStreamFactory dataStreamForType:OBDDataStreamTypeFetchHistoryTripEnd];
            if([[self getHeadData:value] isEqualToString:tripEndStream.dataHead]){
                NSError *error = [NSError errorWithDomain:@"com.saike.cn" code:999 userInfo:[NSDictionary dictionaryWithObject:@"本批行程读取成功" forKey:NSLocalizedDescriptionKey]];
                
                if (_processValueCompletionBlock) {
                    _processValueCompletionBlock(NO, type, stream, error);
                }
                
                return YES;
            }
        }
#if 1
        isEqual = [self checkHeadValidWithReference:stream.dataHead toTarget:value];
#else
        isEqual = [[value substringToIndex:headLenth] isEqualToString:stream.dataHead];
#endif
        
        if (isEqual) {
            DDLogVerbose(@"%@",stream.name);
            DDLogVerbose(@"%@",stream.dataHead);
            NSString *valueNoHead = [value substringFromIndex:headLenth + 1];
            
            // 分割数据项
            NSString *split = [stream.splitString length] ? stream.splitString : @"\r";
            NSArray *components = [valueNoHead componentsSeparatedByString:split];
            NSArray *items = stream.items;
            NSInteger index = 0;
            for (NSString *component in components) {
                if (index >= [items count]) {
                    // error
                    DDLogError(@"process value error! the count of items in datastream file is not correct!\n");
                    
                    // 例如:$EST530,+HIS:728,2015-09-13 20:54:44,2015-09-13 20:54:$EST530,+OBDRT:11.9,14895,0,36.47,28.63,53,60.83,0.00,0.00,0,0.30,5.56,0,0,0,0,36
                    if (type == OBDDataStreamTypeHistoryTripRecord) {
                        NSError *error = [NSError errorWithDomain:@"com.saike.cn" code:106 userInfo:[NSDictionary dictionaryWithObject:@"返回的数据格式头不正确" forKey:NSLocalizedDescriptionKey]];
                        
                        if (_processValueCompletionBlock) {
                            _processValueCompletionBlock(NO, type, stream, error);
                        }
                    }
                    
                    return YES;
                }
                
                if ([items count]) {
                    OBDDataItem *item = items[index];
                    NSString *rawValue = nil;
                    if ([[item splitString] length]) {
                        NSArray *datas = [component componentsSeparatedByString:[item splitString]];
                        rawValue = [datas lastObject];
                    } else {
                        rawValue = component;
                    }
                    
                    if (item.unit.length) {
                        item.value = [rawValue stringByReplacingOccurrencesOfString:item.unit withString:@""];
                    } else {
                        item.value = rawValue;
                    }
                    
                    DDLogVerbose(@"%@ = %@%@",item.itemName,item.value,item.unit);
                    
                    index++;
                }
            }
            
            if (_processValueCompletionBlock) {
                _processValueCompletionBlock(NO, type, stream, nil);
            }
            return YES;
        }
        return NO;
    }
}

- (BOOL)specialProcessValue:(NSString *)value forType:(OBDDataStreamType)type {
    
    @synchronized(self) {
        OBDDataStream *stream = [DataStreamFactory dataStreamForType:type];
        NSArray *marks = [stream.dataHead componentsSeparatedByString:@","];
        for (NSString *mark in marks) {
            if ([value isEqualToString:mark]) {
                OBDDataItem *item = [stream.items firstObject];
                item.value = value;
                
                DDLogVerbose(@"%@",stream.name);
                DDLogVerbose(@"%@ = %@%@",item.itemName,item.value,item.unit);
                
                if (_processValueCompletionBlock) {
                    _processValueCompletionBlock(YES, type, stream, nil);
                }
                return YES;
            }
        }
        
        return NO;
    }
}
/**
 *  PID命令返回数据处理逻辑
 *
 *  @param value 返回数据
 *  @param type  类型
 */
- (void)pidCommandProcessValue:(NSString *)value forType:(NSString *)type {
    @synchronized(self) {
        DDLogVerbose(@"value = %@",value);
        NSString *pidReturnData = [self.pidReturnDataDict objectForKeyedSubscript:type];
        // 如果字典中没有保存，则当返回返回数据，否则使用保存数据追加当前返回数据
        pidReturnData = (!pidReturnData) ? value : [NSString stringWithFormat:@"@%\r%@", pidReturnData, value];
        
        // 保存数据到字典中
        [self.pidReturnDataDict setObject:pidReturnData forKey:type];
        
        // 数据回调见 requestPID::
    }
}

- (void)fetchDataStreamForType:(OBDDataStreamType)type AndParam:(NSString*)param completion:(void (^)(OBDDataStream *stream, NSError *error))completion {
    OBDDataStream *stream = [DataStreamFactory dataStreamForType:type];
    
    NSData *data = [self dataFromATCommand:stream.command AndParam:param];
    if (data) {
        [self.connector sendData:data];
    }
    
    if (!completion) {
        return;
    }
    
    if (self.obdMode == OBDModeNormal) {
        [self.typeAndCompletion setObject:completion forKey:@(type)];
    } else if (self.obdMode == OBDModeUpgrade ||
               self.obdMode == OBDModePID) {
        [self.specialTypeAndCompletion setObject:completion forKey:@(type)];
    }
    
    DDLogVerbose(@"Set processor for type: %ld", (long)type);
    
    // 是否是一次性的，例如：一发一收方式的AT命令都是YES，实时数据流为NO 或者是百公里测试结束状态位 或者行程记录结束状态位时
    if (!stream.disposable ||
        type == OBDDataStreamTypeACCEnd ||
        type == OBDDataStreamTypeFetchHistoryTripEnd) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    // 添加全局消息发送超时逻辑
    [self startTimeout:(self.obdMode == OBDModeUpgrade ||
                        type == OBDDataStreamTypeEnterUpgradeMode) ? kUpgradeWaitReadyTimeout : kATBackCallTimer * 2
            completion:^(TorqueResult *result) {
                // 发出指令后，接收到盒子返回的最大间隔后仍未收到返回数据，则将回调从字典中移除
                void (^completion)(NSString *value, NSError *error) = nil;
                if (weakSelf.obdMode == OBDModeNormal) {
                    completion = [weakSelf.typeAndCompletion objectForKey: @(type)];
                } else {
                    completion = [weakSelf.specialTypeAndCompletion objectForKey: @(type)];
                }
                
                if (completion) {
                    if (weakSelf.obdMode == OBDModeNormal) {
                        [weakSelf.typeAndCompletion removeObjectForKey:@(type)];
                    } else {
                        [weakSelf.specialTypeAndCompletion removeObjectForKey:@(type)];
                    }
                    DDLogVerbose(@"remove disposable processor for type: %@\n", @(type));
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(nil, [NSError errorWithDomain:@"com.torque" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"timeOut"}]);
                    });
                }
            }];
    
}

- (void)closeDataStreamForType:(OBDDataStreamType)type {
    [self.typeAndCompletion removeObjectForKey:@(type)];
    DDLogVerbose(@"Remove processor for type: %ld\n", (long)type);
}

- (void)closeSpecialDataStreamForType:(OBDDataStreamType)type {
    [self.typeAndCompletion removeObjectForKey:@(type)];
    [self.specialTypeAndCompletion removeObjectForKey:@(type)];
    DDLogVerbose(@"Remove special processor for type: %ld\n", (long)type);
}

- (void)suspendDataStreamForType:(OBDDataStreamType)type {
    suspendedCompletion = [[self.typeAndCompletion objectForKeyedSubscript:@(type)] copy];
    if (suspendedCompletion) {
        [self.typeAndCompletion removeObjectForKey:@(type)];
    }
}

- (void)resumeDataStreamForType:(OBDDataStreamType)type {
    if (suspendedCompletion) {
        [self.typeAndCompletion setObject:suspendedCompletion forKey:@(type)];
    }
}

- (NSData *)dataFromATCommand:(NSString *)command AndParam:(NSString *)param {
    NSString *paramString = param ? [NSString stringWithFormat:@"=%@",param] : @"";
    NSString *commandString = [NSString stringWithFormat:@"%@%@",command, paramString];
    
    if ([commandString hasPrefix:@"="]) {
        commandString = [commandString substringFromIndex:1];
    }
    
    if (commandString && [commandString length] != 0 && ![commandString isEqualToString:@"="]) {
        NSData * data = [[commandString stringByAppendingString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding];
        DDLogVerbose(@"ATCommand:%@", commandString);
        return data;
    } else {
        return nil;
    }
}

- (void)upgradeHandshake:(void (^)(OBDDataStream *stream, NSError *error))completion {
    [self.specialTypeAndCompletion setObject:completion forKey:@(OBDDataStreamTypeUpgradeHandshake)];
    DDLogVerbose(@"Set processor for type: %ld", (long)OBDDataStreamTypeUpgradeHandshake);
    
    Byte handshakeSign = kOBDUpgradeHandshake;
    NSData *data = [[NSData alloc] initWithBytes:&handshakeSign length:sizeof(Byte)];
    for (int i = 0; i < 15; i++) {
        DDLogVerbose(@"Send Handshake Sign %lX",(long)kOBDUpgradeHandshake);
        [self.connector sendData:data];
    }
}

- (void)upgradeSendPackage:(NSData *)package completion:(void (^)(OBDDataStream *stream, NSError *error))completion {
    if (![self.specialTypeAndCompletion objectForKey:@(OBDDataStreamTypeUpgradeSendPackage)]) {
        [self.specialTypeAndCompletion setObject:completion forKey:@(OBDDataStreamTypeUpgradeSendPackage)];
        DDLogVerbose(@"Set processor for type: %ld", (long)OBDDataStreamTypeUpgradeSendPackage);
    }
    
    [self.connector sendData:package];
}

- (void)upgradeSendPackageCompleted:(void (^)(OBDDataStream *stream, NSError *error))completion {
    [self.specialTypeAndCompletion setObject:completion forKey:@(OBDDataStreamTypeUpgradeSendPackageEnd)];
    DDLogVerbose(@"Set processor for type: %ld", (long)OBDDataStreamTypeUpgradeSendPackageEnd);
    
    Byte SendPackageEndSign = kOBDUpgradePackageSendEnd;
    NSData *data = [[NSData alloc] initWithBytes:&SendPackageEndSign length:sizeof(Byte)];
    DDLogVerbose(@"Send Package Completed Sign %lX",(long)kOBDUpgradePackageSendEnd);
    [self.connector sendData:data];
    DDLogVerbose(@"Send Package Completed Sign %lX",(long)kOBDUpgradePackageSendEnd);
    [self.connector sendData:data];
}

- (void)upgradeSendBinFileLength:(UInt16)length completion:(void (^)(OBDDataStream *stream, NSError *error))completion {
    [self.specialTypeAndCompletion setObject:completion forKey:@(OBDDataStreamTypeUpgradeSendBinLength)];
    DDLogVerbose(@"Set processor for type: %ld", (long)OBDDataStreamTypeUpgradeSendBinLength);
    
    UInt16 h = (length & 0xFF00) >> 8;
    UInt16 l = (length & 0x00FF) << 8;
    UInt16 size = h | l;
    NSData *data = [[NSData alloc] initWithBytes:&size length:sizeof(UInt16)];
    DDLogVerbose(@"Send Bin File Length: %ld",(long)length);
    [self.connector sendData:data];
}

- (void)upgradeSendBinFileCompleted:(void (^)(OBDDataStream *stream, NSError *error))completion{
    [self.specialTypeAndCompletion setObject:completion forKey:@(OBDDataStreamTypeUppradeSendBinEnd)];
    DDLogVerbose(@"Set processor for type: %ld", (long)OBDDataStreamTypeUppradeSendBinEnd);
    
    Byte SendBinFileEndSign = kOBDUpgradeBinFileSendEnd;
    NSData *data = [[NSData alloc] initWithBytes:&SendBinFileEndSign length:sizeof(Byte)];
    DDLogVerbose(@"Send Bin File Completed Sign %lX",(long)kOBDUpgradeBinFileSendEnd);
    [self.connector sendData:data];
    DDLogVerbose(@"Send Bin File Completed Sign %lX",(long)kOBDUpgradeBinFileSendEnd);
    [self.connector sendData:data];
}
- (void)requestPID:(NSString *)pid completion:(void (^)(NSString *value, NSError *error))completion {
    if (![self.specialTypeAndCompletion objectForKey:pid]) {
        [self.specialTypeAndCompletion setObject:completion forKey:pid];
        DDLogVerbose(@"Set processor for type: %@", pid);
    }
    NSData *data = [self dataFromATCommand:pid AndParam:nil];
    [self.connector sendData:data];
    
    __weak typeof(self) weakSelf = self;
    // 超时block，保证每次可以接收到完整的数据
    void(^timeOutBlock)(NSError *error, BOOL timeOut) = ^(NSError *error, BOOL timeOut) {
        // 移除超时对象中的回调
        for (TimeOutObject *timeOutObj in weakSelf.timeOutDict) {
            if ([timeOutObj isKindOfClass:[TimeOutObject class]]) {
                [timeOutObj clean];
            }
        }
        
        [weakSelf.pidCommandArray removeAllObjects];
        [weakSelf.timeOutDict removeAllObjects];
        
        NSString *pidReturnData = [self.pidReturnDataDict objectForKeyedSubscript:pid];
        
        DDLogVerbose(@"return pid value = %@",pidReturnData);
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(pidReturnData, nil);
                dispatch_semaphore_signal(sema);
            });
            
            DDLogVerbose(@"did process value by type: %@",pid);
            DDLogVerbose(@"remove disposable processor for type: %@\n", pid);
            [weakSelf.specialTypeAndCompletion removeObjectForKey:pid];
            [weakSelf.pidReturnDataDict removeObjectForKey:pid];
        }
    };
    if (!self.pidCommandArray) {
        self.pidCommandArray = [[NSMutableArray alloc] init];
    }
    if (!self.timeOutDict) {
        self.timeOutDict = [NSMutableDictionary dictionary];
    }
    if (!self.pidReturnDataDict) {
        self.pidReturnDataDict = [NSMutableDictionary dictionary];
    }
    
    // 添加超时逻辑
    TimeOutObject *timeOutOjb = [TimeOutObject new];
    [timeOutOjb startTimeout:0.5
            targetWithString:pid
                     content:self.pidCommandArray
                  completion:timeOutBlock];
    [self.timeOutDict setObject:timeOutOjb forKey:pid];
    [self.pidCommandArray addObject:pid];
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}
@end
