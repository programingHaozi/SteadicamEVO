//
//  TorqueCarDetection.m
//  TorqueSDK
//
//  Created by zhangjipeng on 1/29/15.
//  Copyright (c) 2015 chexiang. All rights reserved.
//

#import "TorqueCarDetection.h"
#import "TorqueGlobal.h"

#import "OBDDevice+PIDMode.h"
#import "TroubleCode.h"
#import "JsonRequestForPID.h"
#import "NSString+Date.h"
#import "SBJson4.h"

typedef void(^DetectCallback)(NSInteger itemCount, NSInteger troubleCodeCount, NSString *examId, TorqueResult *result);
@interface TorqueCarDetection() {
    dispatch_semaphore_t sema;
    CGFloat progress;
}

@property (nonatomic, copy) DetectCallback completionBlock;

@end
@implementation TorqueCarDetection

+ (instancetype)sharedInstance {
    static TorqueCarDetection *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [TorqueCarDetection new];
    });
    
    return instance;
}

- (id)init {
    if (self = [super init]) {
        sema = dispatch_semaphore_create(0);
        progress = 0;
    }
    return self;
}

#pragma mark - Private Method
- (void)createDescriptors {
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    // device
    RKObjectMapping *detectionHistoryReportMapping = [RKObjectMapping mappingForClass:[DetectReportPage class]];
    /*
     {
     "result":{"is_page":"0",//是否分页,1:分页,0:不分页,默认0
     "page_size":"10",//每页条数,默认10
     "page_num":"1",//当前返回的第几页
     "total_page":"10",//共几页
     "total_row":70,//一共有几条记录
     "examReport":[{"create_time":"2015-05-01 13:20:13",//检测时间
     "error_num":"1",//故障码数量
     "score":"85",//分数
     "result":"总体结论",//结论
     "id":"123",//检测报告ID
     "detail":"https://box.dds.com/pid/getExamReportDetail?examId=123"//检测报告详情
     }]
     },
     "status":{"errorCode": "0",
     "errorMessage":"成功"}
     }
     */
    [detectionHistoryReportMapping addAttributeMappingsFromDictionary:@{@"is_page" : @"isPage",
                                                             @"page_size" : @"pageSize",
                                                             @"page_num" : @"pageNum",
                                                             @"total_page" : @"totalPages"}];
    RKObjectMapping *reportModelMapping = [RKObjectMapping mappingForClass:[DetectionReport class]];
    [reportModelMapping addAttributeMappingsFromDictionary:@{@"create_time":@"createTime",
                                                             @"error_num" : @"errorCodeNumber",
                                                             @"score" : @"score",
                                                             @"result" : @"result",
                                                             @"id" : @"detectionId",
                                                             @"detail" : @"detail"
                                                             }];
    [detectionHistoryReportMapping addRelationshipMappingWithSourceKeyPath:@"examReport" mapping:reportModelMapping];
    
    [self responseDescriptorWithMapping:detectionHistoryReportMapping
                                 method:RKRequestMethodGET
                                   path:kGetExamReports
                            pathPattern:nil
                                keyPath:@"result"
                            statusCodes:statusCodes];
    
    // pidCommand mapping request
    RKObjectMapping *jsonRequestMapping = [RKObjectMapping requestMapping];
    [jsonRequestMapping addAttributeMappingsFromDictionary:@{@"jsonString" : @"jsonStr",
                                                             @"userId" : @"userId",
                                                             @"deviceId" : @"deviceId",
                                                             @"carId" : @"carId",
                                                             @"examId" : @"examId"}];
    
    [self requestDescriptorWithMapping:jsonRequestMapping
                           objectClass:[JsonRequest class]
                                method:RKRequestMethodPOST
                                  path:kGetSupportPIDs
                           rootKeyPath:nil];
    // PidCommand mapping
    RKObjectMapping *pidCommandMapping = [RKObjectMapping mappingForClass:[PidCommand class]];
    [pidCommandMapping addAttributeMappingsFromDictionary:@{@"name" : @"name",
                                                            @"description" : @"descriptionContent",
                                                            @"explan" : @"explain"}];
    
    // 获取支持的PID列表
    RKObjectMapping *supportPIDsMapping = [RKObjectMapping mappingForClass:[PidModel class]];
    [supportPIDsMapping addAttributeMappingsFromDictionary:@{@"pid":@"pid"}];
    [supportPIDsMapping addRelationshipMappingWithSourceKeyPath:@"commands" mapping:pidCommandMapping];
    
    [self responseDescriptorWithMapping:supportPIDsMapping
                                 method:RKRequestMethodPOST
                                   path:kGetSupportPIDs
                            pathPattern:nil
                                keyPath:@"result"
                            statusCodes:statusCodes];
    
    // 获取PID指令的具体含义
//    RKObjectMapping *jsonRequestMapping = [RKObjectMapping requestMapping];
//    [jsonRequestMapping addAttributeMappingsFromDictionary:@{@"jsonString" : @"jsonStr",
//                                                           @"userId" : @"userId",
//                                                           @"deviceId" : @"deviceId",
//                                                           @"carId" : @"carId",
//                                                           @"examId" : @"examId"}];
    [self requestDescriptorWithMapping:jsonRequestMapping
                           objectClass:[JsonRequest class]
                                method:RKRequestMethodPOST
                                  path:kGetDetailPID
                           rootKeyPath:nil];

    [self responseDescriptorWithMapping:pidCommandMapping
                                 method:RKRequestMethodPOST
                                   path:kGetDetailPID
                            pathPattern:nil
                                keyPath:@"result"
                            statusCodes:statusCodes];
    // 获取故障码
    RKObjectMapping *troubleCodeMapping = [RKObjectMapping mappingForClass:[TroubleCode class]];
    [troubleCodeMapping addAttributeMappingsFromDictionary:@{@"errorCode" : @"troubleCode",
                                                             @"description" : @"descriptionContent"}];
//    RKObjectMapping *troubleCodeReqMapping = [RKObjectMapping requestMapping];
//    [troubleCodeReqMapping addAttributeMappingsFromDictionary:@{@"jsonString" : @"jsonStr",
//                                                             @"userId" : @"userId",
//                                                             @"deviceId" : @"deviceId",
//                                                             @"carId" : @"carId",
//                                                             @"examId" : @"examId"}];
    [self requestDescriptorWithMapping:jsonRequestMapping
                           objectClass:[JsonRequest class]
                                method:RKRequestMethodPOST
                                  path:kGetErrorCode
                           rootKeyPath:nil];
    
    [self responseDescriptorWithMapping:troubleCodeMapping
                                 method:RKRequestMethodPOST
                                   path:kGetErrorCode
                            pathPattern:nil
                                keyPath:@"result"
                            statusCodes:statusCodes];
    
    /*
     {
     "result":{"create_time":"2015-05-01 13:20:13",//上次检测时间
     "id":"123"//检测报告ID
     },
     "status":{"errorCode": "0",
     "errorMessage":"成功"}
     }
     */
    [self responseDescriptorWithMapping:reportModelMapping
                                 method:RKRequestMethodGET
                                   path:KGetLastExamReport
                            pathPattern:nil
                                keyPath:@"result"
                            statusCodes:statusCodes];
    
    // 保存PID指令和故障码
    [self requestDescriptorWithMapping:jsonRequestMapping
                           objectClass:[JsonRequest class]
                                method:RKRequestMethodPOST
                                  path:kSavePidAndErrorcode
                           rootKeyPath:nil];
}
/**
 *  获取支持的PID列表
 *
 *  @param pidArray   要查询的PIDs
 *  @param completion 完成后回调
 */
