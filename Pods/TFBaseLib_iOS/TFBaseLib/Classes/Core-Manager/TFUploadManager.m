//
//  TFUploadManager.m
//  TFBaseLib
//
//  Created by xiayiyong on 15/10/9.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFUploadManager.h"

#define  KEY_URLString     @"URLString"
#define  KEY_operation      @"operation"

@interface TFUploadManager ()

@property (nonatomic, strong) NSMutableArray *paths;
@property (nonatomic, assign) UploadProgress uploadProgress;
@end

@implementation TFUploadManager

+ (instancetype)sharedManager
{
    static TFUploadManager *sharedInstance=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TFUploadManager alloc] init];
    });
    return sharedInstance;
}

- (NSMutableArray *)paths
{
    if (!_paths)
    {
        _paths = [[NSMutableArray alloc] init];
    }
    
    return _paths;
}

#pragma mark - 类方法

+ (unsigned long long)fileSizeForPath:(NSString *)path
{
    return [[self alloc] fileSizeForPath:path];
}

+(void)uploadFileToURL:(NSString *)URLString
               fileData:(NSData *)fileData
             httpMethod:(NSString *)method
               progress:(UploadProgress)progressBlock
                success:(void (^)(id backData))successBlock
                failure:(void (^)(NSError *error))failureBlock;
{
    return [[self class]uploadFileToURL:URLString
                                fileData:fileData
                              httpMethod:method
                                progress:progressBlock
                                 success:successBlock
                                 failure:failureBlock];
}

+ (void)pauseWithURL:(NSString *)URLString
{
    [[self class] pauseWithURL:URLString];
}

+ (void)cancelWithURL:(NSString *)URLString
{
    [[self class] cancelWithURL:URLString];
}

#pragma mark - 实例方法

- (unsigned long long)fileSizeForPath:(NSString *)path
{
    
    signed long long fileSize = 0;
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    if ([fileManager fileExistsAtPath:path])
    {
        
        NSError *error = nil;
        
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        
        if (!error && fileDict)
        {
            
            fileSize = [fileDict fileSize];
        }
    }
    
    return fileSize;
}

-(void)uploadFileToURL:(NSString *)URLString
               fileData:(NSData *)fileData
             httpMethod:(NSString *)method
               progress:(UploadProgress)progressBlock
                success:(void (^)(id backData))successBlock
                failure:(void (^)(NSError *error))failureBlock
{
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:method URLString:URLString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        nil;
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

    self.uploadProgress = progressBlock;
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request
                                                               fromData:fileData
                                                               progress:^(NSProgress *uploadProgress) {
                                                                   
                                                               }
                                                                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)  {
                                                                      
                                                                      if (error)
                                                                      {
                                                                          NSLog(@"Error: %@", error);
                                                                          
                                                                          if (failureBlock)
                                                                          {
                                                                              failureBlock(error);
                                                                          }
                                                                      }
                                                                      else
                                                                      {
                                                                          NSLog(@"%@", responseObject);
                                                                          
                                                                          if (successBlock)
                                                                          {
                                                                              successBlock(responseObject);
                                                                          }
                                                                      }
                                                                  }];

    NSDictionary *dicNew = @{
                             KEY_URLString   : URLString,
                             KEY_operation   : uploadTask
                             };
    [self.paths addObject:dicNew];
    
    [uploadTask resume];
}

- (void)pauseWithURL:(NSString *)URLString
{
    for (NSDictionary *dic in self.paths)
    {
        if ([URLString isEqualToString:dic[KEY_URLString]])
        {
            id operation=dic[KEY_operation];
            if ([operation isKindOfClass:[NSURLSessionUploadTask  class]])
            {
                [operation suspend];
            }
        }
    }
}

- (void)cancelWithURL:(NSString *)URLString
{
    for (NSDictionary *dic in self.paths)
    {
        if ([URLString isEqualToString:dic[KEY_URLString]])
        {
            id operation=dic[KEY_operation];
            if ([operation isKindOfClass:[NSURLSessionUploadTask  class]])
            {
                [operation cancel];
            }
            
            [self.paths removeObject:dic];
        }
    }
}

@end

