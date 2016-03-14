//
//  TFHotfixService.h
//  TFHotfixLib
//
//  Created by Chen Hao 陈浩 on 15/10/22.
//  Copyright © 2015年 Chen Hao 陈浩. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFHotfixInfoModel.h"

@interface HotFixReq : NSObject

/**
 *  app的id
 */
@property (strong, nonatomic) NSString *appId;

/**
 *  app版本
 */
@property (strong, nonatomic) NSString *appVersion;

/**
 *  hotfix脚本版本
 */
@property (strong, nonatomic) NSString *shotVersion;

/**
 *  平台类型
 */
@property (strong, nonatomic) NSString *type;  

@end

@interface TFHotfixService : NSObject

/**
 *  初始化CXHotfixService
 *
 *  @return CXHotfixService实例
 */
+ (TFHotfixService *)shareInstance;

/**
 *  检查服务器端最新HotFix脚本
 *
 *  @param req          请求参数
 *  @param successBlock 成功回调
 *  @param failureBlock 失败回调
 *
 *  @return AFHTTPRequestOperation
 */
- (void)getHotFixInfoWithParameter:(HotFixReq*)req
                           success:(void (^)(TFHotfixInfoModel * hotFixInfoModel))successBlock
                           failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock;

/**
 *  下载方法
 *
 *  @param URLString    下载地址
 *  @param fileName     下载文件名
 *  @param successBlock 下载成功Block
 *  @param failureBlock 下载失败Block
 */
-(void)downloadFileFromURL:(NSString *)URLString
                  fileName:(NSString *)fileName
                   success:(void (^)(void))successBlock
                   failure:(void (^)(NSError *error))failureBlock;

@end