- (void)getSupportPIDs:(JsonRequestForPID *)jsonRequest pidArray:(NSArray *)pidArray completion:(void (^)(NSArray *array, TorqueResult *result))completion {
    jsonRequest.jsonString = nil;
    TorqueResult *_result = [TorqueResult new];
    if (!pidArray || pidArray.count == 0) {
        _result.message = kMessage_pidNotNull;
        if (completion) {
            completion(nil, _result);
        }
        DDLogDebug(@"方法名:%s result:%ld message:%@", __FUNCTION__, _result.result, _result.message);
        return;
    }
    /*
     {
     "jsonStr":{"pids":[{"pid":"41 00 BF 9F B9 90"},//PID指令集合(必输项)
     {"pid":"41 20 FF 1F C1 FF"},//PID指令集合(必输项)
     {"pid":"41 40 FF 9F B9 90"}]//PID指令集合(必输项)
     },
     "userId":1,//用户ID(必输项)
     "deviceId":1,//设备ID(必输项)
     "carId":1//车辆ID(必输项)
     }
     */
    SBJson4Writer *jsonWriter = [[SBJson4Writer alloc] init];
    NSString *jsonStr = [jsonWriter stringWithObject:@{@"pids":pidArray}];
    jsonRequest.jsonString = jsonStr;
    
    [self postObject:jsonRequest
                path:kGetSupportPIDs
          parameters:nil
 needResponseMapping:YES
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 TorqueError *error = [[mappingResult dictionary] objectForKey:@"status"];
                 _result.message = error.errorMessage;
                 NSArray *info = nil;
                 if (error.errorCode == 0) {
                     info = [[mappingResult dictionary] objectForKey:@"result"];
                     if (info) {
                         _result.succeed = YES;
                         _result.result = 0;
                     } else {
                         _result.result = TorqueSDK_NerWorkOther;//-1;
                     }
                 }
                 if (completion) {
                     completion(info, _result);
                 }
                 DDLogDebug(@"方法名:%s result:%ld message:%@", __FUNCTION__, _result.result, _result.message);
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 _result.result = TorqueSDK_NetWorkFailed;//-1;
                 _result.message = error.localizedDescription;
                 _result.error = error;
                 if (completion) {
                     completion(nil, _result);
                 }
                 DDLogDebug(@"FAILED 方法名:%s result:%ld message:%@", __FUNCTION__, _result.result, _result.message);
             }];
}
/**
 *  提交数据流(获取PID指令的具体含义)
 *
 *  @param completion  完成后回调
 */
