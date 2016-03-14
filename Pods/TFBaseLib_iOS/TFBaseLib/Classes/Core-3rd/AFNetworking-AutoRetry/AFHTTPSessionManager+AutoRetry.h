//
// Created by Shai Ohev Zion on 1/23/14.
// Copyright (c) 2014 shaioz. All rights reserved.

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"

typedef int (^RetryDelayCalcBlock)(int, int, int); // int totalRetriesAllowed, int retriesRemaining, int delayBetweenIntervalsModifier

@interface AFHTTPSessionManager (AutoRetry)

/**
 *  带自动重连的request
 *
 *  @param retriesRemaining  重连次数
 *  @param intervalInSeconds 重连的间隔
 *  @param taskCreator       taskCreator description
 *  @param failure           失败的回调
 *
 *  @return NSURLSessionDataTask
 */
- (NSURLSessionDataTask *)requestUrlWithAutoRetry:(int)retriesRemaining
                                    retryInterval:(int)intervalInSeconds
                           originalRequestCreator:(NSURLSessionDataTask *(^)(void (^)(NSURLSessionDataTask *, NSError *)))taskCreator
                                  originalFailure:(void (^)(NSURLSessionDataTask *, NSError *))failure;

/**
 *  GET方式请求
 *
 *  @param URLString         URL地址
 *  @param parameters        parameters数据
 *  @param success           成功
 *  @param failure           失败
 *  @param timesToRetry      重连次数
 *  @param intervalInSeconds 重连间隔
 *
 *  @return NSURLSessionDataTask
 */
- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id respo))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                    autoRetry:(int)timesToRetry
                retryInterval:(int)intervalInSeconds;

/**
 *  HEAD方式请求
 *
 *  @param URLString         URL地址
 *  @param parameters        parameters数据
 *  @param success           成功
 *  @param failure           失败
 *  @param timesToRetry      重连次数
 *  @param intervalInSeconds 重连间隔
 *
 *  @return NSURLSessionDataTask
 */
- (NSURLSessionDataTask *)HEAD:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                       success:(void (^)(NSURLSessionDataTask *task))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                     autoRetry:(int)timesToRetry
                 retryInterval:(int)intervalInSeconds;

/**
 *  POST方式请求
 *
 *  @param URLString         URL地址
 *  @param parameters        parameters数据
 *  @param success           成功
 *  @param failure           失败
 *  @param timesToRetry      重连次数
 *  @param intervalInSeconds 重连间隔
 *
 *  @return NSURLSessionDataTask
 */
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                     autoRetry:(int)timesToRetry
                 retryInterval:(int)intervalInSeconds;

/**
 *  POST方式表单请求
 *
 *  @param URLString         URL地址
 *  @param parameters        parameters数据
 *  @param block             表数据
 *  @param success           成功
 *  @param failure           失败
 *  @param timesToRetry      重连次数
 *  @param intervalInSeconds 重连间隔
 *
 *  @return NSURLSessionDataTask
 */
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                     autoRetry:(int)timesToRetry
                 retryInterval:(int)intervalInSeconds;

/**
 *  PUT方式的请求
 *
 *  @param URLString         URL地址
 *  @param parameters        parameters数据
 *  @param success           成功
 *  @param failure           失败
 *  @param timesToRetry      重连次数
 *  @param intervalInSeconds 重连间隔
 *
 *  @return NSURLSessionDataTask
 */
- (NSURLSessionDataTask *)PUT:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                    autoRetry:(int)timesToRetry
                retryInterval:(int)intervalInSeconds;

/**
 *  PATCH方式的请求
 *
 *  @param URLString         URL地址
 *  @param parameters        parameters数据
 *  @param success           成功
 *  @param failure           失败
 *  @param timesToRetry      重连次数
 *  @param intervalInSeconds 重连间隔
 *
 *  @return NSURLSessionDataTask
 */
- (NSURLSessionDataTask *)PATCH:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
                        success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                        failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                      autoRetry:(int)timesToRetry
                  retryInterval:(int)intervalInSeconds;

/**
 *  DELRTE方式的请求
 *
 *  @param URLString         URL地址
 *  @param parameters        parameters数据
 *  @param success           成功
 *  @param failure           失败
 *  @param timesToRetry      重连次数
 *  @param intervalInSeconds 重连间隔
 *
 *  @return NSURLSessionDataTask
 */
- (NSURLSessionDataTask *)DELETE:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                       autoRetry:(int)timesToRetry
                   retryInterval:(int)intervalInSeconds;

/**
 *  GET方式请求只能设置重连次数
 *
 *  @param URLString    URL地址
 *  @param parameters   parameters数据
 *  @param success      成功
 *  @param failure      失败
 *  @param timesToRetry 重连次数
 *
 *  @return NSURLSessionDataTask
 */
- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id respo))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                    autoRetry:(int)timesToRetry;

/**
 *  HEAD方式请求只能设置重连次数
 *
 *  @param URLString    URL地址
 *  @param parameters   parameters数据
 *  @param success      成功
 *  @param failure      失败
 *  @param timesToRetry 重连次数
 *
 *  @return NSURLSessionDataTask
 */
- (NSURLSessionDataTask *)HEAD:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                       success:(void (^)(NSURLSessionDataTask *task))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                     autoRetry:(int)timesToRetry;

/**
 *  POST方式请求只能设置重连次数
 *
 *  @param URLString    URL地址
 *  @param parameters   parameters数据
 *  @param success      成功
 *  @param failure      失败
 *  @param timesToRetry 重连次数
 *
 *  @return NSURLSessionDataTask
 */

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                     autoRetry:(int)timesToRetry;

/**
 *  POST方式表单请求只能设置重连次数
 *
 *  @param URLString         URL地址
 *  @param parameters        parameters数据
 *  @param block             表数据
 *  @param success           成功
 *  @param failure           失败
 *  @param timesToRetry      重连次数
 *
 *  @return NSURLSessionDataTask
 */
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                     autoRetry:(int)timesToRetry;

/**
 *  PUT方式请求只能设置重连次数
 *
 *  @param URLString    URL地址
 *  @param parameters   parameters数据
 *  @param success      成功
 *  @param failure      失败
 *  @param timesToRetry 重连次数
 *
 *  @return NSURLSessionDataTask
 */
- (NSURLSessionDataTask *)PUT:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                    autoRetry:(int)timesToRetry;

/**
 *  DELETE方式请求只能设置重连次数
 *
 *  @param URLString    URL地址
 *  @param parameters   parameters数据
 *  @param success      成功
 *  @param failure      失败
 *  @param timesToRetry 重连次数
 *
 *  @return NSURLSessionDataTask
 */
- (NSURLSessionDataTask *)DELETE:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                       autoRetry:(int)timesToRetry;

@property (strong) id tasksDict;
@property (copy) id retryDelayCalcBlock;

@end

#pragma clang diagnostic pop