
//
//  TFHTTPManager.m
// Treasure
//
//  Created by xiayiyong on 15/7/1.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFHTTPRequestManager.h"
#import "AFHTTPSessionManager+AutoRetry.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>

#define AFNETWORKING_ALLOW_INVALID_SSL_CERTIFICATES

#define  HTTP_DEFAULT_URL @""

#define DEFAULT_RETRY_NUM  1  //重连次数

#define DEFAULT_TIMEOUT_INTERVAL  20   //超时时间

@interface TFHTTPRequestManager ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;

@end

@implementation TFHTTPRequestManager

+ (instancetype)sharedManager
{
    static TFHTTPRequestManager *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TFHTTPRequestManager alloc] initTaskPool];
    });
    
    return instance;
}

#pragma mark -
#pragma mark Init Methods

- (instancetype)initTaskPool
{
    self = [super init];
    if (self)
    {
        _baseUrl = @"";
        _requestMethod = HttpRequestMethod_POST;
        
        _sessionManager = [AFHTTPSessionManager manager];
        
        _sessionManager.operationQueue.maxConcurrentOperationCount=10;
        
        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        [_sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        _sessionManager.requestSerializer.timeoutInterval = DEFAULT_TIMEOUT_INTERVAL;
        
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",@"text/plain",@"application/json",@"charset=utf-8",nil];
        
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        
        //allowInvalidCertificates 是否允许无效证书（也就是自建的证书）,默认为NO,如果是需要验证自建证书，需要设置为YES
        securityPolicy.allowInvalidCertificates = YES;
        
        //validatesDomainName 是否需要验证域名，默认为YES；
        //假如证书的域名与你请求的域名不一致，需把该项设置为NO
        //主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。
        //因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
        securityPolicy.validatesDomainName = NO;
        
        _sessionManager.securityPolicy = securityPolicy;
    }
    return self;
}

/**
 *  设置http头
 */
+ (void)addHttpHead:(NSDictionary*)httpHeader
{
    if (httpHeader==nil)
    {
        return;
    }
    
    AFHTTPSessionManager *manager = [[TFHTTPRequestManager sharedManager]sessionManager];
    
    NSArray *keys=[httpHeader allKeys];;
    NSUInteger count=[keys count];
    
    for (int i = 0; i < count; i++)
    {
        id key = [keys objectAtIndex: i];
        id value = [httpHeader objectForKey: key];
        if (key!=nil && value!=nil)
        {
            [manager.requestSerializer setValue:value forHTTPHeaderField:key];
        }
    }
}

/**
 *  设置
 *
 *  @param serializerType RequestSerializerTypeJSON和RequestSerializerTypeHTTP
 */
+ (void)initRequestSerializerType:(RequestSerializerType)serializerType
{
    AFHTTPSessionManager *manager = [[TFHTTPRequestManager sharedManager]sessionManager];
    if (serializerType == RequestSerializerTypeHTTP)
    {
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    else if (serializerType == RequestSerializerTypeJSON)
    {
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    
    manager.requestSerializer.timeoutInterval = DEFAULT_TIMEOUT_INTERVAL;
}

/**
 *  设置
 *
 *  @param serializerType RequestSerializerTypeJSON和RequestSerializerTypeHTTP
 */
+ (void)initResponseSerializerType:(ResponseSerializerType)serializerType
{
    AFHTTPSessionManager *manager = [[TFHTTPRequestManager sharedManager]sessionManager];
    if (serializerType == ResponseSerializerTypeHTTP)
    {
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    else if (serializerType == ResponseSerializerTypeJSON)
    {
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",@"text/plain",@"application/json",@"charset=utf-8",nil];
    }
}

#pragma mark -
#pragma mark 1

+ (NSURLSessionDataTask *)doTaskWithURL:(NSString*)url
                             httpHeader:(NSDictionary *)httpHeader
                             parameters:(NSDictionary*)parameters
                                success:(void (^)(id data))successBlock
                                failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock
                                  error:(void (^)(NSError *error))errorBlock
{
    return [[self class]doTaskWithURL:url
                           httpHeader:httpHeader
                           parameters:parameters
                               before:nil
                              success:successBlock
                              failure:failureBlock
                                error:errorBlock];
}

+ (NSURLSessionDataTask *)doTaskWithURL:(NSString*)url
                             httpHeader:(NSDictionary *)httpHeader
                             parameters:(NSDictionary*)parameters
                                success:(void (^)(id data))successBlock
                                failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock
                                  error:(void (^)(NSError *error))errorBlock
                                timeOut:(int)timeOut
{
    return [[self class]doTaskWithURL:url
                           httpHeader:httpHeader
                           parameters:parameters
                        requestMethod:HttpRequestMethod_POST
                requestSerializerType:RequestSerializerTypeJSON
               responseSerializerType:ResponseSerializerTypeJSON
                               before:nil
                              success:successBlock
                              failure:failureBlock
                                error:errorBlock
                              timeOut:timeOut
                            autoRetry:DEFAULT_RETRY_NUM];
}

+ (NSURLSessionDataTask *)doTaskWithURL:(NSString*)url
                             httpHeader:(NSDictionary *)httpHeader
                             parameters:(NSDictionary*)parameters
                                success:(void (^)(id data))successBlock
                                failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock
                                  error:(void (^)(NSError *error))errorBlock
                              autoRetry:(int)timesToRetry

{
    return [[self class]doTaskWithURL:url
                           httpHeader:httpHeader
                           parameters:parameters
                        requestMethod:HttpRequestMethod_POST
                requestSerializerType:RequestSerializerTypeJSON
               responseSerializerType:ResponseSerializerTypeJSON
                               before:nil
                              success:successBlock
                              failure:failureBlock
                                error:errorBlock
                              timeOut:DEFAULT_TIMEOUT_INTERVAL
                            autoRetry:timesToRetry];
}

+ (NSURLSessionDataTask *)doTaskWithURL:(NSString*)url
                             httpHeader:(NSDictionary *)httpHeader
                             parameters:(NSDictionary*)parameters
                                success:(void (^)(id data))successBlock
                                failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock
                                  error:(void (^)(NSError *error))errorBlock
                                timeOut:(int)timeOut
                              autoRetry:(int)timesToRetry
{
    return [[self class]doTaskWithURL:url
                           httpHeader:httpHeader
                           parameters:parameters
                        requestMethod:HttpRequestMethod_POST
                requestSerializerType:RequestSerializerTypeJSON
               responseSerializerType:ResponseSerializerTypeJSON
                               before:nil
                              success:successBlock
                              failure:failureBlock
                                error:errorBlock
                              timeOut:timeOut
                            autoRetry:timesToRetry];
}

#pragma mark -
#pragma mark 2
+ (NSURLSessionDataTask *)doTaskWithURL:(NSString*)url
                             httpHeader:(NSDictionary *)httpHeader
                             parameters:(NSDictionary*)parameters
                                 before:(void (^)(void))beforeBlock
                                success:(void (^)(id data))successBlock
                                failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock
                                  error:(void (^)(NSError *error))errorBlock
{
    return [[self class]doTaskWithURL:url
                           httpHeader:httpHeader
                           parameters:parameters
                        requestMethod:HttpRequestMethod_POST
                requestSerializerType:RequestSerializerTypeJSON
               responseSerializerType:ResponseSerializerTypeJSON
                               before:beforeBlock
                              success:successBlock
                              failure:failureBlock
                                error:errorBlock];
}

#pragma mark -
#pragma mark 3
+ (NSURLSessionDataTask *)doTaskWithURL:(NSString*)url
                             httpHeader:(NSDictionary *)httpHeader
                             parameters:(NSDictionary*)parameters
                          requestMethod:(HttpRequestMethod)requestMethod
                  requestSerializerType:(RequestSerializerType)requestSerializerType
                 responseSerializerType:(ResponseSerializerType)responseSerializerType
                                 before:(void (^)(void))beforeBlock
                                success:(void (^)(id data))successBlock
                                failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock
                                  error:(void (^)(NSError *error))errorBlock
{
    return [[self class]doTaskWithURL:url
                           httpHeader:httpHeader
                           parameters:parameters
                        requestMethod:HttpRequestMethod_POST
                requestSerializerType:RequestSerializerTypeJSON
               responseSerializerType:ResponseSerializerTypeJSON
                               before:beforeBlock
                              success:successBlock
                              failure:failureBlock
                                error:errorBlock
                              timeOut:DEFAULT_TIMEOUT_INTERVAL
                            autoRetry:DEFAULT_RETRY_NUM];
}

+ (NSURLSessionDataTask *)doTaskWithURL:(NSString*)url
                             httpHeader:(NSDictionary *)httpHeader
                             parameters:(NSDictionary*)parameters
                          requestMethod:(HttpRequestMethod)requestMethod
                  requestSerializerType:(RequestSerializerType)requestSerializerType
                 responseSerializerType:(ResponseSerializerType)responseSerializerType
                                 before:(void (^)(void))beforeBlock
                                success:(void (^)(id data))successBlock
                                failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock
                                  error:(void (^)(NSError *error))errorBlock
                                timeOut:(int)timeOut
{
    return [[self class]doTaskWithURL:url
                           httpHeader:httpHeader
                           parameters:parameters
                        requestMethod:HttpRequestMethod_POST
                requestSerializerType:RequestSerializerTypeJSON
               responseSerializerType:ResponseSerializerTypeJSON
                               before:beforeBlock
                              success:successBlock
                              failure:failureBlock
                                error:errorBlock
                              timeOut:timeOut
                            autoRetry:DEFAULT_RETRY_NUM];
}

+ (NSURLSessionDataTask *)doTaskWithURL:(NSString*)url
                             httpHeader:(NSDictionary *)httpHeader
                             parameters:(NSDictionary*)parameters
                          requestMethod:(HttpRequestMethod)requestMethod
                  requestSerializerType:(RequestSerializerType)requestSerializerType
                 responseSerializerType:(ResponseSerializerType)responseSerializerType
                                 before:(void (^)(void))beforeBlock
                                success:(void (^)(id data))successBlock
                                failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock
                                  error:(void (^)(NSError *error))errorBlock
                              autoRetry:(int)timesToRetry
{
    return [[self class]doTaskWithURL:url
                           httpHeader:httpHeader
                           parameters:parameters
                        requestMethod:HttpRequestMethod_POST
                requestSerializerType:RequestSerializerTypeJSON
               responseSerializerType:ResponseSerializerTypeJSON
                               before:beforeBlock
                              success:successBlock
                              failure:failureBlock
                                error:errorBlock
                              timeOut:DEFAULT_TIMEOUT_INTERVAL
                            autoRetry:timesToRetry];
}

+ (NSURLSessionDataTask *)doTaskWithURL:(NSString*)url
                             httpHeader:(NSDictionary *)httpHeader
                             parameters:(NSDictionary*)parameters
                          requestMethod:(HttpRequestMethod)requestMethod
                  requestSerializerType:(RequestSerializerType)requestSerializerType
                 responseSerializerType:(ResponseSerializerType)responseSerializerType
                                 before:(void (^)(void))beforeBlock
                                success:(void (^)(id data))successBlock
                                failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock
                                  error:(void (^)(NSError *error))errorBlock
                                timeOut:(int)timeOut
                                  autoRetry:(int)timesToRetry
{
    if (url==nil||[url length]==0)
    {
        if (failureBlock)
        {
            failureBlock(-1,@"url为空");
        }
        
        return nil;
    }
    
    if (![url hasPrefix:@"http"] && ![url hasPrefix:@"https"])
    {
        
        NSString *baseUrl=[[[self class]sharedManager]baseUrl];
        if (baseUrl==nil||[baseUrl length]==0)
        {
            if (failureBlock)
            {
                failureBlock(-1,@"url为错误");
            }
            
            return nil;
        }
        else
        {
            url=[NSString stringWithFormat:@"%@%@",baseUrl,url];
        }
    }
    
    NSMutableDictionary *reqData=[[NSMutableDictionary alloc]initWithDictionary:parameters];
    
    NSData* jsonRequestData = [NSJSONSerialization dataWithJSONObject:reqData options:kNilOptions error:nil];
    NSString* jsonRequestString = [[NSString alloc] initWithData:jsonRequestData encoding: NSUTF8StringEncoding];
    NSLog(@"requesturl=%@?%@",url,jsonRequestString);
    
    [[self class] initRequestSerializerType:requestSerializerType];
    [[self class] initResponseSerializerType:responseSerializerType];
    [[self class] addHttpHead:httpHeader];
    
    AFHTTPSessionManager *manager = [[TFHTTPRequestManager sharedManager]sessionManager];
    manager.requestSerializer.timeoutInterval = timeOut;
    
    NSURLSessionDataTask *task=nil;
    
    if (beforeBlock)
    {
        beforeBlock();
    }
    
    switch (requestMethod)
    {
        case HttpRequestMethod_POST:
        {
            task=[manager POST:url
                    parameters:reqData
                       success:^(NSURLSessionDataTask *task, id responseObject)
                  {
                      [self dosuccess:responseObject success:successBlock failure:failureBlock error:errorBlock];
                  }
                       failure:^(NSURLSessionDataTask *task, NSError *error)
                  {
                      [self dofailure:error success:successBlock failure:failureBlock error:errorBlock];
                  }autoRetry:timesToRetry];
        }
            break;
        case HttpRequestMethod_GET:
        {
            task=[manager GET:url
                   parameters:reqData
                      success:^(NSURLSessionDataTask *task, id responseObject)
                  {
                      [self dosuccess:responseObject success:successBlock failure:failureBlock error:errorBlock];
                  }
                      failure:^(NSURLSessionDataTask *task, NSError *error)
                  {
                      [self dofailure:error success:successBlock failure:failureBlock error:errorBlock];
                  }autoRetry:timesToRetry];
        }
            break;
        case HttpRequestMethod_DELETE:
        {
            task=[manager DELETE:url
                      parameters:reqData
                         success:^(NSURLSessionDataTask *task, id responseObject)
                  {
                      [self dosuccess:responseObject success:successBlock failure:failureBlock error:errorBlock];
                  }
                         failure:^(NSURLSessionDataTask *task, NSError *error)
                  {
                      [self dofailure:error success:successBlock failure:failureBlock error:errorBlock];
                  }autoRetry:timesToRetry];
        }
            break;
        case HttpRequestMethod_PUT:
        {
            task=[manager PUT:url
                   parameters:reqData
                      success:^(NSURLSessionDataTask *task, id responseObject)
                  {
                      [self dosuccess:responseObject success:successBlock failure:failureBlock error:errorBlock];
                  }
                      failure:^(NSURLSessionDataTask *task, NSError *error)
                  {
                      [self dofailure:error success:successBlock failure:failureBlock error:errorBlock];
                  }autoRetry:timesToRetry];
        }
            break;
        case HttpRequestMethod_IMAGE:
            break;
        default:
            break;
    }
    
    return task;
    
}

#pragma mark- upload

+ (NSURLSessionDataTask *)doTaskWithURL:(NSString *)url
                             parameters:(NSDictionary *)parameters
              constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block
                                success:(void (^)(id data))successBlock
                                failure:(void (^)(int errorCode, NSString *errorMessage))failureBlock
                                  error:(void (^)(NSError *error))errorBlock
{
    if (url==nil||[url length]==0)
    {
        if (failureBlock)
        {
            failureBlock(-1,@"url为空");
        }
        
        return nil;
    }
    
    if (![url hasPrefix:@"http"] && ![url hasPrefix:@"https"])
    {
        
        NSString *baseUrl=[[[self class]sharedManager]baseUrl];
        if (baseUrl==nil||[baseUrl length]==0)
        {
            if (failureBlock)
            {
                failureBlock(-1,@"url为错误");
            }
            
            return nil;
        }
        else
        {
            url=[NSString stringWithFormat:@"%@%@",baseUrl,url];
        }
    }
    
    NSMutableDictionary *reqData=[[NSMutableDictionary alloc]initWithDictionary:parameters];
    
    NSData* jsonRequestData = [NSJSONSerialization dataWithJSONObject:reqData options:kNilOptions error:nil];
    NSString* jsonRequestString = [[NSString alloc] initWithData:jsonRequestData encoding: NSUTF8StringEncoding];
    NSLog(@"requesturl=%@?%@",url,jsonRequestString);
    
    NSURLSessionDataTask *task=nil;
    AFHTTPSessionManager *manager = [[TFHTTPRequestManager sharedManager]sessionManager];
    
    manager.requestSerializer.timeoutInterval = 10;
    
    task = [manager POST:url
              parameters:reqData
constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
            {
                if (block)
                {
                    block(formData);
                }
            }
                 success:^(NSURLSessionDataTask *task, id responseObject)
            {
                [self dosuccess:responseObject success:successBlock failure:failureBlock error:errorBlock];
            }
                 failure:^(NSURLSessionDataTask *task, NSError *error)
            {
                [self dofailure:error success:successBlock failure:failureBlock error:errorBlock];
            }];
    
    return task;
}

#pragma mark- 打印url 和 json数据 httpHeader用于调试

+(void)dosuccess:(id)responseObject
         success:(void (^)(id data))successBlock
         failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock
           error:(void (^)(NSError *error))errorBlock
{
    NSLog(@"JSON: %@", responseObject);
    
    if (successBlock)
    {
        successBlock(responseObject);
    }
}

+(void)dofailure:(NSError *)error
         success:(void (^)(id data))successBlock
         failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock
           error:(void (^)(NSError *error))errorBlock
{
    NSLog(@"ERROR: %@", error);
    
    if (errorBlock)
    {
        errorBlock(error);
    }
}
@end
