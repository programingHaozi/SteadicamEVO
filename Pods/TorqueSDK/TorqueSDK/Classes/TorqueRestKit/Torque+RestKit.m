//
//  Torque+RestKit.m
//  TorqueSDK
//
//  Created by zhangjipeng on 2/4/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import "Torque+RestKit.h"
#import <objc/runtime.h>
#import "TorqueNetworkConfig.h"

@implementation Torque (RestKit)

@dynamic manager;
@dynamic ResponseDescriptors;
@dynamic RequestDescriptors;

- (RKObjectManager *)manager {
    return [RKObjectManager sharedManager];
}

- (NSMutableDictionary *)ResponseDescriptors {
    NSMutableDictionary *dic = objc_getAssociatedObject(self, @selector(ResponseDescriptors));
    if (!dic) {
        dic = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, @selector(ResponseDescriptors), dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return dic;
}

- (NSMutableDictionary *)RequestDescriptors {
    NSMutableDictionary *dic = objc_getAssociatedObject(self, @selector(RequestDescriptors));
    if (!dic) {
        dic = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, @selector(RequestDescriptors), dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return dic;
}

- (void)responseDescriptorWithMapping:(RKMapping *)mapping
                               method:(RKRequestMethod)method
                                 path:(NSString *)path
                          pathPattern:(NSString *)pathPattern
                              keyPath:(NSString *)keyPath
                          statusCodes:(NSIndexSet *)statusCodes {
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping
                                                                                            method:method
                                                                                       pathPattern:pathPattern
                                                                                           keyPath:keyPath
                                                                                       statusCodes:statusCodes];
    [self.ResponseDescriptors setObject:responseDescriptor forKey:path];
}

- (void)requestDescriptorWithMapping:(RKMapping *)mapping
                         objectClass:(Class)objectClass
                              method:(RKRequestMethod)method
                                path:(NSString *)path
                         rootKeyPath:(NSString *)keyPath {
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:mapping
                                                                                   objectClass:objectClass
                                                                                   rootKeyPath:keyPath
                                                                                        method:method];
    [self.RequestDescriptors setObject:requestDescriptor forKey:path];
}


- (void)createDescriptors {

}

- (void)addResponseDescriptorToManagerForPath:(NSString *)path {
    RKResponseDescriptor *rd = [self.ResponseDescriptors objectForKey:path];
    [self.manager addResponseDescriptor:rd];
}

- (void)removeResponseDescriptorFromManagerForPath:(NSString *)path {
    RKResponseDescriptor *rd = [self.ResponseDescriptors objectForKey:path];
    [self.manager removeResponseDescriptor:rd];
}

- (void)addRequestDescriptorToManagerForPath:(NSString *)path {
    RKRequestDescriptor *rd = [self.RequestDescriptors objectForKey:path];
    [self.manager addRequestDescriptor:rd];
}

- (void)removeRequestDescriptorFromManagerForPath:(NSString *)path {
    RKRequestDescriptor *rd = [self.RequestDescriptors objectForKey:path];
    [self.manager removeRequestDescriptor:rd];
}

- (void)getObjectsAtPath:(NSString *)path
              parameters:(NSDictionary *)parameters
                 success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
                 failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure {
    [self addResponseDescriptorToManagerForPath:path];
    [self.manager getObjectsAtPath:path
                        parameters:parameters
                           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                               [self removeResponseDescriptorFromManagerForPath:path];
                               success(operation, mappingResult);
                           } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                               [self removeResponseDescriptorFromManagerForPath:path];
                               failure(operation, error);
                           }];
}

- (void)postObject:(id)object
              path:(NSString *)path
        parameters:(NSDictionary *)parameters
           success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
           failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure {
    [self postObject:object path:path parameters:parameters needResponseMapping:NO success:success failure:failure];
}
- (void)postObject:(id)object
              path:(NSString *)path
        parameters:(NSDictionary *)parameters
      needResponseMapping:(BOOL)needResponse
           success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
           failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure {
    [self addRequestDescriptorToManagerForPath:path];
    if (needResponse) {
        [self addResponseDescriptorToManagerForPath:path];
    }
    [self.manager postObject:object
                        path:path
                  parameters:parameters
                     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                         [self removeRequestDescriptorFromManagerForPath:path];
                         if (needResponse) {
                             [self removeResponseDescriptorFromManagerForPath:path];
                         }
                         success(operation, mappingResult);
                     } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                         [self removeRequestDescriptorFromManagerForPath:path];
                         if (needResponse) {
                             [self removeResponseDescriptorFromManagerForPath:path];
                         }
                         failure(operation, error);
                     }];
}

- (void)writeActionLogToServer:(ActionLogItem *)actionLogItem  completion:(void (^)(TorqueResult *result))completion {
    TorqueResult *result = [TorqueResult new];
    
    // Action log
    RKObjectMapping *actionLogMapping = [RKObjectMapping requestMapping];
    [actionLogMapping addAttributeMappingsFromDictionary:@{@"deviceId" : @"device_id",
                                                           @"actionType" : @"name",
                                                           @"parameter" : @"parameter"}];
    [self requestDescriptorWithMapping:actionLogMapping
                           objectClass:[ActionLogItem class]
                                method:RKRequestMethodPOST
                                  path:kActionLog
                           rootKeyPath:nil];
    
    [self postObject:actionLogItem
                path:kActionLog
          parameters:nil
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 TorqueError *error = [[mappingResult dictionary] objectForKey:@"status"];
                 result.message = error.errorMessage;
                 if (error.errorCode == 0) {
                     result.succeed = YES;
                     result.result = 0;
                 } else if (error.errorCode == 401) {
                     result.result = TorqueSDK_NerWorkOther;//-1;
                 }
                 if (completion) {
                     completion(result);
                 }
             } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 result.result = TorqueSDK_NetWorkFailed;//-1;
                 result.message = error.localizedDescription;
                 result.error = error;
                 if (completion) {
                     completion(result);
                 }
                 DDLogDebug(@"写Actionlog到数据库失败,%@",result.message);
             }];
}

@end