- (void)getDetailPID:(JsonRequestForPID *)jsonRequest pidArray:(NSArray *)pidArray completion:(void (^)(NSString *examID, TorqueResult *result))completion {
    jsonRequest.jsonString = nil;
    TorqueResult *_result = [TorqueResult new];
    if (!pidArray || pidArray.count == 0) {
        _result.message = kMessage_pidNotNull;
        if (completion) {
            completion(nil, _result);
        }
        DDLogDebug(@"方法名:%s result:%ld message:%@", __FUNCTION__, _result.result, _result.message);
        return;
    }
    /*
     {
     "jsonStr":{"pids":[{"pid":"41 01 81 07 65 04"},//pid指令(必输项)
     {"pid":"41 05 7B"},//pid指令(必输项)
     {"pid":"41 0C 1A F8"}]//pid指令(必输项)
     },
     "userId":1,//用户ID(必输项)
     "deviceId":1,//设备ID(必输项)
     "carId":1,//车辆ID(必输项)
     "examId":123//检测ID,可能分多次检测,需要知道是属于哪一次的检测,APP必须要确保唯一性(必输项)
     }
     */
    SBJson4Writer *jsonWriter = [[SBJson4Writer alloc] init];
    NSString *jsonStr = [jsonWriter stringWithObject:@{@"pids":pidArray}];
    jsonRequest.jsonString = jsonStr;
    
    [self postObject:jsonRequest
                path:kGetDetailPID
          parameters:nil
 needResponseMapping:YES
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 TorqueError *error = [[mappingResult dictionary] objectForKey:@"status"];
                 _result.message = error.errorMessage;
                 NSArray *info = nil;
                 if (error.errorCode == 0) {
                     info = [[mappingResult dictionary] objectForKey:@"result"];
                     if (info) {
                         _result.succeed = YES;
                         _result.result = 0;
                     } else {
                         _result.result = TorqueSDK_NerWorkOther;//-1;
                     }
                 }
                 if (completion) {
                     completion(jsonRequest.examId, _result);
                 }
                 DDLogDebug(@"方法名:%s result:%ld message:%@", __FUNCTION__, _result.result, _result.message);
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 _result.result = TorqueSDK_NetWorkFailed;//-1;
                 _result.message = error.localizedDescription;
                 _result.error = error;
                 if (completion) {
                     completion(nil, _result);
                 }
                 DDLogDebug(@"方法名:%s result:%ld message:%@", __FUNCTION__, _result.result, _result.message);
             }];
}
/**
 *  获取故障码
 *
 *  @param troubleCodeArray 要查询的故障码，多个故障码用'|'分隔
 *  @param completion       完成后回调
 */
