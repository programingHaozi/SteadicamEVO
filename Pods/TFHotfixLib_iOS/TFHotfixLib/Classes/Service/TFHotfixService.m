//
//  TFHotfixService.m
//  TFHotfixLib
//
//  Created by Chen Hao 陈浩 on 15/10/22.
//  Copyright © 2015年 Chen Hao 陈浩. All rights reserved.
//

#import "TFHotfixService.h"
#import "TFHotfixPlistManager.h"
#import <MJExtension/MJExtension.h>
#import <AFNetworking/AFHTTPSessionManager.h>

//获取hotfix更新信息
#define GET_HOTFIX_VERSION                    @"/service/upgrade/getUpgradeVersion/0"

@implementation HotFixReq
@end

@implementation TFHotfixService

/**
 *  初始化CXHotfixService
 *
 *  @return CXHotfixService实例
 */
+ (TFHotfixService *)shareInstance
{
    static TFHotfixService *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TFHotfixService alloc] init];
    });
    return instance;
}

/**
 *  拼接热更新接口地址
 *
 *  @return 热更新接口地址
 */
- (NSString *)hotFix_url
{
    NSString *url = [NSString stringWithFormat:@"%@%@",[TFHotfixPlistManager sharedManager].serverUrl,GET_HOTFIX_VERSION];
    return url;
}

/**
 *  检查服务器端最新HotFix脚本
 *
 *  @param req          请求参数
 *  @param successBlock 成功回调
 *  @param failureBlock 失败回调
 *
 *  @return AFHTTPRequestOperation
 */
- (void)getHotFixInfoWithParameter:(HotFixReq *)req
                           success:(void (^)(TFHotfixInfoModel *))successBlock
                           failure:(void (^)(int, NSString *))failureBlock {
    NSDictionary *parameters = @{
                                 @"app_id"      :req.appId,
                                 @"app_version" :req.appVersion,
                                 @"shot_version":req.shotVersion,
                                 @"type"        :req.type
                                 };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    
    [manager POST:[self hotFix_url]
       parameters:parameters
          success:^(NSURLSessionDataTask *operation, NSDictionary * responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        int errCode = [[responseObject objectForKey:@"errorCode"] intValue];
        NSDictionary *resultData = [responseObject objectForKey:@"result"];
        
        if (errCode == 0 && resultData)
        {
            TFHotfixInfoModel *hotFixInfoModel = [TFHotfixInfoModel mj_objectWithKeyValues:resultData];
            [TFHotfixInfoModel saveHotfixInfoModel:hotFixInfoModel];
            if (successBlock)
            {
                successBlock(hotFixInfoModel);
            }
        }
        else
        {
            NSString *errMessage = [responseObject objectForKey:@"errorMessage"];
            if (failureBlock)
            {
                failureBlock(errCode, errMessage);
            }
        }
    }
          failure:^(NSURLSessionDataTask *operation, NSError *error) {
              if (failureBlock)
              {
                  failureBlock(-1, @"网络出错");
              }
          }];
    
}

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
                   failure:(void (^)(NSError *error))failureBlock
{
    // 1.创建网络管理者
    // AFHTTPSessionManager 基于NSURLSession
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 2.利用网络管理者下载数据
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    /*
     destination
     - targetPath: 系统给我们自动写入的文件路径
     - block的返回值, 要求返回一个URL, 返回的这个URL就是剪切的位置的路径
     completionHandler
     - url :destination返回的URL == block的返回的路径
     */
    /*
     @property int64_t totalUnitCount;  需要下载文件的总大小
     @property int64_t completedUnitCount; 当前已经下载的大小
     */
    //    NSProgress *progress = nil;
    NSURLSessionDownloadTask *downTask = [manager downloadTaskWithRequest:request
                                                                 progress:nil
                                                              destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                                                  
                                                                  NSFileManager *fileManager = [NSFileManager defaultManager];
                                                                  
                                                                  NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
                                                                  
                                                                  NSString *fileDir = [NSString stringWithFormat:@"%@/Download", docPath];
                                                                  
                                                                  BOOL isDir = NO;
                                                                  
                                                                  BOOL existed = [fileManager fileExistsAtPath:fileDir isDirectory:&isDir];
                                                                  
                                                                  if (!(isDir == YES && existed == YES))
                                                                  {
                                                                      [fileManager createDirectoryAtPath:fileDir
                                                                             withIntermediateDirectories:YES
                                                                                              attributes:nil
                                                                                                   error:nil];
                                                                  }
                                                                  
                                                                  NSString *filePath = [fileDir stringByAppendingPathComponent:fileName];
                                                                  
                                                                  return [NSURL fileURLWithPath:filePath];
                                                                  
                                                              }
                                                        completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                                                            
                                                            NSLog(@"%@",filePath.absoluteString);
                                                            
                                                            if (error)
                                                            {
                                                                if (failureBlock)
                                                                {
                                                                    failureBlock(error);
                                                                }
                                                            }
                                                            else
                                                            {
                                                                if (successBlock)
                                                                {
                                                                    successBlock();
                                                                }
                                                            }
                                                            
                                                        }];
    
    /*
     要跟踪进度，需要使用 NSProgress，是在 iOS 7.0 推出的，专门用来跟踪进度的类！
     NSProgress只是一个对象！如何跟踪进度！-> KVO 对属性变化的监听！
     @property int64_t totalUnitCount;        总单位数
     @property int64_t completedUnitCount;    完成单位数
     */
    // 给Progress添加监听 KVO
    //    [progress addObserver:self forKeyPath:@"completedUnitCount" options:NSKeyValueObservingOptionNew context:nil];
    
    // 3.启动任务
    [downTask resume];
    
}


@end
