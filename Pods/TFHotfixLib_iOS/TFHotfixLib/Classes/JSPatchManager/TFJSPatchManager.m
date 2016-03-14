//
//  TFJSPatchManager.m
//  TFHotfixLib
//
//  Created by Chen Hao 陈浩 on 15/10/22.
//  Copyright © 2015年 Chen Hao 陈浩. All rights reserved.
//

#import "TFJSPatchManager.h"
#import "TFHotfixService.h"
#import <JSPatch/JPEngine.h>
#import <objc/runtime.h>
#import "Aspects.h"
#import <TFDownloadManager.h>
#import "TFHotfixPlistManager.h"
#import <TFBaseUtil+AES.h>

@implementation TFJSPatchManager

static Byte key[] = {0xA, 0xB, 0xC, 0, 1, 2, 3, 0xD, 0xE, 0xF, 4, 5, 6, 7, 8, 9};

/**
 *  程序启动执行
 */
+ (void)load
{
    [super load];
    [TFJSPatchManager shareInstance];
}

/**
 *  初始化CXJSPatchManager
 *
 *  @return CXJSPatchManager实例
 */
+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    static TFJSPatchManager *shareInstance;
    dispatch_once(&onceToken, ^{
        shareInstance = [[TFJSPatchManager alloc]init];
    });
    return shareInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self trackAppdelegate];
    }
    return self;
}

#pragma mark - 私有方法 -

/**
 *  使用aop在AppDelegate中执行JSPatch
 */
- (void)trackAppdelegate
{
    [NSClassFromString(@"AppDelegate")
     aspect_hookSelector:@selector(application:didFinishLaunchingWithOptions:)
     withOptions:AspectPositionAfter
     usingBlock:^(id<AspectInfo> aspectInfo, id application, id launchOptions){
         
         [self checkAndDownloadJSFile];
         [self implementJS];
     }
     error:NULL];
}

/**
 *  获取热更新请求参数
 *
 *  @return 热更新请求参数
 */
- (HotFixReq *)getHotFixReq
{
    HotFixReq *hotFixReq = [[HotFixReq alloc]init];
    hotFixReq.appId = [TFHotfixPlistManager sharedManager].appId?:@"";
    hotFixReq.appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]?:@"";
    hotFixReq.shotVersion = [TFHotfixInfoModel getHotfixInfoModel].shot_version?:@"";
    hotFixReq.type = @"ios";
    return hotFixReq;
}

/**
 *  检查js文件更新并下载
 */
- (void)checkAndDownloadJSFile
{
    [[TFHotfixService shareInstance]getHotFixInfoWithParameter:[self getHotFixReq]
                                                       success:^(TFHotfixInfoModel *hotFixInfoModel) {
                                                           
                                                           [[TFHotfixService shareInstance]downloadFileFromURL:hotFixInfoModel.file_url
                                                                                                      fileName:@"main.js"
                                                                                                       success:^{
                                                                                                           NSLog(@"下载热更新文件成功");
                                                                                                       }
                                                                                                       failure:^(NSError *error) {
                                                                                                           NSLog(@"下载热更新文件失败");
                                                                                                       }];
                                                           
                                                       } failure:^(int errorCode, NSString *errorMessage) {
                                                           
                                                           NSLog(@"%@",errorMessage);
                                                       }];
}

/**
 *  使用JSPatch执行js文件
 */
- (void)implementJS
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];//Documents目录
    NSString *sourcePath = [[documentsDirectory stringByAppendingPathComponent:@"Download"] stringByAppendingPathComponent:@"main.js"];
    if ([[NSFileManager defaultManager]fileExistsAtPath:sourcePath])
    {
        [JPEngine startEngine];
        NSString *encryptScript = [NSString stringWithContentsOfFile:sourcePath encoding:NSUTF8StringEncoding error:nil];
        NSString *deCryptScript =  [TFBaseUtil aes256Decrypt:encryptScript keyByte:key];
        [JPEngine evaluateScript:deCryptScript];
    }
}

@end
