//
//  TorqueRestKit.m
//  TorqueSDK
//
//  Created by zhangjipeng on 2/4/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import "TorqueRestKit.h"
#import "CoreData.h"
#import "RestKit.h"
#import "NSString+Base64.h"
#import "TorqueGlobal.h"
#import "TorqueCommon.h"

#define kTorqueModel @"TorqueModel"



static TorqueRestKit *restKit = nil;


@interface TorqueRestKit()

@property (nonatomic,strong) AFHTTPClient10* client;

@end

@implementation TorqueRestKit

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        restKit = [[TorqueRestKit alloc] init];
    });
    return restKit;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self config];
    }
    
    return self;
}

- (void)setHeader:(HttpHeader *)header{
    //添加token
    [[TorqueRestKit sharedInstance] updateClientHttpHeader:self.client httpHeader:header];
}


-(void)updateClientHttpHeader:(AFHTTPClient10 *)client httpHeader:(HttpHeader *)httpHeader {
    if (httpHeader) {
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:httpHeader.token forKey:@"userToken"];
        
        [client setDefaultHeader:@"torquehead" value:[NSString jsonStringWithDictionary:dict]];
    }
}
#define kRESTKitTrace
- (void)config{
    //    屏蔽映射对象和网络请求的error 以外的log
#ifdef kRESTKitTrace
    RKLogConfigureByName("RestKit/Network*", RKLogLevelWarning);
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelInfo);
#endif
    //let AFNetworking manage the activity indicator
    [AFNetworkActivityIndicatorManager10 sharedManager].enabled = YES;
    
    // Initialize HTTPClient
    NSURL *baseURL = [NSURL URLWithString:[TorqueGlobal sharedInstance].serverUrl];
    AFHTTPClient10 *client = [[AFHTTPClient10 alloc] initWithBaseURL:baseURL];
    
    self.client = client;
    
    //we want to work with JSON-Data
    [client setDefaultHeader:@"Accept" value:RKMIMETypeJSON];
    client.allowsInvalidSSLCertificate = YES;
    
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:baseURL];
    manager.HTTPClient = client;
    
    [client setDefaultHeader:@"User-Agent" value:[NSString stringWithFormat:@"%@/%@ (iOS %@/SDK %@)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleIdentifierKey], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey], [[NSProcessInfo processInfo] operatingSystemVersionString],[[TorqueCommon sharedInstance] version].version]];
    
    //we want to work with JSON-Data
    [client setDefaultHeader:@"Accept" value:RKMIMETypeJSON];
    
    // 添加网络状态监测
    [[TorqueGlobal sharedInstance] motionNetwork];
    
//    NSString *modelPath = [[NSBundle mainBundle] pathForResource:kTorqueModel ofType:@"bundle"];
//    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:@[[NSBundle bundleWithPath:modelPath]]];
//    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
//    manager.managedObjectStore = managedObjectStore;
    
    
    
    RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[TorqueError class]];
    [errorMapping addAttributeMappingsFromArray:@[@"errorCode", @"errorMessage"]];
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKResponseDescriptor *errorDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:errorMapping
                                                                                         method:RKRequestMethodAny
                                                                                    pathPattern:nil
                                                                                        keyPath:@"status"
                                                                                    statusCodes:statusCodes];
    [manager addResponseDescriptorsFromArray:@[errorDescriptor]];
}

@end
