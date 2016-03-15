//
//  TFVenusHTTPManager.m
//  TFCoreLib
//
//  Created by xiayiyong on 15/9/23.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFVenusHTTPRequestManager.h"
#import "TFBaseResponse.h"
#import "TFURLManager.h"
#import "TFCoreUtil.h"

#define NET_ERROR  @"网络不给力啊~"

@implementation TFVenusHTTPRequestManager

+ (NSURLSessionDataTask *)doTaskWithURL:(NSString*)url
                               parameters:(NSDictionary*)parameters
                                  success:(void (^)(id data))successBlock
                                  failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock
                                    error:(void (^)(NSError *error))errorBlock
{
    if (!kTFNetworkManager.reachable)
    {
        if (failureBlock)
        {
            failureBlock(-1,NET_ERROR);
            return nil;
        }
    }
    
    NSDictionary *reqData=@{
                            @"deviceId" : tf_getDeviceId(),
                            @"appVersion" : tf_getAPPVersion(),
                            @"plateformType" : tf_getPlateformType(),
                            @"clientId" : tf_getClientId(),
                            @"sourceCode" : tf_getSourceCode(),
                            @"appCode" : tf_getAppCode(),
                            @"deviceManufacturer" : tf_getDeviceManufacturer(),
                            @"userAccount" : tf_getUserAccount(),
                            @"userToken" : tf_getUserToken()
                            };
    NSData* jsonRequestData = [NSJSONSerialization dataWithJSONObject:reqData options:kNilOptions error:nil];
    
    NSString* saikemobilehead = [[NSString alloc] initWithData:jsonRequestData encoding: NSUTF8StringEncoding];
    NSString *timestamp=[self _stringFromTime:[NSDate date] format:@"yyyyMMddHHmmss"];
    
    NSDictionary *httpHeader=@{
                               @"saikemobilehead":saikemobilehead,
                               @"timestamp":timestamp,
                               @"signatureMethod":@"md5",
                               @"appKey":@"app_rigida_open_api",
                               @"format":@"json",
                               @"version":@"1",
                               };
    
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
        url=[NSString stringWithFormat:@"%@%@",kTFURLManager.venusUrl,url];
    }

    return [[self class]doTaskWithURL:url
                           httpHeader:httpHeader
                           parameters:parameters
                               before:nil
                              success:^(id responseObject) {
                                  TFBaseResponse *rsp= [TFBaseResponse mj_objectWithKeyValues:responseObject];;
                                  if (rsp.errorCode==0)
                                  {
                                      if (successBlock)
                                      {
                                          successBlock(rsp.result);
                                      }
                                  }
                                  else
                                  {
                                      NSLog(@"JSON: %@", rsp.errorMessage);
                                      
                                      if (failureBlock)
                                      {
                                          failureBlock(rsp.errorCode,rsp.errorMessage);
                                      }
                                  }
                              }
                              failure:^(int errorCode, NSString *errorMessage){
                                  if (failureBlock)
                                  {
                                      failureBlock(errorCode, errorMessage);
                                  }
                              }
                            error:^(NSError *error){
                                    switch (error.code)
                                    {
                                        case NSURLErrorBadURL:
                                        case NSURLErrorTimedOut:
                                        case NSURLErrorUnsupportedURL:
                                        case NSURLErrorCannotFindHost:
                                        case NSURLErrorCannotConnectToHost:
                                        case NSURLErrorNetworkConnectionLost:
                                        case NSURLErrorNotConnectedToInternet:
                                        {
                                            if (failureBlock)
                                            {
                                                failureBlock(-1,NET_ERROR);
                                            }
                                        }
                                            break;
                                        default:
                                        {
                                            if (errorBlock)
                                            {
                                                errorBlock(error);
                                            }
                                        }
                                            break;
                                    }

                                }];
}

+ (NSString *)_stringFromTime:(NSDate *)time format:(NSString*)format
{
    NSDateFormatter *dateFromatter=[[NSDateFormatter alloc] init];
    [dateFromatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFromatter setDateFormat:format];
    NSString *strTime = [dateFromatter stringFromDate:time];
    return strTime;
}

@end
