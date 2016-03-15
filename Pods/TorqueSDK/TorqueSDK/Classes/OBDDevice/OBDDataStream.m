//
//  OBDDataStream.m
//  TorqueSDK
//
//  Created by zhangjipeng on 1/28/15.
//  Copyright (c) 2015 chexiang. All rights reserved.
//

#import "OBDDataStream.h"
#import "OBDDataItem.h"
#import <CocoaLumberjack.h>
#import "Torque.h"

#define configFileNameBy(type) [NSString stringWithFormat:@"%ld",(long)type]

@implementation OBDDataStream

- (NSDictionary *)readConfigFileForType:(OBDDataStreamType)type {
    NSString *resourceName = [NSString stringWithFormat:@"DataStreamConfig%@",kDeviceName];
    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:resourceName ofType:@"bundle"];
    if (resourcePath.length > 0) {
        NSBundle *bundle = [[NSBundle alloc] initWithPath:resourcePath];
        NSString *fileName = configFileNameBy(type);
        NSString *filePath = [bundle pathForResource:fileName ofType: @"json"];
        
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        if (!data) {
            //NSLog(@"the datastream config file %@.json not found!",fileName);
            return nil;
        }
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        return dictionary;
    } else {
        NSLog(@"the bundle %@ not found!",resourceName);
        return nil;
    }
}


- (instancetype)initWithType:(OBDDataStreamType)type {
    if (self = [super init]) {
        NSDictionary *dic = [self readConfigFileForType:type];
        if (!dic) {
            //DDLogWarn(@"read datastream config file %ld.json failed!", (long)type);
            return nil;
        }
        _type = [[dic objectForKey:@"type"] integerValue];
        _command = [NSString stringWithString:[dic objectForKey:@"command"]];
        _name = [NSString stringWithString:[dic objectForKey:@"name"]];
        _splitString = [NSString stringWithString:[dic objectForKey:@"split"]];
        _dataHead = [NSString stringWithString:[dic objectForKey:@"dataHead"]];
        _disposable = [[dic objectForKey:@"disposable"] boolValue];
        NSArray *items = [dic objectForKey:@"items"];
        NSMutableArray *itemObjects = [NSMutableArray array];
        for (NSDictionary *item in items) {
            OBDDataItem *itemObject = [[OBDDataItem alloc] initWithDictionary:item];
            [itemObjects addObject:itemObject];
        }
        _items = itemObjects;
    }
    return self;
}

@end