- (NSArray *)getTroubleCode:(JsonRequestForPID *)jsonRequest troubleCodeArray:(NSArray *)troubleCodeArray {
    __block NSArray *troubleCodeResult = nil;
    jsonRequest.jsonString = nil;
    if (!troubleCodeArray || troubleCodeArray.count == 0) {
        return troubleCodeResult;
    }
    /*
     {
     "jsonStr":{"errorCodes":[{"errorCode":"P0104"},//故障码(必输项)
     {"errorCode":"P0085"},//故障码(必输项)
     {"errorCode":"P000C"}]//故障码(必输项)
     },
     "userId":1,//用户ID(必输项)
     "deviceId":1,//设备ID(必输项)
     "carId":1,//车辆ID(必输项)
     "examId":123//检测ID,可能分多次检测,需要知道是属于哪一次的检测,APP必须要确保唯一性(必输项)
     }
     */
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:troubleCodeArray.count];
    for (NSString *troubleCode in troubleCodeArray) {
        TroubleCode *code = [TroubleCode new];
        code.troubleCode = troubleCode;
        [array addObject:code];
    }
    SBJson4Writer *jsonWriter = [[SBJson4Writer alloc] init];
    NSString *jsonStr = [jsonWriter stringWithObject:@{@"errorCodes":array}];
    jsonRequest.jsonString = jsonStr;
    
    [self postObject:jsonRequest
                path:kGetErrorCode
          parameters:nil
 needResponseMapping:YES
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 TorqueError *error = [[mappingResult dictionary] objectForKey:@"status"];
                 NSArray *info = nil;
                 if (error.errorCode == 0) {
                     info = [[mappingResult dictionary] objectForKey:@"result"];
                     if (info) {
                         troubleCodeResult = [info copy];
                     }
                 }
                 dispatch_semaphore_signal(sema);
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 dispatch_semaphore_signal(sema);
             }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    return troubleCodeResult;
}

