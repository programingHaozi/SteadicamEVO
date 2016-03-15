//
//  Torque+RestKit.h
//  TorqueSDK
//
//  Created by zhangjipeng on 2/4/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import "Torque.h"
#import "RestKit.h"
#import "ActionLogItem.h"

@interface Torque (RestKit)

@property (nonatomic, strong, readonly) RKObjectManager *manager;
@property (nonatomic, strong, readonly) NSMutableDictionary *ResponseDescriptors;
@property (nonatomic, strong, readonly) NSMutableDictionary *RequestDescriptors;

- (void)responseDescriptorWithMapping:(RKMapping *)mapping
                                       method:(RKRequestMethod)method
                                         path:(NSString *)path
                                  pathPattern:(NSString *)pathPattern
                                      keyPath:(NSString *)keyPath
                                  statusCodes:(NSIndexSet *)statusCodes;
- (void)requestDescriptorWithMapping:(RKMapping *)mapping
                         objectClass:(Class)objectClass
                              method:(RKRequestMethod)method
                                path:(NSString *)path
                         rootKeyPath:(NSString *)keyPath;
- (void)createDescriptors;
- (void)getObjectsAtPath:(NSString *)path
              parameters:(NSDictionary *)parameters
                 success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
                 failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;
- (void)postObject:(id)object
              path:(NSString *)path
        parameters:(NSDictionary *)parameters
           success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
           failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;
- (void)postObject:(id)object
              path:(NSString *)path
        parameters:(NSDictionary *)parameters
      needResponseMapping:(BOOL)needResponse
           success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
           failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;

/**
 *  写一条Actionlog到服务端数据库
 *
 *  @param actionLogItem ActionLogItem对象
 */
- (void)writeActionLogToServer:(ActionLogItem *)actionLogItem  completion:(void (^)(TorqueResult *result))completion;
@end
