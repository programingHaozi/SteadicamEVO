//
//  TFVenusHTTPManager.h
//  TFCoreLib
//
//  Created by xiayiyong on 15/9/23.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFHTTPRequestManager.h"
#import "TFBaseLib.h"

@interface TFVenusHTTPRequestManager : TFHTTPRequestManager

/**
 *  封装的网络请求，统一添加http head和错误处理等
 *
 *  @param url          请求URL
 *  @param parameters   请求参数
 *  @param successBlock 成功block
 *  @param failureBlock 失败block
 *  @param errorBlock   错误block
 *
 *  @return
 */
+ (NSURLSessionDataTask *)doTaskWithURL:(NSString*)url
                               parameters:(NSDictionary*)parameters
                                  success:(void (^)(id data))successBlock
                                  failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock
                                    error:(void (^)(NSError *error))errorBlock;

@end