- (void)submitPIDAndTroubleCodeData:(JsonRequest *)jsonRequest  pidArray:(NSArray *)pidArray troubleCodeArray:(NSArray *)troubleCodeArray completion:(void(^)(TorqueResult *result))completion {
    jsonRequest.jsonString = nil;
    TorqueResult *_result = [TorqueResult new];
    [self validateNeededInfo:jsonRequest completion:^(TorqueResult *result) {
        if (!result.succeed) {
            _result.message = result.message;
            if (completion) {
                completion(_result);
            }
            return;
        }
        
        SBJson4Writer *jsonWriter = [[SBJson4Writer alloc] init];
        NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
        if (pidArray) {
            [jsonDict setValue:pidArray forKey:@"pids"];
        }
        if (troubleCodeArray) {
            [jsonDict setValue:troubleCodeArray forKey:@"errorCodes"];
        }
        jsonRequest.jsonString = (jsonDict.count > 0) ? [jsonWriter stringWithObject:jsonDict] : @"";
        
        [self postObject:jsonRequest
                    path:kSavePidAndErrorcode
              parameters:nil
                 success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                     TorqueError *error = [[mappingResult dictionary] objectForKey:@"status"];
                     _result.message = error.errorMessage;
                     if (error.errorCode == 0) {
                         _result.succeed = YES;
                     }
                     if (completion) {
                         completion(_result);
                     }
                 }
                 failure:^(RKObjectRequestOperation *operation, NSError *error) {
                     _result.result = TorqueSDK_NetWorkFailed;//-1;
                     _result.message = error.localizedDescription;
                     _result.error = error;
                     if (completion) {
                         completion(_result);
                     }
                 }];
    }];
}
/**
 *  必须信息是否验证通过
 *
 *  @param jsonRequest 请求对象
 */
- (void)validateNeededInfo:(JsonRequest *)jsonRequest completion:(void (^)(TorqueResult *result))completion{
    TorqueResult *_result = [TorqueResult new];
    _result.succeed = YES;
    if (!jsonRequest) {
        _result.succeed = NO;
        _result.message = kMessage_notFound;
    } else if (!jsonRequest.userId) {
        _result.succeed = NO;
        _result.message = kMessage_userIdNotNull;
    }
//     else if (!jsonRequest.deviceId) {
//        _result.succeed = NO;
//        _result.message = kMessage_deviceIdNotNull;
//    } else if (!jsonRequest.carId) {
//        _result.succeed = NO;
//        _result.message = kMessage_carIdNotNull;
//    }
    if (completion) {
        completion(_result);
    }
}

- (NSArray *)requestPID:(NSArray *)commandList percentageCompletion:(void(^)(CGFloat percentage, NSString *itemName))percentageCompletion {
    __block NSMutableArray *requestPidModeArray = [NSMutableArray new];

    if (!commandList ||
        commandList.count == 0) {
        return nil;
    }
    // 在此加入超时逻辑
    // CODE...
    //NSInteger timeout = 10;
    CGFloat per = (CGFloat)1 / commandList.count;
    for (PidCommand *command in commandList) {
        [[OBDDevice sharedInstance] queryPIDValue:command
                                    completion:^(PidModel *pidModelWithCommand, NSError *error) {
                                        if (!error && pidModelWithCommand) {
                                            DDLogDebug(@"PID:%@", pidModelWithCommand.pid);

                                            // 过滤重复项
                                            __block BOOL exist = NO;
                                            for (PidModel *pidMode in requestPidModeArray) {
                                                if ([pidMode.pid isEqualToString:pidModelWithCommand.pid]) {
                                                    exist = YES;
                                                    break;
                                                }
                                            }
                                            if (!exist) {
                                                [requestPidModeArray addObject:pidModelWithCommand];
                                            }
                                        }
                                    }];
        if (percentageCompletion) {
            percentageCompletion(per * 100, command.descriptionContent);
        }
    }
    
    return [requestPidModeArray copy];
}

#pragma mark - public Method

