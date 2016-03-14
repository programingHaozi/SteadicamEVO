//
//  TFBaseUtil+Identifier.m
//  TFBaseLib
//
//  Created by xiayiyong on 15/10/16.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AdSupport/AdSupport.h>
#import "TFBaseUtil+Identifier.h"

#define kIsStringValid(text) (text && text!=NULL && text.length>0)

#define UUID_STRING @"com.saike.tfbaselib.uuid"   //设置你idfa的Keychain标示,该标示相当于key,而你的IDFA是value

NSString *tf_uniqueIdentifier(void)
{
    return [TFBaseUtil uniqueIdentifier];
}

@implementation TFBaseUtil (Identifier)

#pragma mark -
#pragma mark Public Methods

/**
 idfa: 适用于对外：例如广告推广，换量等跨应用的用户追踪等，卸载同一厂商全部应用会重新生成，重置系统也会改变
 idfv: 适用于对内：例如分析用户在应用内的行为等，重置系统也会改变
 */
+ (NSString *)uniqueIdentifier
{
    //NSString *uuid = [[NSUUID UUID] UUIDString];
    //NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
    //NSString *identifierForAdvertising = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
    //NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    //0.读取keychain的缓存UUID
    NSString *uuid = [[self class] getCacheUUID];
    if (kIsStringValid(uuid))
    {
        return uuid;
    }
    else
    {
        //1.如果取不到,就生成新的UUID
        uuid = [[NSUUID UUID] UUIDString];
        [[self class] setCacheUUID:uuid];
        if (kIsStringValid(uuid))
        {
            return uuid;
        }
    }
    
    //3.再取不到尼玛我也没办法了,你牛B.
    return nil;
}

#pragma mark - UUID

+ (NSString*)getCacheUUID
{
    NSString *uuidStr = [[self class] load:UUID_STRING];
    if (kIsStringValid(uuidStr))
    {
        return uuidStr;
    }
    else
    {
        return nil;
    }
}

+ (BOOL)setCacheUUID:(NSString *)value
{
    if (kIsStringValid(value))
    {
        [[self class] save:UUID_STRING data:value];
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - Keychain

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service
{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)(kSecClassGenericPassword),kSecClass,
            service, kSecAttrService,
            service, kSecAttrAccount,
            kSecAttrAccessibleAfterFirstUnlock,kSecAttrAccessible,nil];
}

+ (void)save:(NSString *)service data:(id)data
{
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((__bridge CFDictionaryRef)(keychainQuery));
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data]
                      forKey:(__bridge id<NSCopying>)(kSecValueData)];
    SecItemAdd((__bridge CFDictionaryRef)(keychainQuery), NULL);
}

+ (id)load:(NSString *)service
{
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge id<NSCopying>)(kSecReturnData)];
    [keychainQuery setObject:(__bridge id)(kSecMatchLimitOne) forKey:(__bridge id<NSCopying>)(kSecMatchLimit)];
    
    CFTypeRef result = NULL;
    if (SecItemCopyMatching((__bridge_retained CFDictionaryRef)keychainQuery, &result) == noErr)
    {
        ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData*)result];
    }
    return ret;
}

+ (void)delete:(NSString *)service
{
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((__bridge CFDictionaryRef)(keychainQuery));
}

@end
