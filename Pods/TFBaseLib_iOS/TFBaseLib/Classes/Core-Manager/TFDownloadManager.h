//
//  TFDownloadManager.h
//  TFBaseLib
//
//  Created by xiayiyong on 15/10/9.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^DownloadProgress)(CGFloat progress, CGFloat totalMBRead, CGFloat totalMBExpectedToRead);

@interface TFDownloadManager : NSObject

#define kTFDownloadManager  ([TFDownloadManager sharedManager])

+ (instancetype) sharedManager;

#pragma mark - 类方法

/**
 *  获取文件大小
 *
 *  @param path 本地路径
 *
 *  @return 文件大小
 */
+ (unsigned long long)fileSizeForPath:(NSString *)path;

/**
 *  开始下载文件
 *
 *  @param URLString     文件链接
 *  @param path          本地路径
 *  @param progress 进度回调
 *  @param success  成功回调
 *  @param failure  失败回调
 *
 *  @return 下载任务
 */
+ (void)downloadFileFromURL:(NSString *)URLString
                                       fileName:(NSString *)fileName
                                  progress:(DownloadProgress)progressBlock
                                        success:(void (^)(void))successBlock
                                        failure:(void (^)(NSError *error))failureBlock;

/**
 *  取消请求根据url
 *
 *  @param URLString 要取消的URL
 */
+ (void)cancelWithURL:(NSString *)URLString;

#pragma mark - 实例方法

/**
 *  获取文件大小
 *
 *  @param path 本地路径
 *
 *  @return 文件大小
 */
- (unsigned long long)fileSizeForPath:(NSString *)path;

/**
 *  开始下载文件
 *
 *  @param URLString     文件链接
 *  @param path          本地路径
 *  @param progressBlock 进度回调
 *  @param successBlock  成功回调
 *  @param failureBlock  失败回调
 *
 *  @return 下载任务
 */
- (void)downloadFileFromURL:(NSString *)URLString
                                       fileName:(NSString *)fileName
                                  progress:(DownloadProgress)progressBlock
                                        success:(void (^)(void))successBlock
                                        failure:(void (^)(NSError *error))failureBlock;

/**
 *  暂停下载文件
 *
 *  @param operation 下载任务
 */
- (void)pauseWithURL:(NSString *)URLString;

/**
 *  停止下载文件
 *
 *  @param operation 下载任务
 */
- (void)cancelWithURL:(NSString *)URLString;


@end