- (void)doDetection:(NSString *)userId deviceId:(NSString *)deviceId carId:(NSString *)carId percentageCompletion:(void(^)(CGFloat percentage ,NSString *itemName))percentageCompletion completion:(void (^)(NSInteger itemCount, NSInteger troubleCodeCount, NSString *examId, TorqueResult *result))completion {
    _completionBlock = completion;
    progress = 0;
    //TorqueResult *_result = [TorqueResult new];
    JsonRequestForPID *request = [[JsonRequestForPID alloc] init];
    request.userId = userId;
    request.deviceId = deviceId;
    request.carId = carId;
    
    __block TorqueResult *_result = [TorqueResult new];
    __block NSMutableArray *commandArray = nil;
    __block NSArray *troubleCodeExpline = nil;
    {
        __weak typeof(self) weakSelf = self;
        [self validateNeededInfo:request completion:^(TorqueResult *result) {
            if (!result.succeed) {
                _result.message = result.message;
                _result.error = result.error;
                if (_completionBlock) {
                    _completionBlock(0, 0, nil, _result);
                    _completionBlock = nil;
                }
                return;
            }
            commandArray = [[NSMutableArray alloc] initWithCapacity:120];
            __block NSString *itemName = @"";
            __block NSString *troubleCode = nil;
            __block NSInteger troubleCount = 0;
            __block NSInteger itemCount = 0;
#if KBaffleData
            return;
#else
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // 0、发送指令获取错误码
                troubleCode =  [[OBDDevice sharedInstance] getTroubleCodes];
                itemName = @"获取错误码中...";
                if (troubleCode) {
                    // 更新进度
                    if (percentageCompletion) {
                        percentageCompletion( progress += 5, itemName);
                    }
                    troubleCodeExpline = [weakSelf getTroubleCode:request troubleCodeArray:[troubleCode componentsSeparatedByString:@"|"]];
                    if (troubleCodeExpline && troubleCodeExpline.count > 0) {
                        troubleCount = troubleCodeExpline.count;
                    }
                    // 更新进度
                    if (percentageCompletion) {
                        percentageCompletion(progress += 5, itemName);
                    }
                } else {
                    // 更新进度
                    if (percentageCompletion) {
                        percentageCompletion(progress += 10, itemName);
                    }
                }
                
                // 1、进入PID模式，并发送指令获取PIDs
                [[OBDDevice sharedInstance] enterPIDMode:^(NSError *error) {
                    if (error) {
                        _result.error = error;
                        _result.message = @"进入PID模式失败";
                        if (_completionBlock) {
                            _completionBlock(itemCount, troubleCount, request.examId, _result);
                            [weakSelf exitDetection:nil];
                        }
                        return;
                    }
                    
                    itemName = @"进入PID模式成功...";
                    // 更新进度
                    if (percentageCompletion) {
                        percentageCompletion(progress += 5, itemName);
                    }
                    // 1.1 从本地数据库中读取支持的PID指令集，如果从未保存过，则从盒子中读取并请求服务器解析
                    //NSMutableArray *allPid = [NSMutableArray new];
                    // 2、通过PIDs获取支持的PID指令集
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        PidCommand *commond1 = [PidCommand new];
                        commond1.name = @"01 00";
                        PidCommand *commond2 = [PidCommand new];
                        commond2.name = @"01 20";
                        PidCommand *commond3 = [PidCommand new];
                        commond3.name = @"01 40";
                        /*
                         PidCommand *commond4 = [PidCommand new];
                         commond4.name = @"01 60";
                         PidCommand *commond5 = [PidCommand new];
                         commond5.name = @"01 80";
                         PidCommand *commond6 = [PidCommand new];
                         commond6.name = @"01 A0";
                         */
                        
                        NSArray *commandList = @[commond1, commond2, commond3/*, commond4, commond5, commond6*/];
                        NSArray *pidArray = [weakSelf requestPID:commandList percentageCompletion:nil];
                        if (!pidArray ||
                            pidArray.count == 0) {
                            _result.message = @"未读取到PID";
                            if (_completionBlock) {
                                _completionBlock(itemCount, troubleCount, request.examId, _result);
                                [weakSelf exitDetection:nil];
                            }
                            return;
                        }
                        // 更新进度
                        itemName = @"读取PID成功";
                        if (percentageCompletion) {
                            percentageCompletion(progress += 10, itemName);
                        }
                        
                        // 从服务器获取支持的PID指令
                        [weakSelf getSupportPIDs:request pidArray:pidArray
                                      completion:^(NSArray *array, TorqueResult *result) {
                                          if (!result.succeed ||
                                              !array ||
                                              array.count == 0) {
                                              _result.message = result.message;
                                              _result.error = result.error;
                                              if (_completionBlock) {
                                                  _completionBlock(itemCount, troubleCount, request.examId, _result);
                                                  [weakSelf exitDetection:nil];
                                              }
                                              return;
                                          }
                                          // 更新进度
                                          itemName = @"获取支持PID...";
                                          if (percentageCompletion) {
                                              percentageCompletion(progress += 10, itemName);
                                          }
                                          dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                              commandArray = [NSMutableArray new];
                                              for (PidModel *model in array) {
                                                  for (PidCommand *command in model.commands) {
                                                      PidCommand *_command = [PidCommand new];
                                                      _command.name = command.name;
                                                      _command.pid = model.pid;
                                                      _command.descriptionContent = command.descriptionContent;
                                                      [commandArray addObject:_command];
                                                  }
                                              }
                                              // 保存支持PID到本地
                                              // CODE..
                                              // 3、发送指令集获取数据流
                                              NSArray *dataFlow = [weakSelf requestPID:commandArray percentageCompletion:^(CGFloat percentage, NSString *itemName) {
                                                  progress += ((percentage / 50.0) * 10);
                                                  if (percentageCompletion) {
                                                      percentageCompletion(progress, itemName);
                                                  }
                                              }];
                                              if (!dataFlow ||
                                                  dataFlow.count == 0) {
                                                  _result.message = @"读取数据流失败";
                                                  _result.error = result.error;
                                                  if (_completionBlock) {
                                                      _completionBlock(itemCount, troubleCount, request.examId, _result);
                                                      [weakSelf exitDetection:nil];
                                                  }
                                                  return;
                                              }
                                              
                                              commandArray = [NSMutableArray arrayWithArray:dataFlow];
                                              itemCount = commandArray.count;
                                              // 发送到服务器
                                              [weakSelf submitPIDAndTroubleCodeData:request
                                                                           pidArray:commandArray
                                                                   troubleCodeArray:troubleCodeExpline
                                                                         completion:^(TorqueResult *result) {
                                                                             if (!result.succeed) {
                                                                                 _result.message = result.message;
                                                                                 _result.error = result.error;
                                                                                 if (_completionBlock) {
                                                                                     _completionBlock(itemCount, troubleCount, request.examId, _result);
                                                                                     [weakSelf exitDetection:nil];
                                                                                 }
                                                                                 return;
                                                                             }
                                                                             itemName = @"正在处理...";
                                                                             if (percentageCompletion) {
                                                                                 percentageCompletion(progress += 30, itemName);
                                                                             }
                                                                             // 退出PID模式
                                                                             [[OBDDevice sharedInstance] exitPIDMode:^(NSError *error) {
                                                                                 _result.succeed = !error;
                                                                                 itemName = @"退出PID模式";
                                                                                 if (percentageCompletion) {
                                                                                     percentageCompletion(progress += 15, itemName);
                                                                                 }
                                                                                 if (!error) {
                                                                                     result.succeed = YES;
                                                                                 }
                                                                                 if (_completionBlock) {
                                                                                     _completionBlock(itemCount, troubleCount, request.examId, result);
                                                                                 }
                                                                                 _completionBlock = nil;
                                                                             }];
                                                                         }];
                                          });
                                      }];
                    });
                }];
            });            
