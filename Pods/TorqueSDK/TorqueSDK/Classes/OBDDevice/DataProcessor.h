//
//  DataProcessor.h
//  OBD-DEMO
//
//  Created by zhangjipeng on 1/26/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import "Torque.h"
#import "OBDDataStream.h"
#import "OBDDeviceSelfDefineType.h"
#import "Connector.h"

@interface DataProcessor : Torque

@property (nonatomic, strong) id<Connector> connector;
@property (nonatomic, assign) OBDMode obdMode;

@property (nonatomic, copy) void (^dataReceived)(NSString *);
@property (nonatomic, copy) void (^errorHandler)(NSString *);
@property (nonatomic, copy) void(^log)(NSString *value);
@property (nonatomic, strong, readonly) NSDictionary *errors;


- (void)fetchDataStreamForType:(OBDDataStreamType)type AndParam:(NSString*)param completion:(void (^)(OBDDataStream *stream, NSError *error))completion;
- (void)closeDataStreamForType:(OBDDataStreamType)type;
- (void)closeSpecialDataStreamForType:(OBDDataStreamType)type;

- (void)suspendDataStreamForType:(OBDDataStreamType)type;
- (void)resumeDataStreamForType:(OBDDataStreamType)type;

- (void)upgradeHandshake:(void (^)(OBDDataStream *stream, NSError *error))completion;
- (void)upgradeSendPackage:(NSData *)package completion:(void (^)(OBDDataStream *stream, NSError *error))completion;
- (void)upgradeSendPackageCompleted:(void (^)(OBDDataStream *stream, NSError *error))completion;
- (void)upgradeSendBinFileLength:(UInt16)length completion:(void (^)(OBDDataStream *stream, NSError *error))completion;
- (void)upgradeSendBinFileCompleted:(void (^)(OBDDataStream *stream, NSError *error))completion;

- (void)requestPID:(NSString *)pid completion:(void (^)(NSString *value, NSError *error))completion;

@end
