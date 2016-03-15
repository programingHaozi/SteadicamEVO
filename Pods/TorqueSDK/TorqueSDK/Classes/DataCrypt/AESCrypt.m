//
//  NSData+AES256.m
//  AES
//
//  Created by Henry Yu on 2009/06/03.
//  Copyright 2010 Sevensoft Technology Co., Ltd.(http://www.sevenuc.com)
//  All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain


//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import "AESCrypt.h"
#import "NSData+Base64.h"

const NSUInteger kAlgorithmKeySize = kCCKeySizeAES128;
const NSUInteger kPBKDFRounds = 10000;  // ~80ms on an iPhone 4

static Byte saltBuff[] = {0,1,2,3,4,5,6,7,8,9,0xA,0xB,0xC,0xD,0xE,0xF};

static Byte ivBuff[]   = {0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00};
static Byte key[] = {0xA, 0xB, 0xC, 0, 1, 2, 3, 0xD, 0xE, 0xF, 4, 5, 6, 7, 8, 9};

@implementation AESCrypt

+ (NSData *)aesKeyForPassword:(NSString *)password{                  //Derive a key from a text password/passphrase
    
    NSMutableData *derivedKey = [NSMutableData dataWithLength:kAlgorithmKeySize];
    
    NSData *salt = [NSData dataWithBytes:saltBuff length:kCCKeySizeAES128];
    
    int result = CCKeyDerivationPBKDF(kCCPBKDF2,        // algorithm算法
                                  password.UTF8String,  // password密码
                                  password.length,      // passwordLength密码的长度
                                  salt.bytes,           // salt内容
                                  salt.length,          // saltLen长度
                                  kCCPRFHmacAlgSHA1,    // PRF
                                  kPBKDFRounds,         // rounds循环次数
                                  derivedKey.mutableBytes, // derivedKey
                                  derivedKey.length);   // derivedKeyLen derive:出自
    
    NSAssert(result == kCCSuccess,
             @"Unable to create AES key for spassword: %d", result);
    return derivedKey;
}



/*加密方法*/
+ (NSString *)aes256Encrypt:(NSString *)message password:(NSString *)password
{
    return [self aes256Encrypt:message keyByte:[[self aesKeyForPassword:password] bytes]];
}


/*解密方法*/
+ (NSString *)aes256Decrypt:(NSString *)base64EncodedString password:(NSString *)password
{
   return [self aes256Decrypt:base64EncodedString keyByte:[[self aesKeyForPassword:password] bytes]];
}


+ (NSString *)aes256Encrypt:(NSString *)message keyByte:(const void *)keyByte
{
    NSData *plainText = [message dataUsingEncoding:NSUTF8StringEncoding];
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES128+1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    NSUInteger dataLength = [plainText length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    bzero(buffer, sizeof(buffer));
    
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,kCCOptionPKCS7Padding,
                                          keyByte, kCCKeySizeAES128,
                                          ivBuff /* initialization vector (optional) */,
                                          [plainText bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *encryptData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        return [encryptData base64Encoding];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

+ (NSString *)aes256Decrypt:(NSString *)base64EncodedString keyByte:(const void *)keyByte
{
    NSData *cipherData = [NSData dataWithBase64EncodedString:base64EncodedString];
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES128+1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    NSUInteger dataLength = [cipherData length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyByte, kCCKeySizeAES128,
                                          ivBuff ,/* initialization vector (optional) */
                                          [cipherData bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        NSData *encryptData = [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
        return [[NSString alloc] initWithData:encryptData encoding:NSUTF8StringEncoding];
    }
    
    free(buffer); //free the buffer;
    return nil;
}



+ (NSString *)aes256Encrypt:(NSString *)message
{
    return [self aes256Encrypt:message keyByte:key];
}

+ (NSString *)aes256Decrypt:(NSString *)base64EncodedString
{
   return  [self aes256Decrypt:base64EncodedString keyByte:key];
}
@end