#endif

        }];
    }
}

- (void)exitDetection:(void (^)(TorqueResult *result))completion {
    TorqueResult *_result = [TorqueResult new];
    _completionBlock = nil;
    
#if KBaffleData
    _result.succeed = YES;
    if (completion) {
        completion(_result);
    }
    return;
#else
    [[OBDDevice sharedInstance] exitPIDMode:^(NSError *error) {
        _result.succeed = !error;
        if (completion) {
            completion(_result);
        }
    }];
#endif
}

- (void)getDetectionReports:(NSString *)userId
                   deviceId:(NSString *)deviceId
                      carId:(NSString *)carId
                  pageIndex:(NSInteger)pageIndex
                      count:(NSInteger)count
                 completion:(void (^)(DetectReportPage *page, TorqueResult *result))completion {
    TorqueResult *_result = [TorqueResult new];
    JsonRequest *request = [JsonRequest new];
    request.userId = userId;
    if(!deviceId)
    {
        deviceId = @"";
    }
    request.deviceId = deviceId;
    if(!carId)
    {
        carId = @"";
    }
    request.carId = carId;
    request.pageIndex = pageIndex;
    [self validateNeededInfo:request completion:^(TorqueResult *result) {
        if (result.succeed) {
#if KBaffleData
            {
                NSMutableArray *reports = [[NSMutableArray alloc] initWithCapacity:count];
                for (int i = 0; i < count; i++) {
                    DetectionReport *report = [DetectionReport new];
                    report.detectionId = 123;
                    report.createTime = [NSString dateFromString:@"2015-2-22 22:22:22" ForDateFormatter:kDateFormat];
                    report.errorCodeNumber = 3;
                    report.score = 84;
                    report.result = @"总体结论";
                    report.detail = @"https://box.dds.com/pid/getExamReportDetail?examId=123";
                    
                    [reports addObject:report];
                }
                _result.succeed = (reports && reports.count > 0);
                if (completion) {
                    completion(reports, _result);
                }
                return;
            }
#endif
            
            [self getObjectsAtPath:kGetExamReports
                        parameters:kGetExamReportsParams(request.userId,
                                                         //request.deviceId,
                                                         request.carId,
                                                         [NSNumber numberWithInteger:request.pageIndex],
                                                         [NSNumber numberWithInteger:count])
                           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                               TorqueError *error = [[mappingResult dictionary] objectForKey:@"status"];
                               _result.message = error.errorMessage;
                               DetectReportPage *info = nil;
                               if (error.errorCode == 0) {
                                   if (completion) {
                                       info = [[mappingResult dictionary] objectForKey:@"result"];
                                       _result.succeed = YES;
                                   }
                               }  else if (error.errorCode == 400) {
                                   _result.result = 1;
                               }
                               
                               if (completion) {
                                   completion(info, _result);
                               }
                           } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                               _result.message = error.localizedDescription;
                               _result.error = error;
                               _result.result = TorqueSDK_NetWorkFailed;
                               if (completion) {
                                   completion(nil, _result);
                               }
                           }];
        } else {
            if (completion) {
                completion(nil, result);
            }
        }
    }];
}

- (void)requestLastDetectTime:(NSString *)carId withUserId:(NSNumber *)userid completion:(void(^)(DetectionReport *report, TorqueResult *result))completion {
    TorqueResult *_result = [TorqueResult new];
    if (!carId || [carId isEqualToString:@""]) {
        _result.message = kMessage_vinCodeNotNull;
        if (completion) {
            completion(nil, _result);
        }
        return;
    }
    [self getObjectsAtPath:KGetLastExamReport
                parameters:KGetLastExamReportParams(carId,userid)
                   success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                       TorqueError *error = [[mappingResult dictionary] objectForKey:@"status"];
                       DetectionReport *info = nil;
                       if (error.errorCode == 0) {
                           info = [[mappingResult dictionary] objectForKey:@"result"];
                           _result.succeed = (info != nil);
                       }
                       if (completion) {
                           completion(info, _result);
                       }
                   } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                       _result.message = error.localizedDescription;
                       _result.error = error;
                       _result.result = TorqueSDK_NetWorkFailed;
                       if (completion) {
                           completion(nil, _result);
                       }
                   }];
}
@end
